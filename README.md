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

### Installation

```bash
$ sudo make install
```
