How to use openconnect with Cisco Secure Desktop.

## Usage
```bash
sudo openconnect -v --csd-wrapper=csd-responder-exec.sh --user <user> <https://vpn.mycompany.com>
```
Alternatively, on OSX you can store your pwd in your keychain and run it like this (place it in a new, 3rd file):
```bash
#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Get password from OS X Keychain function
get_pwd () {
  security find-generic-password -wa "<name-in-keychain>"
}

echo "**** If you change the password, don't forget to update your password manager and the OS X keychain ****"
echo "**** Retrieving password from keychain ****"
P=$(get_pwd)

# Need to call sudo first because it uses stdin to get the password; it should
# be remembered for the next invocation
sudo echo "Got sudo password..."
cat <(echo "$P") /dev/stdin | sudo openconnect -v \
  --csd-wrapper=$DIR/csd-vpn/csd-responder-exec.sh \
  --authgroup=Employee_Access \
  --user <user> \
  --passwd-on-stdin \
  --servercert sha256:<my-server-cert> \
  <https://vpn.mycompany.com>
```

Most of this was copied from here: https://github.com/sourcesimian/vpn-porthole/blob/master/PROFILES.md#cisco-hostscan \
which was inspired by this: https://gist.github.com/l0ki000/56845c00fd2a0e76d688#gistcomment-2015122

## Resources
openconnect manual: http://www.infradead.org/openconnect/manual.html \
Info about using a wrapper script to bypass CSD: http://www.infradead.org/openconnect/csd.html \
Cisco Secure Desktop seems to be end-of-life'd: https://www.cisco.com/c/en/us/obsolete/security/cisco-secure-desktop.html \
Shimo appears to use openconnect: https://gist.github.com/l0ki000/56845c00fd2a0e76d688#gistcomment-1666416
