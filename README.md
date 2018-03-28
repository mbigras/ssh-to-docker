# SSH to Docker

> Example of SSHing into a Docker container

## Example

```
user=foo
ssh-keygen \
	-t rsa \
	-f id_rsa \
	-N ''
docker build \
	--build-arg user=$user \
	--tag somesshd \
	.
docker run \
	-d \
	-p 2222:22 \
	--name somesshd \
	somesshd
docker exec \
	-i \
	somesshd \
	sh -c "cat >> /home/$user/.ssh/authorized_keys" \
	< id_rsa.pub
ssh-keyscan \
	-p 2222 \
	localhost \
	>> ~/.ssh/known_hosts
ssh \
	-i id_rsa \
	-o IdentitiesOnly=yes \
	-p 2222 \
	$user@localhost \
	echo 'hello world!'
```

## Clean

```
docker rm -f somesshd
docker rmi -f somesshd
rm id_rsa*
```

## Links

* https://github.com/CentOS/CentOS-Dockerfiles/blob/master/ssh/centos7/Dockerfile
* https://superuser.com/questions/187779/too-many-authentication-failures-for-username