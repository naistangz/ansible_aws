# Creating a playbook and syncing our app to the VM

1. Create a `.yaml`/`.yml` file:
```bash
nano app.yml
```

2. Set out [commands](playbook.yml) to install dependencies such as nodejs and nginx 

3. Securely transfer the `app.yml` and the sample app folder to the AWS VM `192.168.33.12`:

**[This can be further automated in `.yml` file]**

```bash
scp -r app/ vagrant@192.168.33.10 = Web IP
scp app.yml vagrant@192.168.33.12 = AWS IP
```

4. Vagrant ssh into your `aws`VM as we will be using our AWS VM as the controller
```bash
vagrant ssh aws
```

5. Navigate to your ansible folder
```bash
cd /etc/ansible/
```

6. Type in tree to see all files in ansible folder:
```bash
vagrant@aws:/etc/ansible$ tree
.
├── ansible.cfg
├── hosts
├── app.yml
└── roles
```

7. Run in root user
```bash
sudo su
```

8. To run the playbook, type `ansible-playbook yamlfile.yml`
```bash
ansible-playbook app.yml
```

Open the browser and type in the following IP address:
```bash
192.168.33.10
```

9. Navigate to your app folder and run the app\
**[This step is unnecessary as these steps have been automated]**
```bash
cd /home/vagrant/app/
pm2 start app.js
```

10. If the following error occurs:
```bash
Error: listen EADDRINUSE :::3000
```

11. Type in then run **Step 9** again:
```bash
sudo killall -HUP mDNSResponder
or 
pm2 killall
or
pm2 stop app.js
```
---

## Setting up DB Enabling /posts 
1. Create another `.yaml` file called `db.yml`:
```bash
nano db.yml
```
2. Configure the `.yml` [file](db.yml)
3. Securely copy new `db.yml` to AWS

```bash
scpenvironment/ vagrant@192.168.33.12:
```

3. SSH into the `aws` VM
4. Navigate to ansible folder:
```bash
cd /etc/ansible
vagrant@aws:/etc/ansible$ tree
.
├── ansible.cfg
├── app.yml
├── db.yml
├── hosts
└── roles
```
5. Run `db.yml`:
```bash
ansible-playbook db.yml
```

6. Go to db server and check mongodb is enabled and running properly:
```bash
vagrant ssh db
or 
ssh vagrant@192.168.22.11
```
**Then**
```bash
sudo systemctl mongodb
```

7. If it is running, enter Web IP into the browser
```bash
ansible-playbook app.yml
```
```bash
192.168.33.10
```
8. Click on the following links:
[Home Page](http://192.168.33.10)
[Fibonacci](http://192.168.33.10/fibonacci/10)
[Posts](http://192.168.33.10/posts)


---

## Next iteration
1. Copy app folder without using `scp` and including it in the `.yaml` file.
2. Instead of using `sudo` command, use `become` when installing `nginx`. For example:
```yaml
---
- name: Install NGINX 
  become: yes
  apt: 
    name: nginx
    state: present

- name: Unlinking NGINX Default file
  become: yes
  command:
    cmd: unlink /etc/nginx/sites-enabled/default

- name: Create an NGINX Conf File
  become: yes
  file:
    path: /etc/nginx/sites-available/reverse_proxy.conf
    state: touch

- name: Amending NGINX Conf File
  become: yes
  blockinfile:
    path: /etc/nginx/sites-available/reverse_proxy.conf
    marker: ""
    block: |
      server {
          listen 80;
          location / {
              proxy_pass http://127.0.0.1:3000;
                  }
              }

- name: Link NGINX Reverse Proxy
  become: yes
  command:
    cmd: ls -s /etc/nginx/sites-available/reverse_proxy.conf /etc/nginx/sites-enabled/reverse_proxy.conf

- name: Making Sure NGINX Service is Running
  become: yes
  service:
    name: nginx
    state: restarted
    enabled: yes
```
