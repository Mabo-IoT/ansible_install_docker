### 1、 构建ansible镜像

​       （默认有网环境并已安装docker）

​          a.  编辑Dockerfile

```yaml
    FROM alpine:3.9

    MAINTAINER William Yeh <william.pjyeh@gmail.com>


    RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
        apk --update add sudo                                         && \
        \
        \
        echo "===> Adding Python runtime..."  && \
        apk --update add python py-pip openssl ca-certificates    && \
        apk --update add --virtual build-dependencies \
                    python-dev libffi-dev openssl-dev build-base  && \
        pip install --upgrade pip pycrypto cffi                   && \
        \
        \
        echo "===> Installing Ansible..."  && \
        pip install ansible==1.9.4         && \
        \
        \
        echo "===> Installing handy tools (not absolutely required)..."  && \
        apk --update add sshpass openssh-client rsync  && \
        \
        \
        echo "===> Removing package list..."  && \
        apk del build-dependencies            && \
        rm -rf /var/cache/apk/*               && \
        \
        \
        echo "===> Adding hosts for convenience..."  && \
        mkdir -p /etc/ansible                        && \
        echo 'localhost' > /etc/ansible/hosts


    # default command: display Ansible version
    CMD [ "ansible-playbook", "--version" ]

```

​        b. 输入构建镜像命令：

```shell
	docker build -t mabo/ansible:v1.0 -f Dockerfile .
```

​        c. 通过镜像运行一个容器

```shell
   docker run -it -v /root/.ssh:/root/.ssh mabo/ansible:v1.0 sh
```

​        d. 保存镜像

```shell
   docker save -o ansible_docker_image_alpine39 mabo/ansible:v1.0
```

### 2、在服务器加载镜像

```shell
   docker load -i ansible_docker_image_alpine39
```

### 3、服务器端ssh免密钥登陆

​      a. 在/home/ladmin/下创建.ssh文件夹，之后输入命令：

```
   ssh-keygen
```

​      将在.ssh文件夹下生成公钥和私钥。

​      b. 将公钥id_rsa.pub传送至下层各个中间机。

​     eg：

```shell
   ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.140.131
```

### 4、用docker-compose运行ansible分发docker并安装

​      a . 编写docker-compose.yaml文件

```yaml
   version: '3.6'
   services:
     ansible:
       images: "mabo/ansible:v1.0"
       volumes:
          - /home/ladmin/.ssh:/root/.ssh
          - /usr/mabo/install/ansible_install_docker/ansible:/etc/ansible
          - /usr/mabo/install/ansible_install_docker/docker_install:/usr/mabo/
       command: ansible-playbook /usr/mabo/docker_install/install_docker.yml      
```

​      ansible文件夹里保存的为hosts文件，里面为各个中间机的ip

​      docker_install 文件夹保存的为docker相关rpm包    

​       b.  通过docker-compose运行ansible命令

```shell
    sudo docker-compose up
    docker-compose -f docker-compose_file.yaml restart
    docker ps -a 
```

