## 1、安装

####     a. 安装依赖包

​	python-yaml-3.09-2.el6.rf.x86_64.rpm、python-crypto-2.0.1-22.el6.x86_64.rpm、
​	python-babel-0.9.4-5.1.el6.noarch.rpm、python-setuptools-0.6.10-4.el6_9.noarch.rpm、
​	python-jinja2-2.2.1-3.el6.x86_64.rpm、python-paramiko-1.7.5-4.el6_9.noarch.rpm 、
​	python-six-1.9.0-2.el6.noarch.rpm 、sshpass-1.06-1.el6.x86_64.rpm

####    b. 安装ansible

	ansible-2.7.6-1.el6.ans.noarch.rpm

####    c. 查看ansible版本

	ansible --version

​	

## 2、使用

####     a. 在/etc/ansible/hosts里填写ip信息

####     b. 测试命令

​	   ansible all -m ping

####     c. 产生公钥私钥

​	   在服务器端输入ssh-keygen，会在~/.ssh/下产生两个文件：id_rsa 及id_rsa.pub
​	   将公钥id_rsa.pub发送到各个中间机
​	   ssh-copy-id -i ~/.ssh/id_rsa.pub liqian@192.168.140.132

####     d. 在各个中间机系统中修改sshd_config文件

​	   https://blog.csdn.net/u013908944/article/details/78815394   
​       在sshd_config文件中加入

	   KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1

​       然后输入 service ssh restart 即可

####    e.使用ansible安装部署docker

#####      1、传输拉取文件及文件夹

​      编写yml文件：

---

	- name: say 'hello world'
	  hosts: hhh1
	  tasks:
		- name: copy file from servre to edge
		  synchronize: mode=push src=/root/Desktop/{{ item }} dest=/root/Desktop/
		  with_items:
			- "docker_install"
		- name: "install docker"
		  shell: sh /root/Desktop/docker_install/install_dev.sh
​       其中，push表示从服务器到各个中间机，pull表示从各个中间机到服务器

​       第二个任务是运行shell脚本一键安装docker

#####       2、编写hosts

```
[hhh1]
	192.168.140.133
```

#####       3、运行命令

```
ansible-playbook xxx.yml 
```


​	