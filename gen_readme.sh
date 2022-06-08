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

### Installation

\`\`\`bash
$ sudo make install
\`\`\`
_EOF

echo "[*] DONE, generated $README"
