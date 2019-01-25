# set environment key
export DOCKER_PRIVATE_REGISTRY="10.7.0.116:10051/"
# install docker require dev
yum -y localinstall docker_package/*.rpm
# install docker
yum -y localinstall docker/*.rpm

systemctl daemon-reload
systemctl restart docker

cp daemon.json /etc/docker/daemon.json

# install docker-compose
cp docker-compose/docker-compose /usr/local/bin

chmod +x /usr/local/bin/docker-compose

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

# docker load image
docker load -i docker-images/redis-image
docker load -i docker-images/mabo_python_0.1.5 
