# Not you will first need to upload your keys to the remote server
# https://unix.stackexchange.com/questions/36540/why-am-i-still-getting-a-password-prompt-with-ssh-with-public-key-authentication
# Make sure that on the server that the file permissions for the server .ssh directory are correct:
# chmod -R 700 ~/.ssh
#
# You need to create a file called ~/.sftpargento containing:
# export SSH_HOSTNAME=<name of sftp host>
# export SSH_USERNAME=<name of sftp user>
#
# Not related but interesting: https://stackoverflow.com/questions/24742223/makefile-dependent-targets-based-on-current-target


include ~/.sftpargento

default:
	echo "please choose an option"

upload-ssh-key:
	cat ~/.ssh/id_rsa.pub | ssh ${SSH_USERNAME}@${SSH_HOSTNAME} -p ${SSH_PORT} 'cat >> ~/.ssh/authorized_keys'

package:
	mkdir -p build
	cd site && tar cfvz ../build/planet-ix-site.tgz .
	cd ..

ssh:
	ssh ${SSH_USERNAME}@${SSH_HOSTNAME} -p ${SSH_PORT}

ssh-debug:
	ssh -v ${SSH_USERNAME}@${SSH_HOSTNAME} -p ${SSH_PORT}


publish: package
	$(info Going to sftp the files up to the server: username [${SSH_USERNAME}], hostname [${SSH_HOSTNAME}], port [-p ${SSH_PORT}])
	ssh ${SSH_USERNAME}@${SSH_HOSTNAME} -p ${SSH_PORT} 'mkdir -p ~/deploy/planet-ix'
	scp -P ${SSH_PORT} build/planet-ix-site.tgz ${SSH_USERNAME}@${SSH_HOSTNAME}:~/deploy/planet-ix/planet-ix-site.tgz 
	scp -P ${SSH_PORT} ops/upgrade-site.sh ${SSH_USERNAME}@${SSH_HOSTNAME}:~/deploy/planet-ix/upgrade-site.sh 

