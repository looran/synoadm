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

### Installation

```bash
$ sudo make install
```
