#!/bin/bash

function_doProcessChapterFile() {
  rexpr_txtfile="^([0-9]):([0-5][0-9]):([0-5][0-9].[0-9][0-9])[[:space:]](.*)?" #h:mm:ss.ff Anytext
  rexpr_ffprobe="^([0-9]):([0-5][0-9]):([0-5][0-9])(.*)?" #h:mm:ss.ff
  while IFS= read -r line; do
     if [[ "$line" =~ $rexpr_txtfile ]]; then
        hrs=${BASH_REMATCH[1]}
        mins=${BASH_REMATCH[2]}
        secs=${BASH_REMATCH[3]}
        title=${BASH_REMATCH[4]}

        minutes=$(( $mins + $(($hrs * 60)) ))
		    seconds=$(echo "scale=2; $secs + $(($minutes * 60))" | bc )
		    timestamp=$(echo "scale=2; $seconds * 1000" | bc )     #then divide by 1 to get whole number
        #echo "timestamp calculation1=$timestamp"     
     
        local title="${BASH_REMATCH[4]}"
        local timestamp=$(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc )
        local chapter_lines+=("${BASH_REMATCH[1]}:${BASH_REMATCH[2]}:${BASH_REMATCH[3]} $title")
        local pro_timestamp+=($timestamp)
        local pro_title+=("$title")     
    else
        echo "ERROR CHAPTER: $line"
    fi
  done < "CancunFamilyTrip.chapters.txt"

  if [[ $(ffprobe -v error -show_entries format=duration -of csv=p=0 -sexagesimal "CancunFamilyTrip.mp4") =~ $rexpr_ffprobe ]]; then
    local pro_timestamp+=( $(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc )  )
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

#0:00:00.00 Intro
#0:00:02.99 The Room
#0:00:05.11 The Beach
#0:00:31.99 The Garden
#0:00:44.11 The Bar
#0:00:50.01 The View
#end (then optional name of video file)

#ANOOTHER EXAMPLE:

#0:00:14.00 Intro
#0:23:20.01 Start
#0:40:30.02 First Performance
#0:40:56.03 Break
#1:04:44.04 Second Performance
#1:24:45.05 Crowd Shots
#1:27:45.06 Credits
#eof (then optional name of video file)
