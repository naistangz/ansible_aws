# Creating a playbook and syncing our app to the VM

1. Create a `.yaml`/`.yml` file:
```bash
nano playbook.yml
```

2. Set out [commands](playbook.yml) to install dependencies such as nodejs and nginx 

3. Securely transfer the `playbook.yml` and the sample app folder to the AWS VM `192.168.33.12`:

**[This can be further automated in `.yml` file]**

```bash
scp -r app/ vagrant@192.168.33.10
scp playbook.yml vagrant@192.168.33.12
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
├── playbook.yml
└── roles
```

7. Run in root user
```bash
sudo su
```

8. To run the playbook, type `ansible-playbook yamlfile.yml`
```bash
ansible-playbook playbook.yml
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
```
---

## Setting up DB Enabling /posts 
1. Create another `.yaml` file called `playbook_db.yml`:
```bash
nano playbook_db.yml
```
2. 



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
