#!/bin/bash
if [[ `whoami` != 'root' ]]; then
	echo "This script must be run with sudo or as root"
	exit
fi
if [[ `uname -a` != *'Ubuntu'* ]]; then
	echo "This script only works on Ubuntu"
	exit
fi

apt-get update
apt-get install libdbi-perl libdbd-sqlite3-perl libfile-homedir-perl libipc-run-perl cpanminus

echo "Installing Perl module Tie::Hash::DBD from CPAN"
cpanm --without-recommend --without-suggests Tie::Hash::DBD

echo ""
echo "Ensure you have 'export PERL_UNICODE=SDA' in your ~/.profile"
