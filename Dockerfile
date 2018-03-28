FROM centos:centos7

ARG user=foo
ARG password=bar

RUN deps=' \
	openssh-server \
	passwd \
	' \ 
	&& yum -y update \
	&& yum -y install $deps \
	&& yum clean all \
	&& mkdir /var/run/sshd \
	&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
	&& sed -i 's/^PasswordAuthentication/#PasswordAuthentication/' /etc/ssh/sshd_config \
	&& useradd $user \
	&& printf "$password\n$password" | (passwd --stdin $user) \
	&& mkdir -p /home/$user/.ssh \
	&& touch /home/$user/.ssh/authorized_keys \
	&& chmod 700 /home/$user/.ssh \
	&& chmod 600 /home/$user/.ssh/authorized_keys \
	&& chown -R $user:$user /home/$user/.ssh

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
