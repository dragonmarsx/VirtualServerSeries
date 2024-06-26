#!/bin/bash
MAX_POSTERS=2
MAX_BACKDROPS=2
MPAAS=('TV-Y' 'APPROVED' 'TV-G' 'PG-13' 'PG-13' 'R' 'TV-MA')
ACTORS=('Sara Hayek' 'Liza Taylor' 'Gina Close' 'Jimmy Chan' 'Lucho DiCaprio' 'Ant Banderas' 'Penelope Reyes')
ROLES=('the guest star' 'the home princess' 'the queen been' 'the goofy' 'the bully' 'the car driver' 'the expert biker' 'the football coach' 'the neighbor' 'ice cream seller' 'the action hero' 'the aristocratic actor' 'the cat lady' 'the choosen one' 'the con arist' 'the damsel in distress' 'the latin lover' 'the bandido' 'the femme fatale' 'the figaro' 'the last standing' 'the folk hero' 'the jocker' 'the supernatural entity' 'the gypsy' 'the harlequin' 'the igor' 'the innocent' 'the knight-errant' 'the machiavelle' 'the eccentric' 'the dreamy' 'the attactive' 'the friendly villain' 'the diva' 'the legend' 'the noble prince' 'the mischievous' 'the preppy' 'the seductor' 'the schoolma`am' 'the impostor' 'the sidekick' 'the southern belle' 'the wise' 'the yuppie')
DIRECTORS=('Dhina Marca' 'Elmher Curio' 'Steban Dido' 'Elba Lazo' 'Elma Montt' 'Mario Neta' 'Yola Prieto')
GENRES=('Thriller' 'Action' 'Reality' 'Adventure' 'Fiction' 'Suspense' 'Comedy drama' 'Family drama' 'Romance' 'Drama' 'Comedy' 'Mystery' 'Soap opera' 'Documentary' 'Sports' )
STUDIOS=('Metro Golden Meyer' '20th Century Fox' 'Marvel Universe' 'Hanna-Barbera Studios' 'DreamWorks Animation' 'Paramount Pictures' 'Universal Pictures' 'Columbia Pictures' 'Warner Bros. Studios' 'Sony Picture Studios')
SEARCH_TAGS=('Birthday' 'Beach' 'Dancing' 'Streets' 'park' 'city' 'lake' 'snow' 'river')
TRAILER_IDS=('v-PjgYDrg70' 'iurbZwxKFUE' 'hu9bERy7XGY' 'G2gO5Br6r_4' 'un7a-i6pTS4' '-xjqxtt18Ys' 'LAr8SrBkDTI' 'vZnBR4SDIEs' 'mfw2JSDXUjE' 'CxwTLktovTU' 'eHcZlPpNt0Q' 'CwXOrWvPBPk' '-UaGUdNJdRQ' 'eTjHiQKJUDY' 'CZ1CATNbXg0' '1XHf94YqGyQ' 'xBgSfhp5Fxo' 'GUvk7NNmB64' 'HKH7_n425Ss' 'JFsGn_JwzCc' 'sJCjKQQOqT0' '9oQ628Seb9w' 'glPzcdMX5wI' 'CGbgaHoapFM' 'DFTIL0ciHik' 'xNWSGRD5CzU' 'mE35XQFxbeo' '5iB82S8rHyg' '_MoIr7811Bs' '_MoIr7811Bs' 'siLm9q4WIjI' '9OAC55UWAQs' 'G2z-xAZRFcQ' 'WYTE2_W2O00' 'ie53R2HEZ6g' 'orAqhC-Hp_o' 'Wlo-sYrADlw' 'TQhRqtt-Fpo' 'Su7g8JVY0xI' '1sD4qkCymtI' 'kkrGBlvGK4I' 'HLw7pSXJe64' 'HlNRVZ871os' 'GV5y4yTDtBI' 'RFeNB8IlPlc' 'eRNPQmk6wLU' '4ffrsBbrrQU' 'O6i3lyx1I_g' 'Njf8U5SnM4w' 'M0vnBeHeuzs' 'i4noiCRJRoE' 'pfESEXIZ_lw' 'JX6btxoFhI8' 'eTjDsENDZ6s' '-agq5R3b43U' 'Vngk9Wp9bGk' 'vZIY2-kH-wE' '8IBNZ6O2kMk' 'ZS_8btMjx2U' 'SPHfeNgogVs' 'qCKdkbsMUA8' 'sED6FRXIHJc' 'lFzVJEksoDY' '-qCPMP4mNcQ' 'usEkWtuNn-w' 'SyYESEvDNIg' 'hAGzq5jLCEk' '2BkVf2voCr0')

#Do not modify below this line
SUPPORTED_EXT=("mkv" "mp4" "avi")
VALID_ARGUMENTS=( -noposter -noback -nologo -nometa -nomusic -notrailer -dorgb -docopy)
YELLOW='\033[1;33m'
RED='\033[0;33m'
NC='\033[0m' 
COUNTER=0;TOTAL_COUNTER=0

#Start argument vailidation
if [[ $(whoami) -ne "root" ]]; then echo -e "Execute script with root account privileges: ${YELLOW}su - ${NC}"; exit 0; fi
if [[ -z ${@:1} ]] || [[ ${@:1} == -* ]]; then
  echo -e "${RED}Missing argument. No directory name in the command line.${NC}"
  echo -e "Example: ./richerize.sh ${YELLOW}MyDirectoryWithFiles${NC}"
  echo -e "Example: ./richerize.sh ${YELLOW}'My Other Directory With spaces in its name'${NC}\n"  
  exit 0
fi
for f in "$1"/*; do
    [ -d "$f" ] && continue; 
    if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi     
    old_f=$f; new_f=${f%.*}/$(basename -- "$f")
    let COUNTER++
done
if [ $COUNTER -eq 0 ]; then echo -e "${RED}Error:${NC} Missing directory or directory has no content ${YELLOW}$1${NC}.\n"; exit 0; fi
typed_arguments=${@:2}
for i in ${typed_arguments[@]}; do
  if [[ " ${VALID_ARGUMENTS[*]} " =~ [[:space:]]${i,,}[[:space:]] ]]; then recognized_args+=("${i,,} "); fi
done
#Ends argument vailidation

#Start initial screen
TOTAL_COUNTER=$COUNTER
echo -e "====================================================================================="
echo -e "A total of "${RED}$TOTAL_COUNTER${NC}" file(s) will be moved inside ${YELLOW}$1."
echo -e "${NC}Each media file(s) will be moved inside its new folder.  Example:"
echo -e "${YELLOW}BEFORE${NC}: "$old_f
echo -e "${YELLOW} AFTER${NC}: "$new_f
echo -e "_____________________________________________________________________________________"
echo -e "Valid arguments: "${VALID_ARGUMENTS[@]}
if [ ${#recognized_args[@]} -gt 0 ]; then echo -e "    Recognized : ${YELLOW}"${recognized_args[@]}${NC}; fi
echo -e "_____________________________________________________________________________________"
echo -e "${YELLOW}Press Enter key to continue OR Ctrl/Option +C to abort.${NC}"
read
#End initial screen

#Start funtionality
COUNTER=1
for f in "$1"/*; do
    [ -d "$f" ] && continue; 
    if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi

    new_f=${f%.*}/"$(basename -- "$f")"  #the new file absolute path
    ffmpeg_i=("$new_f")   	             #an array of file names understands white spaces.
    new_f_array=("$new_f"); x1=${new_f_array[@]}; x2=${x1%.*}
    base_name=${x2##*/}    
    echo -e -n "${RED}("$COUNTER"of"$TOTAL_COUNTER")${NC} Working on ${YELLOW}"$(basename -- "$f")${NC}"..."
    mkdir -p "${f%.*}" #new folder created!

    ffmpeg_f="$f"; chapter_info="${f%.*}.chapters.txt"; Video_with_Chapter_info="${ffmpeg_i[@]}" 
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
      done < "$chapter_info" 
      if [[ $(ffprobe -v error -show_entries format=duration -of csv=p=0 -sexagesimal "CancunFamilyTrip.mp4") =~ ^([0-9]):([0-5][0-9]):([0-5][0-9])(.*)? ]]; then
        local pro_timestamp+=($(( $((${BASH_REMATCH[3]} + $((${BASH_REMATCH[1]} * 60 + ${BASH_REMATCH[2]})) * 60)) * 1000)))
      fi
      text=";FFMETADATA1\n# ${base_name[@]} (ffmpeg format)\n\n"
      for ((i=0; i<${#pro_timestamp[@]} - 1; ++i)); do
          text+="# ${chapter_lines[$i]}\n[CHAPTER]\nTIMEBASE=1/1000\nSTART=${pro_timestamp[$i]}\nEND=$(bc <<<"${pro_timestamp[$i + 1]} - 1")\ntitle=${pro_title[$i]}\n\n"    
      done
      ffmpeg_chapter_file="${f%.*}"'/chapters.txt'
      printf "$text" > "$ffmpeg_chapter_file"  
      ffmpeg -i "$ffmpeg_f" -loglevel error -f ffmetadata -i "$ffmpeg_chapter_file" -c copy "$Video_with_Chapter_info"  
    }   
    
    if [[ "${typed_arguments,,}" == *"-docopy"* ]]; then 
      if [ -f "$chapter_info" ]; then  #chapter file exist, we need to work on it
        echo -e -n " Processing chapter..." 
        function_doProcessChapterFile
      	#ffmpeg -i "$ffmpeg_f" -loglevel error -f ffmetadata -i "$chapter_info" -c copy "$Video_with_Chapter_info"
        echo -e "${RED}COPIED WITH CHAPTER DATA!${NC}"
      else   
        cp -a "$f" "${f%.*}/"
        echo -e "${RED}COPIED!${NC}"
      fi
    else
      if [ -f "$chapter_info" ]; then
        echo -e -n " Processing chapter..." 
        function_doProcessChapterFile
       	#ffmpeg -i "$ffmpeg_f" -loglevel error -f ffmetadata -i "$chapter_info" -c copy "$Video_with_Chapter_info"  #ffmpeg do not move files.
        sleep 5;
 	    rm "$f"        
        echo -e "${RED}MOVED WITH CHAPTER DATA!${NC}"     
      else 
        mv "$f" "${f%.*}/" 
        echo -e "${RED}MOVED!${NC}"
      fi
    fi    

    aroundBegining=( $(shuf -e 1 2 3) ) #random digit for 1 tenth, 1 quart or 1 third of the total length
    ffmpeg_ssMidFrameORIGINAL=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "$new_f")*0.5")")
    ffmpeg_ssMidFrame=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "$new_f")*0.${aroundBegining[0]}")")
    
    if [[ ! "${typed_arguments,,}" == *"-noposter"* ]]; then
      echo -e -n "${RED}POSTERS     : ${NC}Creating main image poster..."
      mkdir -p "${f%.*}/_temp" 
      ffmpeg_vfPoster="crop=in_w/2:in_h,select='not(mod(n\,300))',setpts=N/TB"
      ffmpeg_vfScaled="crop=in_w/2:in_h,select='not(mod(n\,300))',setpts=N/TB,scale=-1:1080'"
      radius=30
      ffmpeg_rounded=",format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${radius})*gt(abs(H/2-Y),H/2-${radius}),if(lte(hypot(${radius}-(W/2-abs(W/2-X)),${radius}-(H/2-abs(H/2-Y))),${radius}),255,0),255)'"
      eval $(ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=height,width,nb_frames,duration,codec_name -sexagesimal "${ffmpeg_i[@]}" )        
      height=${streams_stream_0_height}
     
      ffmpeg -ss "${ffmpeg_ssMidFrame[@]}" -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfPoster$ffmpeg_rounded -frames:v 1 -q:v 5 -loglevel error "${f%.*}/poster.png" -y      
      echo -e -n "${RED}DONE!${NC}.  Creating more alternatives in _temp folder..."
      MIN_HEIGHT=500            
      if [[ $MIN_HEIGHT -gt $height ]]
      then   #Un Cu         
         ffmpeg -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfScaled$ffmpeg_rounded -r 1 -vframes $MAX_POSTERS -q:v 5 -loglevel error "${f%.*}/_temp/poster%01d.png" -y
      else  #Kim Fi
         ffmpeg -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfPoster$ffmpeg_rounded -r 1 -vframes $MAX_POSTERS -q:v 5 -loglevel error "${f%.*}/_temp/poster%01d.png" -y
      fi
      echo -e "${RED}DONE!${NC}"   
	fi
        
    if [[ ! "${typed_arguments,,}" == *"-noback"* ]]; then
      echo -e -n "${RED}BACKDROPS   :${NC} Creating main backdrop image..."
      ffmpeg -ss $(bc -l <<< 'scale=2;'${ffmpeg_ssMidFrame}/2) -i "${ffmpeg_i[@]}" -vf "hue=s=3,scale=2160:-1" -frames:v 1 -loglevel error "${f%.*}/backdrop.jpg" -y 
      echo -e -n "${RED}DONE!${NC}.  Creating additional backdrops..."   
      if [[ "${typed_arguments,,}" == *"-rgb"* ]]
      then
        eqR="eq=gamma_r=4:gamma_g=1:gamma_b=0,hue=s=10"; eqG="eq=gamma_r=0.2:gamma_g=1.1:gamma_b=0";
        eqB="eq=gamma_r=0:gamma_g=0.7:gamma_b=10";       eqC="eq=gamma_r=0.2:gamma_g=2:gamma_b=6";
        eqM="eq=gamma_r=9:gamma_g=1:gamma_b=3";          eqV="eq=gamma_r=3:gamma_g=1:gamma_b=9" ; 
        eqY="eq=gamma_r=4:gamma_g=4:gamma_b=0";          eqT="eq=gamma_r=0:gamma_g=1:gamma_b=2"  
        eqS="eq=gamma_r=7:gamma_g=2:gamma_b=0";          eqP="eq=gamma_r=6:gamma_g=2:gamma_b=2"
        eqG2="eq=gamma_r=0:gamma_g=1:gamma_b=0";         eqK="format=gray"
      else
        hue="hue=s=2" ;eqR=$hue;eqG=$hue;eqB=$hue;eqC=$hue;eqM=$hue;eqV=$hue;eqY=$hue;eqT=$hue;eqS=$hue;eqP=$hue;eqK=$hue;eqG2=$hue;
      fi
      ffmpeg_eqRandom=( $(shuf -e $eqR $eqG $eqB $eqC $eqM $eqV $eqY $eqT $eqS $eqP $eqG2 $eqK) ) 
      n=1;
      while [ $n -lt $MAX_BACKDROPS ]; do
          ffmpeg_ssAtFrame=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "${ffmpeg_i[@]}")*0.$n")") 
          ffmpeg -ss "${ffmpeg_ssAtFrame[@]}" -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 5 -loglevel error "${f%.*}/backdrop$n.jpg" -y
          let n++
      done
      echo -e "${RED}DONE!${NC}"
    fi
    
    if [[ ! "${typed_arguments,,}" == *"-nologo"* ]]; then
      echo -e -n "${RED}CLEARLOGO   :${NC} Creating optional Clearlogo.png image..."  
      font_color=( $(shuf -e "white" "yellow" "orange" "turquoise" "green") )
      border_color=( $(shuf -e "red" "black" "blue" "magenta") )
      font_family=( $(shuf -e "DejaVuSans-Bold.ttf" "DejaVuSans-Bold.ttf" "DejaVuSans-Bold.ttf" "DejaVuSerif-Bold.ttf" "DejaVuSansMono-Bold.ttf") )
      logo_text=${base_name[@]}
      chunks=$(( ${#logo_text} ))
      n=0
      while [ $n -lt $chunks ] && [ $n -lt 21 ]; do   
          echo -e ${logo_text:$n:4} >> "${f%.*}/title.txt";  let n=$(($n+4))       
      done
      ffmpeg -i "${ffmpeg_i[@]}" -filter_complex "[0:0]crop=2:2:0:0[img];color=c=0xffffff@0x00:s=720x1080,format=rgba,drawtext=textfile='${f%.*}/title.txt':fontfile=$font_family:fontcolor=$font_color:fontsize=214:bordercolor=$border_color:borderw=20:x=(w-text_w)/2:y=(h-text_h)/2[bg];[bg][img]overlay=0:0:format=rgb,format=rgba[out]" -map [out] -c:v png -frames:v 1 -loglevel error "${f%.*}/Clearlogo.png" -y
      rm "${f%.*}/title.txt"
      echo -e "${RED}DONE!${NC}"
    fi
    
    if [[ ! "${typed_arguments,,}" == *"-nometa"* ]]; then 
      echo -e -n "${RED}METAFILE    :${NC} Creating '${base_name[@]}.nfo' --a template XML metadata file..."
      rating=( $(shuf -e 7 8 9 10) )
      decade=( $(shuf -e 1980 1990 2000 2010 2020) ) 
      digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )

      default_plot="<![CDATA[Enjoy '${streams_stream_0_nb_frames}' frames of awesome content in '${format_duration}' of duration.]]>"
      if [ ! -f  "$1/plots.txt" ]; then
          IFS=$'\n'    
          if (dpkg -s xidel &> /dev/null) && (dpkg -s libssl-dev &> /dev/null); then
            html=($(xidel -s 'https://www.imdb.com/list/ls052725661' -e '//div[@class="ipc-html-content-inner-div"]' )) #-silent and -extract
            for ((i=0; i < ${#html[@]}; i+=1)); do
               echo -e "<![CDATA["${html[i]}"]]>" >> "$1/plots.txt"
            done
          else
            echo -e $default_plot >> "$1/plots.txt"
          fi
          echo -n ". Retrieving initial html data. This takes no more than a minute. "
          sleep 45 #secs. required to complete the xidel download
      fi
      if [ -f "$1/plots.txt" ]; then
          readarray -t PLOTS < "$1/plots.txt"
      else
          PLOTS=($default_plot)
      fi

      rating=( $(shuf -e 7 8 9 10) )
      decade=( $(shuf -e 1980 1990 2000 2010 2020) ) 
      digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )
      if [ $COUNTER -eq 1 ]; then #do  random shuffle only one time
        plot=( $(shuf -e $(seq 0 $(bc <<<"${#PLOTS[@]} - 1") ) ) )  
        mpaa=( $(shuf -e $(seq 0 $(bc <<<"${#MPAAS[@]} - 1") ) ) ) 
        actor=( $(shuf -e $(seq 0 $(bc <<<"${#ACTORS[@]} - 1") ) ) )
        role=( $(shuf -e $(seq 0 $(bc <<<"${#ROLES[@]} - 1") ) ) ) 
        director=( $(shuf -e $(seq 0 $(bc <<<"${#DIRECTORS[@]} - 1") ) ) )
        genre=( $(shuf -e $(seq 0 $(bc <<<"${#GENRES[@]} - 1") ) ) )
        studio=( $(shuf -e $(seq 0 $(bc <<<"${#STUDIOS[@]} - 1") ) ) )
        tag=( $(shuf -e $(seq 0 $(bc <<<"${#SEARCH_TAGS[@]} - 1") ) ) )
        trailer=( $(shuf -e $(seq 0 $(bc <<<"${#TRAILER_IDS[@]} - 1") ) ) )
      fi
      if [[ ! "${typed_arguments,,}" == *"-notrailer"* ]]; then 
        trailer_element="
  <trailer>plugin://plugin.video.youtube/?action=play_video&amp;videoid=${TRAILER_IDS[${trailer[$COUNTER]}]}</trailer>"
      fi      
      printf "<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<movie>
  <title>${base_name[@]}</title>
  <originaltitle>${base_name[@]}</originaltitle>
  <rating>${rating[1]}</rating>
  <criticrating>${rating[2]}.${digit[2]}</criticrating> 
  <year>$((${decade[1]} + ${digit[1]}))</year>
  <mpaa>${MPAAS[${mpaa[$COUNTER]}]}</mpaa>
  <dateadded>2021</dateadded>
  <tagline>Overview</tagline>
  <plot>${PLOTS[${plot[$COUNTER]}]}</plot>
  <actor>
    <name>${ACTORS[${actor[$(bc <<<"2*$COUNTER-1")]}]}</name>
    <role>${ROLES[${role[$(bc <<<"2*$COUNTER")]}]}</role>
  </actor>
  <actor>
    <name>${ACTORS[${actor[$(bc <<<"2*$COUNTER-1")]}]}</name>
    <role>${ROLES[${role[$(bc <<<"2*$COUNTER")]}]}</role>
  </actor>
  <director>${DIRECTORS[${director[$COUNTER]}]}</director>
  <genre>${GENRES[${genre[$COUNTER]}]}</genre>
  <genre>${GENRES[${genre[$COUNTER+2]}]}</genre>
  <studio>${STUDIOS[${studio[$COUNTER]}]}</studio>
  <tag>${SEARCH_TAGS[${tag[$COUNTER]}]}</tag>
  <tag>${SEARCH_TAGS[${tag[$COUNTER+1]}]}</tag>$trailer_element
</movie>" > "${f%.*}/${base_name[@]}"'.nfo'
      echo -e "${RED}DONE!${NC}"
    fi

    if [[ ! "${typed_arguments,,}" == *"-nomusic"* ]] && [ $COUNTER -lt 5 ]; then      
        echo -e -n "${RED}THEME MUSIC :${NC} Creating optional theme song (Due to copyright, ONLY the first 5 folders)..."  
        output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/theme.mp3"  
        source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'
        curl -o "$output_file" $source_url -s      
        echo -e "${RED}DONE!${NC}\n"
    fi
    echo
  
    let COUNTER++
done
#End funtionality

#Summary
count=$(find "$1" -type f -name "*.jpg" | wc -l)
echo -e "SUMMARY: At least ${count} images plus other assets were created to enhance the user viewing experience.\n\n" 
#EOF
#Inspiration: AskUbuntu-Iterate over files in directory, create folders based on file names and move files into respective folders



