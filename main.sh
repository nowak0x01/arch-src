#!/bin/bash

# /*
# up graphical interface with xfce4-terminal
# run the script with root privileges
# curl -Lsk https://raw.githubusercontent.com/nowak0x01/arch-src/main/main.sh -o ./main.sh && chmod 755 ./main.sh && ./main.sh
## case running on native box, remove "open-vm-tools gtkmm3" from pacman ##
# */

if [ ! $(head -1 /etc/shadow 2>&-) ];then
	printf "\n:: $0 - run as root! ::\n\n"
	exit 1
fi

pacman -S php lynx code impacket python-shodan xclip whois openssh openvpn dnsutils inetutils go python python2 python-pip mariadb-clients openbsd-netcat traceroute tcpdump wireshark-qt wget gtk3 libxt mime-types dbus-glib ffmpeg libpulse jre11-openjdk feh unzip zip openldap smbclient mousepad git jython proxychains libreoffice freerdp tor torsocks metasploit nfs-utils docker net-snmp nfs-utils wpscan websvn subversion jq tk open-vm-tools gtkmm3 ttf-monofur perl-image-exiftool exploitdb tdb --noconfirm

# downloading firefox-quantum
wget 'https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US' -O ./gz
tar -xf ./gz
rm -f ./gz
mv firefox /opt
ln -sf /opt/firefox/firefox-bin /usr/local/bin/firefox

# compiling nmap
cd /opt
git clone https://github.com/nmap/nmap
cd /opt/nmap/
rm -rf .git*
chmod -R 777 ./*
./configure
make && make install

# compiling thc-hydra
cd /opt
git clone https://github.com/vanhauser-thc/thc-hydra
cd /opt/thc-hydra
rm -rf .git*
chmod -R 777 ./*
./configure
make && make install

# downloading feroxbuster static binary
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
mv feroxbuster /usr/local/bin/

# compiling john the ripper
cd /opt
git clone https://github.com/openwall/john
cd john
rm -rf .git*
cd ./src
./configure
make -s clean && make -sj`nproc`
make install # john installed on /opt/john/run/john

# downloading svn-extractor
cd /opt
git clone https://github.com/anantshri/svn-extractor
cd svn-extractor
rm -rf .git*
ln -sf $PWD/svn_extractor.py /usr/local/bin/

# compiling ffuf
cd /opt
git clone https://github.com/ffuf/ffuf
rm -rf .git*
cd ffuf
go get && go build
ln -sf $PWD/ffuf /usr/local/bin/

# compiling httpx
cd /opt
git clone https://github.com/projectdiscovery/httpx
cd httpx
rm -rf .git*
make
ln -sf $PWD/httpx /usr/local/bin/

# compiling subfinder
cd /opt
git clone https://github.com/projectdiscovery/subfinder
cd subfinder
rm -rf .git*
cd ./v2/cmd/subfinder
go get && go build
ln -sf $PWD/subfinder /usr/local/bin/

# compiling masscan
cd /opt
git clone https://github.com/robertdavidgraham/masscan
cd masscan
rm -rf .git*
make
ln -sf $PWD/bin/masscan /usr/local/bin/

# compiling gau
cd /opt
git clone https://github.com/lc/gau
cd gau
rm -rf .git*
cd $PWD/cmd/gau
go get && go build
ln -sf $PWD/gau /usr/local/bin/

# compiling kerbrute
cd /opt
git clone https://github.com/ropnop/kerbrute
cd kerbrute
rm -rf .git*
go get && go build
ln -sf $PWD/kerbrute /usr/local/bin/

# downloading crackmapexec
python3 -m pip install pipx
pipx ensurepath
pipx install crackmapexec
pipx ensurepath

# downloading enum4linux
cd /opt
git clone https://github.com/CiscoCXSecurity/enum4linux
cd enum4linux
rm -rf .git*
git clone https://github.com/Wh1t3Fox/polenum
cd polenum
rm -rf .git*
ln -sf $PWD/polenum.py /usr/local/bin/polenum
mkdir -p /etc/samba
cat << EOF > /etc/samba/smb.conf

[global]
	workgroup = workgroup
	security = user
	idmap uid = 16777216-33554431
	idmap gid = 16777216-33554431
;	template shell = /bin/false
	winbind use default domain = false
	winbind offline logon = false

	server string = Samba Server %v

;	netbios name = MYSERVER

;	interfaces = lo eth0 192.168.12.2/24 192.168.13.2/24
;	hosts allow = 127. 192.168.12. 192.168.13.

;	log file = /var/log/samba/%m.log
;	max log size = 50

	passdb backend = tdbsam

;	local master = no
;	os level = 33
;	preferred master = yes

;	wins support = yes
;	wins server = w.x.y.z
;	wins proxy = yes

;	dns proxy = yes

;	load printers = yes
	cups options = raw

;	printcap name = /etc/printcap
;	printcap name = lpstat
;	printing = cups

;	map archive = no
;	map hidden = no
;	map read only = no
;	map system = no
	username map = /etc/samba/smbusers
	encrypt passwords = yes
	guest ok = yes
;	guest account = nobody
;	store dos attributes = yes

[homes]
	comment = Home Directories
	browseable = no
	writable = yes
	valid users = %S
;	valid users = MYDOMAIN\%S

[printers]
	comment = All Printers
	path = /var/spool/samba
	browseable = no
;	guest ok = no
;	writable = No
	printable = yes

;	[Profiles]
;	path = /var/lib/samba/profiles
;	browseable = no
;	guest ok = yes

;	[public]
;	comment = Public Stuff
;	path = /home/samba
;	public = yes
;	writable = yes
;	printable = no
;	write list = +staff

[downloads]
	path = /root/downloads
	writeable = yes
	browseable = yes
	valid users = root
	public = no

EOF
ln -sf /opt/enum4linux/enum4linux.pl /usr/local/bin/
chmod -R 777 /etc/samba/

# downloading GitTools [git-dumper/git-extractor]
cd /opt
git clone https://github.com/internetwache/GitTools
cd GitTools
rm -rf .git*
ln -sf $PWD/Dumper/gitdumper.sh /usr/local/bin/git-dumper.sh
ln -sf $PWD/Extractor/extractor.sh /usr/local/bin/git-extractor.sh

# downloading python-pip2
cd /opt
curl -Lsk https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python2 ./get-pip.py && rm -f get-pip.py

# downloading sqlmap
cd /opt
git clone https://github.com/sqlmapproject/sqlmap
cd sqlmap
rm -rf .git*
ln -sf $PWD/sqlmap.py /usr/local/bin/

# compiling nuclei
cd /opt
git clone https://github.com/projectdiscovery/nuclei
cd nuclei
rm -rf .git*
cd v2/
make
ln -sf $PWD/nuclei /usr/local/bin/
nuclei

# compiling goop
cd /opt
git clone https://github.com/deletescape/goop
cd goop
rm -rf .git*
go get && go build
ln -sf $PWD/goop /usr/local/bin/

# downloading obsidian-0.14.15
cd /opt
curl -Lsk https://github.com/obsidianmd/obsidian-releases/releases/download/v0.14.15/Obsidian-0.14.15.AppImage -o image
chmod 755 image && ./image --appimage-extract
rm -f image
mv ./squashfs-root ./Obsidian-0.14.15
ln -sf /opt/Obsidian-0.14.15/AppRun /usr/local/bin/obsidian

# downloading Flameshot
cd /opt
curl -Lsk https://github.com/flameshot-org/flameshot/releases/download/v11.0.0/Flameshot-11.0.0.x86_64.AppImage -o image
chmod +x image && ./image --appimage-extract
mv ./squashfs-root ./Flameshot-11.0.0.x86_64
ln -sf /opt/Flameshot-11.0.0.x86_64/AppRun /usr/local/bin/flameshot

# downloading weevely
cd /opt
git clone https://github.com/epinna/weevely3
cd weevely3
rm -rf .git*
pip3 install -r requirements.txt -I
ln -sf $PWD/weevely.py /usr/local/bin/

# downloading tplmap
cd /opt
git clone https://github.com/epinna/tplmap
cd tplmap
rm -rf .git*
pip2 install -r requirements.txt
ln -sf $PWD/tplmap.py /usr/local/bin/

# downloading evil-winrm
cd /opt
git clone https://github.com/Hackplayers/evil-winrm
cd evil-winrm
rm -rf .git*
gem install winrm winrm-fs stringio logger fileutils
ln -sf $PWD/evil-winrm.rb /usr/local/bin/
