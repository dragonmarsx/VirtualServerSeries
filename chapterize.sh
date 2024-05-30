#!/bin/bash

function_doProcessChapterFile() {
  while IFS= read -r line; do
     if [[ "$line" =~ ^([0-9]):([0-5][0-9]):([0-5][0-9])[[:space:]](.*)? ]]; then
        local title="${BASH_REMATCH[4]}"
        local timestamp=$(( $((${BASH_REMATCH[3]} + $((${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]})) * 60)) * 1000))
        local chapter_lines+=("${BASH_REMATCH[1]}:${BASH_REMATCH[2]}:${BASH_REMATCH[3]} $title")
        local pro_timestamp+=($timestamp)
        local pro_title+=("$title")
    else
      echo "problems with: $line"
    fi
  done < "CancunFamilyTrip.chapters.txt"

  if [[ $(ffprobe -v error -show_entries format=duration -of csv=p=0 -sexagesimal "CancunFamilyTrip.mp4") =~ ^([0-9]):([0-5][0-9]):([0-5][0-9])(.*)? ]]; then
    local pro_timestamp+=($(( $((${BASH_REMATCH[3]} + $((${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]})) * 60)) * 1000)))
  fi

  text=";FFMETADATA1\n# Chapters for: 'Movie Title'\n\n"
  for ((i=0; i<${#pro_timestamp[@]} - 1; ++i)); do
      text+="# ${chapter_lines[$i]}\n[CHAPTER]\nTIMEBASE=1/1000\nSTART=${pro_timestamp[$i]}\nEND=$(bc <<<"${pro_timestamp[$i + 1]} - 1")\ntitle=${pro_title[$i]}\n\n"    
  done
}

text=()
function_doProcessChapterFile
echo -e "$text" 
echo
echo

#printf "$text" > "ffmpeg.chapters.txt"
#EXAMPLE INPUT FILE (A TEXT FILE WITH THIS FORMAT)

#0:00:00 Intro
#0:00:03 The Room
#0:00:05 The Beach
#0:00:32 The Garden
#0:00:44 The Bar
#0:00:50 The View
#eof (then optional name of video file)

#OTHER EXAMPLE:

#0:00:14 Intro
#0:23:20 Start
#0:40:30 First Performance
#0:40:56 Break
#1:04:44 Second Performance
#1:24:45 Crowd Shots
#1:27:45 Credits
#eof (then optional name of video file)
