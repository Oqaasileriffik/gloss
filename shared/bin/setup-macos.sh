#!/bin/bash
if [[ `whoami` != 'root' ]]; then
	echo "This script must be run with sudo"
	exit
fi
if [[ `uname -a` != *'Darwin'* ]]; then
	echo "This script will only work on macOS"
	exit
fi

echo "Updating MacPorts"
port selfupdate
port upgrade outdated
echo ""
echo "Removing unused ports"
port uninstall --follow-dependencies leaves
echo ""
echo "Installing required ports"
port install subversion perl5 p5-dbi p5-dbd-sqlite p5-file-homedir p5-ipc-run

echo ""
echo "Installing Perl modules from CPAN"
/opt/local/bin/cpanm* --without-recommend --without-suggests Tie::Hash::DBD

echo ""
echo "Ensure you have 'export PERL_UNICODE=SDA' in your ~/.profile"
echo ""
echo "You can optionally put your SSH key into the macOS keychain with:"
echo "https://apple.stackexchange.com/a/250572"
