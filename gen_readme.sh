#!/bin/sh

D="$(dirname $0)"
README="$(dirname $0)/README.md"

cat > $README <<-_EOF
## $(egrep "^# " $D/synoadm.sh |sed 's/# /\n/g' |tail -n +2)

### Usage

\`\`\`bash
$ synoadm
$($D/synoadm.sh |sed s/synoadm.sh/synoadm/)
\`\`\`

### Example usage for push_ssl_cert

\`\`\`bash
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
\`\`\`

### Installation

\`\`\`bash
$ sudo make install
\`\`\`
_EOF

echo "[*] DONE, generated $README"
