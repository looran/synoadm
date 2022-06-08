#!/bin/sh

# synoadm - customize Synology DSM devices
# tested on DSM 7.0
# 2022, Laurent Ghigonis <ooookiwi@gmail.com>

usageexit() {
	cat <<-_EOF
usage: $0 <synology_ip> <action>
actions
   push_ssl_cert <domain.fullchain.pem> <domain.key>
   set_htaccess <htpasswd_file> <message>
environment variables
   SSH=$SSH
_EOF
	exit 1
}
trace() { echo "$ $*" >&2; "$@"; }
err() { echo -e "error: $@"; exit 1; }

check_ssh_connectivity() {
	trace ssh root@$ip uname -ap \
		|| err "you must have SSH connectivity to $ip as root\nsee https://kb.synology.com/en-uk/DSM/tutorial/How_to_log_in_to_DSM_with_key_pairs_as_admin_or_root_permission_via_SSH_on_computers"
}

set -e

SSH=${SSH:-"ssh"}

[ $# -lt 2 ] && usageexit

ip=$1
action=$2
shift 2
case $action in
push_ssl_cert)
	[ $# -ne 2 ] && usageexit
	fullchain=$1
	key=$2
	trace openssl x509 -in $fullchain -text >/dev/null || err "invalid x509 certificate: $fullchain"
	trace openssl rsa -in $key -text >/dev/null || err "invalid key: $key"
	check_ssh_connectivity
	certname=$($SSH root@$ip "cat /usr/syno/etc/certificate/_archive/DEFAULT")
	cat $fullchain |trace $SSH root@$ip "cat > /usr/syno/etc/certificate/_archive/$certname/fullchain.pem"
	cat $key |trace $SSH root@$ip "cat > /usr/syno/etc/certificate/_archive/$certname/privkey.pem"
	trace $SSH root@$ip "chmod 600 /usr/syno/etc/certificate/_archive/$certname/privkey.pem"
	trace $SSH root@$ip "/usr/syno/bin/synosystemctl restart nginx"
	echo "[*] done, $ip now uses new SSL certificates"
	;;
set_htaccess)
	[ $# -ne 2 ] && usageexit
	htaccess=$1
	message=$2
	[ ! -e $htaccess ] && err "cert or key does not exist locally"
	check_ssh_connectivity
	cat $htaccess |trace $SSH root@$ip "cat > /etc/nginx/htpasswd"
	cat <<-_EOF |trace $SSH root@$ip "cat > /etc/nginx/conf.d/alias.htaccess.conf"
auth_basic "$message";
auth_basic_user_file /etc/nginx/htpasswd;
_EOF
	trace $SSH root@$ip "/usr/syno/bin/synosystemctl reload nginx"
	echo "[*] done, $ip now has htaccess in place on all web services"
	;;
*)
	usageexit
	;;
esac

