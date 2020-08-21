# Creating an AWS EC2 Instance using Ansible

## Prerequisites
```bash
sudo apt update
sudo apt-get install tree -y 
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
sudo apt install python3-pip - Python Package Manager
pip3 install awscli 
pip3 install boto boto3
```

**Verify ansible aws module has been installed:**
```bash
aws --version
> aws-cli/1.18.123 Python/3.8.3 Darwin/18.6.0 botocore/1.17.46
```

## Storing keys with Ansible vault
1. Use ansible vault to create a `.yml` file which will store aws access and secret keys
```bash
ansible-vault create aws_keys.yml
```

2. Once open type in a password then add following:
```bash
aws_access_key: THISISMYACCESSKEY
aws_secret_key: THISISMYSECRETKEY
```

**Note**: To save changes in `vim` type `:x` and press enter

3. Once saved, all the content will be encrypted. To verify, type in the following:
```bash
cat aws_keys.yml
```

4. Create/update the `hosts` file in `variables/hosts` to handle our new EC2 instance by adding to the `.hosts` file:
```bash
[local]
localhost
```

## Building the EC2 Instance 
1. Create a new `.yml` file called `aws_provisioning.yml`
```yaml
---
- hosts: local
  connection: local
  gather_facts: False
  vars:
    instance_type: t2.micro
    security_group: Eng67.Anais.Ansible.SG
    image: ami-08617e0e0b2d50721
    keypair: Eng67.Anais.key
    region: eu-west-1b
    count: 1

  vars_files:
    - aws_keys.yml
```

Here is the break down:
- `hosts`: limiting the scope of the playbook to the local hosts group
- `connection`: Ansible connects to Python boto on the local machine and is used to establish a connection with the AWS API and issue the commands. 
- `instance_type`: `t2.micro` free tier
- `security_group`: created on AWS
- `image`: Specifies the AMI (Amzon Machine Image). AMI's are like templates used to spawn machine instances.
- `keypair`: name of the public/private key created on AWS
- `region`: region of choice. It is advised to choose a region that is geographically closest to the user, in order to reduce network latency and enhane performance.
- `count`: the number of instances you need to launch

2. Generate `ssh` keys which will allow us to connect to the EC2 instance
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/anais_aws
```

3. To run ansible playbook type:
```bash
ansible-playbook aws_provisioning.yml --ask-vault-pass --tags create_ec2
```

## 2nd iteration
```yaml
# AWS playbook
---

- hosts: localhost
  connection: local
  gather_facts: False

  vars:
    key_name: anais_aws
    region: eu-west-1
    image: ami-0be56cd3f96f13208
    id: "web-app"
    sec_group: "sg-04661fa78d69b3b1d"
    subnet_id: "subnet-0c1038124fe96709a"

  tasks:

    - name: Facts
      block:

      - name: Get instances facts
        ec2_instance_facts:
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"
          region: "{{ region }}"
        register: result

      - name: Instances ID
        debug:
          msg: "ID: {{ item.instance_id }} - State: {{ item.state.name }} - Public DNS: {{ item.public_dns_name }}"
        loop: "{{ result.instances }}"

      tags: always


    - name: Provisioning EC2 instances
      block:

      - name: Upload public key to AWS
        ec2_key:
          name: "{{ key_name }}"
          key_material: "{{ lookup('file', '~/.ssh/{{ key_name }}.pub') }}"
          region: "{{ region }}"
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"


      - name: Provision instance(s)
        ec2:
          aws_access_key: "{{ec2_access_key}}"
          aws_secret_key: "{{ec2_secret_key}}"
          assign_public_ip: true
          key_name: "{{ key_name }}"
          id: "{{ id }}"
          vpc_subnet_id: "{{ subnet_id }}"
          group_id: "{{ sec_group }}"
          image: "{{ image }}"
          instance_type: t2.micro
          region: "{{ region }}"
          wait: true
          count: 1
          instance_tags:
            Name: Eng67.Anais.Ansible.WebApp

      tags: ['never', 'create_ec2']
```


