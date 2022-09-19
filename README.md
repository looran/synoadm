## synoadm - customize Synology DSM devices

tested on DSM 7.0

2022, Laurent Ghigonis <ooookiwi@gmail.com>

### Usage

```bash
$ synoadm
usage: ./synoadm <synology_ip> <action>
actions
   push_ssl_cert <domain.fullchain.pem> <domain.key>
   set_htaccess <htpasswd_file> <message>
environment variables
   SSH=ssh
```

**WARNING: when upgrading your Synology device using set_htaccess, you have to disable the htaccess and re-enable it afterwards.**
Disabling htaccess can be done before or after reboot with the following command:
``
`mv /etc/nginx/conf.d/alias.htaccess.conf /root
/usr/syno/bin/synosystemctl reload nginx
```
After you first log-in and check everything is running fine, re-enable htaccess:
```
mv /root/alias.htaccess.conf /etc/nginx/conf.d/
/usr/syno/bin/synosystemctl reload nginx
```

### Example usage for push_ssl_cert

```bash
laptop $ synoadm 192.168.1.5 push_ssl_cert /tmp/domain.fullchain.pem /tmp/domain.key 

$ openssl x509 -in /tmp/domain.fullchain.pem -text
$ openssl rsa -in /tmp/domain.key -text
writing RSA key
$ ssh root@192.168.1.5 uname -ap
$ ssh root@192.168.1.5 cat > /usr/syno/etc/certificate/_archive/yoUheE/fullchain.pem
$ ssh root@192.168.1.5 cat > /usr/syno/etc/certificate/_archive/yoUheE/privkey.pem
$ ssh root@192.168.1.5 chmod 600 /usr/syno/etc/certificate/_archive/yoUheE/privkey.pem
$ ssh root@192.168.1.5 /usr/syno/bin/synosystemctl restart nginx
[nginx] restarted.
[*] done, 192.168.1.5 now uses new SSL certificates
```

### Prerequisite: have root access to your Synology device

1. Get ssh access to your device
see https://kb.synology.com/en-id/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet

2. Allow 'root' user to log-in
put your public key in /root/.ssh/authorized_keys

### Installation

```bash
$ sudo make install
```

### Related projects

Synology NAS file management from command-line
* https://github.com/looran/synocli
