#!/bin/sh

[ "$1" = "" ] && (echo "You need to define a URL to authorized keys." && exit 1)

# this will regenerate server keys
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# this will properly register the need authorized key
echo "Downloading authorized key from $1..."
curl --silent "$1" >> ~jenkins/.ssh/authorized_keys
chown jenkins:jenkins -R ~jenkins/.ssh
chmod 600 ~jenkins/.ssh/*

# this will start the SSH daemon in the foreground
exec /usr/sbin/sshd -D -p 22
