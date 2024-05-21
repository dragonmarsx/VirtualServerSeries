#!/bin/bash
MY_DATAFOLDER="LIBRARY"

if [[ $(whoami) -ne "root" ]]; then
  echo -e "Please execute with root privileges!\n"; exit 0
fi


if [ -d "$MY_DATAFOLDER" ];
then
  echo -e "$MY_DATAFOLDER folder already exists!\n"; exit 0
fi

mkdir $MY_DATAFOLDER
if [ -d "$MY_DATAFOLDER" ];
then
  mkdir $MY_DATAFOLDER/AppData
  mkdir $MY_DATAFOLDER/Documents
  mkdir $MY_DATAFOLDER/Downloads
  mkdir $MY_DATAFOLDER/Gallery
  mkdir $MY_DATAFOLDER/Media
  mkdir $MY_DATAFOLDER/Media/FamilyVideo
  mkdir $MY_DATAFOLDER/Media/Movie
  chmod -R 777 $MY_DATAFOLDER
  ls -l $MY_DATAFOLDER
else
  echo -e "A problem exists creating "$MY_DATAFOLDER" folder.\n"; exit 0
fi
echo  "DONE!"
