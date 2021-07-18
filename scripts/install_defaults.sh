echo "Installing Docker..."
sudo apt-get update
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker ubuntu
sudo docker --version

# Packages required for nomad & consul
sudo apt-get install unzip curl vim -y

echo "Installing Nomad..."
NOMAD_VERSION=1.0.1
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d
sudo mkdir -p /opt/nomad/data
sudo systemctl stop nomad.service
# Configuring nomad master
if [ $(hostname) = "nomad-server01" ]
then
(
cat <<-EOF
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "vbox"
region = "local"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = false
}
EOF
) | sudo tee /etc/nomad.d/nomad.hcl
sudo systemctl start nomad.service
sudo systemctl enable nomad.service
elif [ $(hostname) = "nomad-client01" ]
then
(
cat <<-EOF
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"
datacenter = "vbox"
region = "local"

server {
  enabled = false
}

client {
  enabled = true
  servers = ["192.168.56.101"]
  options = {
    "driver.allowlist" = "docker,exec"
  }
}
EOF
) | sudo tee /etc/nomad.d/nomad.hcl
sudo systemctl start nomad.service
sudo systemctl enable nomad.service
else
sudo systemctl disable nomad.service
fi


#echo "Installing Consul..."
#CONSUL_VERSION=1.9.0
#curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
#unzip /tmp/consul.zip
#sudo install consul /usr/bin/consul
#(
#cat <<-EOF
#  [Unit]
#  Description=consul agent
#  Requires=network-online.target
#  After=network-online.target
#
#  [Service]
#  Restart=on-failure
#  ExecStart=/usr/bin/consul agent -dev
#  ExecReload=/bin/kill -HUP $MAINPID
#
#  [Install]
#  WantedBy=multi-user.target
#EOF
#) | sudo tee /etc/systemd/system/consul.service
#sudo systemctl enable consul.service
#sudo systemctl start consul

nomad -autocomplete-install
