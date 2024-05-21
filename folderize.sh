#!/bin/bash
mkdir LIBRARY
if [ -d "LIBRARY" ];
then
  mkdir LIBRARY/AppData
  mkdir LIBRARY/Documents
  mkdir LIBRARY/Downloads
  mkdir LIBRARY/Gallery
  mkdir LIBRARY/Media
  mkdir LIBRARY/Media/FamilyVideo
  mkdir LIBRARY/Media/Movie
  chmod -R 777 LIBRARY
  ls -l LIBRARY
else
  echo -e "A problem exists creating "LIBRARY" folder.\n"; exit 0
fi
echo  "Folder structure created!"