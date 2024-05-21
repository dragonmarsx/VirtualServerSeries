#!/bin/bash
apt update
apt install ffmpeg
apt install bc
apt-get install libssl-dev
wget 'https://sourceforge.net/projects/videlibri/files/Xidel/Xidel%200.9.8/xidel_0.9.8-1_amd64.deb'
dpkg -i xidel_0.9.8-1_amd64.deb
rm xidel_0.9.8-1_amd64.deb
wget -L -q https://raw.githubusercontent.com/dragonmarsx/VirtualServerSeries/main/richerize.sh
chmod +x preparize.sh
chmod +x richerize.sh
