#!/bin/bash
MAX_POSTERS=3
MAX_BACKDROPS=2
INHDR_TEXT='En  HDR!'
ACTORS=('Sara Hayek' 'Liza Taylor' 'Gina Close' 'Jimmy Chan' 'Lucho DiCaprio' 'Ant Banderas' 'Penelope Reyes')
ROLES=('the guest star' 'the home princess' 'the queen been' 'the goofy' 'the bully' 'the car driver' 'the expert biker'\
       'the football coach' 'the neighbor' 'ice cream seller' 'the action hero' 'the aristocratic actor' 'the cat lady' 'the choosen one'\
       'the con arist' 'the damsel in distress' 'the latin lover' 'the bandido' 'the femme fatale' 'the figaro' 'the last standing' 'the folk hero'\
       'the jocker' 'the supernatural entity' 'the gypsy' 'the harlequin' 'the igor' 'the innocent' 'the knight-errant' 'the machiavelle' 'the eccentric'\
       'the dreamy' 'the attactive' 'the friendly villain' 'the diva' 'the legend' 'the noble prince' 'the mischievous' 'the preppy' 'the seductor' 'the schoolma`am'\
       'the impostor' 'the sidekick' 'the southern belle' 'the wise' 'the yuppie')
DIRECTORS=('Dhina Marca' 'Elmher Curio' 'Steban Dido' 'Elba Lazo' 'Elma Montt' 'Mario Neta' 'Yola Prieto')
GENRES=('Thriller' 'Action' 'Reality' 'Adventure' 'Fiction' 'Suspense' 'Comedy-drama' 'Family-drama' 'Romance' 'Drama' 'Comedy' 'Mystery' 'Soap-opera' 'Family-Documentary' 'Sports' )
STUDIOS=('Meyer Metro Cooper' '21th Century Dog' 'Marvin Universe' 'Hannah-Barbara Entertainment' 'Dream Animation Pictures' 'Paramount Works' 'Universal Universe' 'Columbia Studios'\
         'Warm Brothers Films' 'Sonic Entertainment')
SEARCH_TAGS=('Birthday' 'Beach' 'Dancing' 'Streets' 'park' 'city' 'lake' 'snow' 'river')
TRAILER_IDS=('v-PjgYDrg70' 'iurbZwxKFUE' 'hu9bERy7XGY' 'G2gO5Br6r_4' 'un7a-i6pTS4' '-xjqxtt18Ys' 'LAr8SrBkDTI' 'vZnBR4SDIEs' 'mfw2JSDXUjE' 'CxwTLktovTU' 'eHcZlPpNt0Q' 'CwXOrWvPBPk'\
             '-UaGUdNJdRQ' 'eTjHiQKJUDY' 'CZ1CATNbXg0' '1XHf94YqGyQ' 'xBgSfhp5Fxo' 'GUvk7NNmB64' 'HKH7_n425Ss' 'JFsGn_JwzCc' 'sJCjKQQOqT0' '9oQ628Seb9w' 'glPzcdMX5wI' 'CGbgaHoapFM'\
             'DFTIL0ciHik' 'xNWSGRD5CzU' 'mE35XQFxbeo' '5iB82S8rHyg' '_MoIr7811Bs' '_MoIr7811Bs' 'siLm9q4WIjI' '9OAC55UWAQs' 'G2z-xAZRFcQ' 'WYTE2_W2O00' 'ie53R2HEZ6g' 'orAqhC-Hp_o'\
             'Wlo-sYrADlw' 'TQhRqtt-Fpo' 'Su7g8JVY0xI' '1sD4qkCymtI' 'kkrGBlvGK4I' 'HLw7pSXJe64' 'HlNRVZ871os' 'GV5y4yTDtBI' 'RFeNB8IlPlc' 'eRNPQmk6wLU' '4ffrsBbrrQU' 'O6i3lyx1I_g'\
             'Njf8U5SnM4w' 'M0vnBeHeuzs' 'i4noiCRJRoE' 'pfESEXIZ_lw' 'JX6btxoFhI8' 'eTjDsENDZ6s' '-agq5R3b43U' 'Vngk9Wp9bGk' 'vZIY2-kH-wE' '8IBNZ6O2kMk' 'ZS_8btMjx2U' 'SPHfeNgogVs'\
             'qCKdkbsMUA8' 'sED6FRXIHJc' 'lFzVJEksoDY' '-qCPMP4mNcQ' 'usEkWtuNn-w' 'SyYESEvDNIg' 'hAGzq5jLCEk' '2BkVf2voCr0')
TEASERS=('Famby Original Collection' 'Streaming Now' 'Streaming Everywhere' 'Only at Famby' 'Instantly Available Here!' 'On A SmartTV Near You!' 'Famby Exclusive!' 'Now Playing Everywhere')
#A Message for the End User: Do not modify below this line
GUI_ACCENTCOLOR1='ffffff'  #52B54B=LightGreen@Emby, A25FC4=Purle@Jellyfin, LightYellow@Plex
GUI_ACCENTCOLOR2='1FAF55'  #1FAF55=DarkGreen@Emby , 007EA8=Blue@Jellyfin, DarkYellow@Plex
SUPPORTED_EXT=("mkv" "mp4" "avi")
VALID_ARGUMENTS=( -noposter -noback -nologo -nometa -nomusic -notrailer -dorgb -docopy)
YELLOW='\033[1;33m'
RED='\033[0;33m'
NC='\033[0m' 
poster_radius=40
COUNTER=0;TOTAL_COUNTER=0

#Functions Begin
function ProcedureStringPad () { [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"; }
function ProcedureEchoFeedback () {
  case $1 in
    'COPY_MOVE'      ) echo -ne "${RED}$2${NC} $3\n"; return 1 ;;
  esac
  echo -ne "\033[0K\r"    
  case $1 in
    'ERROR'          ) echo -ne "${RED}ERROR       : ${NC}$2 ${YELLOW}$3${NC}\n" ;;
    'WORKING_ON'     ) echo -ne "${RED}("$2"of"$3")${NC} Working on ${YELLOW}"$4${NC}"..." ;;
    'POSTER_START'   ) echo -ne "${YELLOW}POSTERS     : ${NC}Working on posters...\033[0K" ;;

    'LOGO_WORK'      ) echo -ne "${YELLOW}LOGO        : ${NC}$2\033[0K" ;;
    'POSTER_WORK'    ) echo -ne "${YELLOW}POSTERS     : ${NC}$2 ${YELLOW}$3${NC} of $4...\033[0K" ;;
    'BACKGROUND_WORK') echo -ne "${YELLOW}BACKGROUNDS : ${NC}$2 ${YELLOW}$3${NC} of $4...\033[0K" ;;
    'METAFILE_WORK'  ) echo -ne "${YELLOW}METAFILE    : ${NC}$2\033[0K" ;;
    'THEME_WORK'     ) echo -ne "${YELLOW}THEME AUDIO : ${NC}$2\033[0K" ;;

    'LOGO_DONE'      ) echo -ne "${RED}LOGO        : ${NC}Logo for the film and poster created.  ${RED}DONE!${NC}\n" ;;
    'POSTER_DONE'    ) echo -ne "${RED}POSTERS     : ${YELLOW}$(echo "$n-1" | bc)${NC} image posters created. ${RED}DONE!${NC}. Other ${YELLOW}$(echo "$n-2" | bc)${NC} in /_temp directory might be more appealing.\n" ;;
    'BACKGROUND_DONE') echo -ne "${RED}BACKGROUNDS : ${YELLOW}$2${NC} background images created.  ${RED}DONE!${NC}\n" ;;
    'METAFILE_DONE'  ) echo -ne "${RED}METAFILE    : ${NC}Metafile with extension nfo sucessfully created.  ${RED}DONE!${NC}\n" ;;
    'THEME_DONE'     ) echo -ne "${RED}THEME AUDIO : ${NC}Thematic background audio file sucessfully created.  ${RED}DONE!${NC}\n" ;;
    'TRAILER_DONE'   ) echo -ne "${RED}TRAILER     : ${NC}Trailer video clip.  ${RED}DONE!${NC}                        \n" ;;
    'TRAILERS'       ) echo -ne "${YELLOW}TRAILER     : ${NC}Now, preparing trailer clip ${YELLOW}$2${NC} of $3...\033[0K" ;;
    'BACKGROUNDS'    ) echo -ne "${YELLOW}BACKGROUNDS : ${NC}Now, preparing background images ${YELLOW}$2${NC} of $3...\033[0K" ;;
                    *) echo -ne "${YELLOW}$(ProcedureStringPad $1 -12): ${NC}$2$3\033[0K" ;;
  esac
}

function ProcedureCreateChapterFile() {
  rexpr_txtfile="^([0-9]):([0-5][0-9]):([0-5][0-9].[0-9][0-9])[[:space:]](.*)?" #h:mm:ss.ff Anytext
  rexpr_ffprobe="^([0-9]):([0-5][0-9]):([0-5][0-9])(.*)?" #h:mm:ss.ff    
  while IFS= read -r line; do
    if [[ "$line" =~ $rexpr_txtfile ]]; then
      local title="${BASH_REMATCH[4]}"
      local timestamp=$(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc )
      local chapter_lines+=("${BASH_REMATCH[1]}:${BASH_REMATCH[2]}:${BASH_REMATCH[3]} $title")
      local pro_timestamp+=($timestamp)
      local pro_title+=("$title") 
    else
      echo "ERROR CHAPTER: $line"
    fi
  done < "$2" 
  if [[ $(ffprobe -v error -show_entries format=duration -of csv=p=0 -sexagesimal "$4") =~ $rexpr_ffprobe ]]; then
    local pro_timestamp+=( $(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc ) )
  fi
  text=";FFMETADATA1\n# ${base_name[@]} chapter(s) --as ffmpeg metadata format.\n\n"
  for ((i=0; i<${#pro_timestamp[@]} - 1; ++i)); do
    text+="# ${chapter_lines[$i]}\n[CHAPTER]\nTIMEBASE=1/1000\nSTART=${pro_timestamp[$i]}\nEND=$(bc <<<"${pro_timestamp[$i + 1]} - 1")\ntitle=${pro_title[$i]}\n\n"    
  done      
  ffmpeg_chapter_file=("${f%.*}/chapters.txt")
  printf "$text" > "${ffmpeg_chapter_file[@]}"
  ffmpeg -i "$1" -loglevel error -f ffmetadata -i "${ffmpeg_chapter_file[@]}" -c copy "$3"
}

function ProcedureRgbTo_ffmpeg_eq () {
  #INPUT  : rgb(125, 28, 20) Poster image expressed in RGB values --not Hex
  #OUTPUT : ffmpeg_eq variable: eq=gamma_r=1.25:gamma_g=0.28:gamma_b=0.20  
  rgbValues="$1";  reg_expr_parenthesis='.*?\((.+?)\)';
  if [[ $rgbValues =~ ${reg_expr_parenthesis} ]]; then 
    rgbValues="${BASH_REMATCH[1]}"
    IFS="," read -r valueR valueG valueB <<< "${rgbValues}"
    valueR=$(printf "%.2f\n" $(echo "scale=2; $valueR/100" | bc ) )
    valueG=$(printf "%.2f\n" $(echo "scale=2; $valueG/100" | bc ) )
    valueB=$(printf "%.2f\n" $(echo "scale=2; $valueB/100" | bc ) )
    ffmpeg_eq="eq=gamma_r=$valueR:gamma_g=$valueG:gamma_b=$valueB:gamma_weight=1"         
  else
    ffmpeg_eq=$rgbValues
  fi
}

function ProcedureFilenameToLinesArray() {
  logo_text="$1"
  #INPUT  : The video file name without the extension (accepts text sentences)
  #OUTPUT : $lines_array  (the file name organized as a maximun of 4 lines)
  #PURPOSE: Create a transparent image 310x202pixels horizontally divided in 2 tops of one-third (~66px) each and 2 bottoms of one-quarter (~35px) each.
  #         Characters per line limited to 20.  Lines limited to 4.  Lines 3 and 4 will be truncated if the $logo_text lenght exceeds this sizee.
  #STEP 1): Analyze input text, count words, check for spaces and capital letters and --if present, groups of words enclosed in special characters
  if [[ ! ${logo_text:0:19} =~ [[:space:]] ]]; then  #filename has no spaces in the first 20 chars.
    if [[ ${logo_text:0:19} =~ [A-Z] ]]; then        #filename has no spaces, but words can be segregated by inital capital letter
      logo_text=$(echo "${logo_text:0:19}${logo_text:19:${#logo_text}}" | sed 's/[A-Z]/ &/g')
    else                                              #filename has no spaces nor capital letter in the first 20 chars (this is worst case for title/logo design).
      line_index=0; length=${#logo_text}
      while [ $line_index -lt $length ] && [ $line_index -le 17 ]; do
        str+=${logo_text:$line_index:6}" "
        let line_index="$line_index + 6"
      done
      str+=${logo_text:$line_index:${#logo_text}}  #this is the 4th line which contains all remaining chars
      logo_text=$str
    fi
  fi
  logo_text=$(echo "$logo_text" | sed -r 's/[-_]+/ /g' )
  reg_expr_array=(); delimiter=""; 
  reg_expr_exclam3='.*?,[[:blank:]](.+?)\!'; reg_expr_exclam2='.*?,(.+?)\!'; reg_expr_exclam1='(?<=).*(?=!)'; reg_expr_latinexclam='.*?¡(.+?)!'; 
  reg_expr_question3='.*?,[[:blank:]](.+?)\?'; reg_expr_question2='.*?,(.+?)\?'; reg_expr_question1='(?<=).*(?=?)'; reg_expr_latinquestion='.*?¿(.+?)\?'; 
  reg_expr_parenthesis='.*?\((.+?)\)'; reg_expr_bracket='.*?\[(.+?)\]'; reg_expr_singlequotes="'(.*?)'"; reg_expr_bracket='.*?\[(.+?)\]';
  if [[ $logo_text =~ $reg_expr_bracket ]]; then reg_expr_array+=("]|$reg_expr_bracket|bracket"); fi
  if [[ $logo_text =~ $reg_expr_parenthesis ]]; then reg_expr_array+=(")|$reg_expr_parenthesis|parenthesis"); fi
  if [[ $logo_text =~ $reg_expr_singlequotes ]]; then reg_expr_array+=("'|$reg_expr_singlequotes|singlequotes"); fi
  if [[ $logo_text =~ $reg_expr_latinexclam ]]; then  reg_expr_array+=("!|$reg_expr_latinexclam|latinexclam"); 
  elif [[ $logo_text =~ $reg_expr_exclam3 ]]; then reg_expr_array+=("!|$reg_expr_exclam3|exclam3")
  elif [[ $logo_text =~ $reg_expr_exclam2 ]]; then reg_expr_array+=("!|$reg_expr_exclam2|exclam2")
  elif [[ $logo_text =~ $reg_expr_exclam1 ]]; then reg_expr_array+=("!|$reg_expr_exclam1|exclam1"); fi
  if [[ $logo_text =~ $reg_expr_latinquestion ]]; then  reg_expr_array+=("?|$reg_expr_latinquestion|latimexclam");
  elif [[ $logo_text =~ $reg_expr_question3 ]]; then reg_expr_array+=("?|$reg_expr_question3|question3")
  elif [[ $logo_text =~ $reg_expr_question2 ]]; then reg_expr_array+=("?|$reg_expr_question2|question2")
  elif [[ $logo_text =~ $reg_expr_question1 ]]; then reg_expr_array+=("?|$reg_expr_question1|question1"); fi
  for reg_expr in "${reg_expr_array[@]}"; do 
    IFS="|" read -r delimiter reg_expr whendebug <<< "${reg_expr}"
    if [[ $logo_text =~ $reg_expr ]]; then #echo -n "whendebug=$whendebug "
      enclosed="${BASH_REMATCH[1]}$delimiter"
      filler=$(seq -s■ $((20 - ${#enclosed} ))|tr -d '[:digit:]')
      logo_text=${logo_text/$enclosed/${enclosed//$' '/$'▀'}$filler} #read: on $logo_text, find $enclosed and replace by the filler stuff
    fi
  done

  #STEP 2): Regroup the words.  First 2 lines with more emphasis (less max chars=bigger fontsize)
  IFS=' ' read -ra words_array <<< "$logo_text"
  for (( i=0; i <= ${#words_array[@]} - 1; i++ )); do words_array[i]=${words_array[$i]//[■]/$''}; done  #; echo -n "${#words_array[$i]} "
  n1=${#words_array[i]}; n2=0; if [ ${#words_array[i + 1]} ]; then n2=${#words_array[i + 1]}; fi
  n3=${#words_array[i+2]}; n3=0; if [ ${#words_array[i + 3]} ]; then n4=${#words_array[i + 3]}; fi  
  lines_array=(); unset lines_array[@]; i=0; line_index=0;   
  while [ $i -lt ${#words_array[@]} ]; do    
    if [[ $line_index -le 2 ]]; then 
      if [[ $(( $n1 + $n2 )) -le 9 ]]; then
          lines_array[$line_index]="${words_array[i]}"▀"${words_array[i + 1]}"; let i++  #these 2 words are in one line, jump to i+1
      else 
        lines_array[$line_index]=${words_array[i]}; 
      fi
      if [[ $line_index -ge 3 ]]; then
        if [[ $(( $n3 + $n4 )) -le 14 ]]; then
          lines_array[$line_index]="${words_array[i]}"▀"${words_array[i + 3]}"; let i++  #these 2 words are in one line, jump to i+1
        else 
          lines_array[$line_index]=${words_array[i]}; 
        fi
      fi
    else 
      lines_array[3]+="${words_array[i]}▀"; 
    fi #keep adding everything else to last line #4
    let line_index++; let i++
  done  #at this moment we have final lines_arrays. Next step replace some fillers
  for (( i=0; i < ${#lines_array[@]}; i++ )); do lines_array[i]=${lines_array[$i]//[▀]/$' '}; done 
  for (( i=0; i < ${#lines_array[@]}; i++ )); do lines_array[i]=${lines_array[$i]//[:]/$'\:'}; done 
  for (( i=0; i < ${#lines_array[@]}; i++ )); do lines_array[i]="${lines_array[i]%"${lines_array[i]##*[![:space:]]}"}"; done 

  #STEP 3): Attempt to make the output lines prettier
  if [[ ${#lines_array[@]} -eq 1 ]]; then #Make ACRONYM from 3 first words
      first_letters=""; remove_for_acronym="[(-,[¡¿\']" 
      input=${lines_array[0]//$remove_for_acronym/$''}" "${lines_array[1]//$remove_for_acronym/$''}" "${lines_array[2]//$remove_for_acronym/$''}
      for word in $input; do word=${word^^}; first_letters+="${word:0:1}"; done
      for (( i=${#lines_array[@]}; i >=0 ; i-- )); do lines_array[i]=${lines_array[$i - 1]}; done 
      lines_array[0]=$first_letters"\:"
  fi
  #case ${#lines_array[@]} in
  #  "1") lines_array+=( $(seq -s▀ $((${#lines_array[0]} + 1))|tr -d '[:digit:]') ) ;;
  #  "2") lines_array+=( $(seq -s▀ $((${#lines_array[1]} + 1))|tr -d '[:digit:]') ) ;;
  #  "3") lines_array+=( $(seq -s… $((${#lines_array[2]} + 1))|tr -d '[:digit:]') ) ;;
  #esac
}
#End Functions


#Argument Validation Begin
if [[ $(whoami) -ne "root" ]]; then echo -e "Execute script with root account privileges: ${YELLOW}su - ${NC}"; exit 0; fi
if [[ -z ${@:1} ]] || [[ ${@:1} == -* ]]; then
  ProcedureEchoFeedback 'ERROR' 'Missing argument. No directory name in the command line.'
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
if [ $COUNTER -eq 0 ]; then ProcedureEchoFeedback 'ERROR' 'Missing directory or directory has no content.' "$1"; exit 0; fi
typed_arguments=${@:2}
for i in ${typed_arguments[@]}; do
  if [[ " ${VALID_ARGUMENTS[*]} " =~ [[:space:]]${i,,}[[:space:]] ]]; then recognized_args+=("${i,,} "); fi
done
#End Argument Vailidation

#Welcome Screen Begin
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
#End Welcome Screen

#Richerize Process Begin
COUNTER=1
for f in "$1"/*; do
  logger=(); unset logger[@]; expansionExpressionReplaceSpacewComma="${recognized_args[@]// /,}"; expansionExpressionReplaceSpacewComma=${recognized_args[@]/%/ ,}0
  logger+=("NOTE:  This log file is for diagnostic purposes. It is safe to delete as it does not affect playback functionality.")
  logger+=("MAX_POSTERS=$MAX_POSTERS,  MAX_BACKDROPS=$MAX_BACKDROPS")
  logger+=("COMMAND_ARGUMENTS: $expansionExpressionReplaceSpacewComma")  #IFS=, echo "${recognized_args[@]}"

  #Begin Move File and Chapterize(s)
  [ -d "$f" ] && continue; 
  if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi

  new_f=${f%.*}/"$(basename -- "$f")"   #the new file absolute path
  ffmpeg_i=("$new_f")                   #file names in array deals w/white spaces.
  new_f_array=("$new_f"); x1=${new_f_array[@]}; x2=${x1%.*}
  base_name=${x2##*/}
  ProcedureEchoFeedback 'WORKING_ON' $COUNTER $TOTAL_COUNTER "$(basename -- "$f")";  logger+=("WORKING_ON ${f%.*} ($COUNTER OF $TOTAL_COUNTER)")
  mkdir -p "${f%.*}"

  ffmpeg_f=("$f"); chapter_info=("${f%.*}.chapters.txt"); ffmpeg_i_with_chapters="${ffmpeg_i[@]}"
  if [[ "${typed_arguments,,}" == *"-docopy"* ]]; then 
    if [ -f "${chapter_info[@]}" ]; then          #chapter file exist, we need to work on it
      echo -e -n " Processing chapter..."
      ProcedureCreateChapterFile "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      ProcedureEchoFeedback 'COPY_MOVE' 'COPIED!' 'Chapters created in the process.'
      logger+=("File copied and Chapters created in the process.")
    else
      cp -a "$f" "${f%.*}/"
      ProcedureEchoFeedback 'COPY_MOVE' 'COPIED!'
    fi
  else
    if [ -f "${chapter_info[@]}" ]; then
      echo -e -n " Processing chapter..."
      ProcedureCreateChapterFile "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      sleep 5;
      rm "$f"
      ProcedureEchoFeedback 'COPY_MOVE' 'MOVED!' 'With chapters created in the process.'  
      logger+=("File moved and Chapters created in the process.")
    else
      mv "$f" "${f%.*}/"
      ProcedureEchoFeedback 'COPY_MOVE' 'MOVED!'
    fi
  fi
  #Move File(s) and Chapterize End

  #Begin File Profile
  eval $(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=codec_name,width,height,display_aspect_ratio,pix_fmt,color_range,color_primaries,color_space,color_transfer,bit_rate,r_frame_rate,nb_read_packets -of flat=s=_ "${ffmpeg_i[@]}")
  ffprobe_width=$streams_stream_0_width
  ffprobe_height=$streams_stream_0_height  
  ffprobe_codec_name=$streams_stream_0_codec_name             #h264
  ffprobe_pix_fmt=$streams_stream_0_pix_fmt                   #yuv420p
  ffprobe_color_range=$streams_stream_0_color_range           #tv
  ffprobe_color_primaries=$streams_stream_0_color_primaries   #Color primaries
  ffprobe_color_transfer=$streams_stream_0_color_transfer     #Transfer characteristics
  ffprobe_color_space=$streams_stream_0_color_space           #Matrix coefficients
  ffprobe_aspect_ratio=$streams_stream_0_display_aspect_ratio #"4:3"
  ffprobe_bit_rate_kbps="$(echo "scale=0; $streams_stream_0_bit_rate/1000" | bc )" 
  ffprobe_frame_rate="$(echo "scale=0; $streams_stream_0_r_frame_rate*1" | bc )"
  ffprobe_frames=$streams_stream_0_nb_read_packets
  ffprobe_duration=$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "${ffmpeg_i[@]}")
  dynamicRange="in SDR"
  if [[ $ffprobe_color_primaries == *"2020"* ]] && [[ $ffprobe_color_space == *"2020"* ]] && ( [[ $ffprobe_color_transfer != *"709"* ]] || [[ $ffprobe_color_transfer == *"601"* ]] ); then 
    dynamicRange="in HDR"
  fi
  classificationLetter=( $(shuf -e 'G' 'PG' 'PG-13' 'R' 'G' 'NR' 'PG-13' 'PG'))
  echo -e "${RED}METADATA    :${NC} $ffprobe_width"w×"$ffprobe_height"h" $ffprobe_aspect_ratio-$ffprobe_codec_name-$ffprobe_duration"secs w/$ffprobe_frames frames @$ffprobe_frame_rate"fps, $ffprobe_bit_rate_kbps"kbps" $dynamicRange. Not $classificationLetter"
  logger+=("METADATA: $ffprobe_width"w×"$ffprobe_height"h" $ffprobe_aspect_ratio-$ffprobe_codec_name-$ffprobe_duration"secs_w/$ffprobe_frames_frames,@$ffprobe_bit_rate_kbps"fps, $ffprobe_bit_rate_kbps"kbps" $dynamicRange. Not $classificationLetter")
  #File Profile End

  #Begin Coordinating Color Palette for use in Logo and Poster(s)
  dsPaletteCollection=(); unset dsPaletteCollection[@]; dsColor=(); unset dsColor[@]
  ds300=('404040|ffffff|C0C0C0|000000|Simil|format=gray|DarkGrey,White,LightGray,Black| 404040ffffffC0C0C0000000')
  ds301=('603F26|FFEAC5|FFDBB5|6C4E31|Simil|rgb(96, 63, 38)  |DarkBrown,LightWeath,Weath,Brown| ffeac5ffdbb56c4e31603f26')
  ds302=('640D6B|F1EAFF|E5D4FF|DCBFFF|Simil|rgb(100, 13,107) |DarkPurple,VeryLightViolet,LightViolet,OtherViolet| f1eaffe5d4ffdcbfffd0a2f7')
  ds303=('16423C|C4DAD2|6A9C89|E9EFEC|Simil|rgb(22, 66, 60)  |DarkGreen,LightGreen,Green,VeryLightGreen| 16423c6a9c89c4dad2e9efec')
  ds304=('176B87|86B6F6|B4D4FF|EEF5FF|Simil|rgb(23, 107, 135)|DarkAqua,Blue,LightBlue,VeryLightBlue| eef5ffb4d4ff86b6f6176b87')
  ds351=('6C946F|FFD35A|FFA823|DC0083|Mixed|rgb(108,148,111) |Green,Yellow,Orange,Purple| 6c946fffd35affa823dc0083')
  ds352=('FF8000|4C1F7A|219B9D|FFF455|Mixed|rgb(255,128, 0)  |Orange,Purple,Teal,Yellow(wasLightGray)| ff80004c1f7a219b9deeeeee')
  ds353=('57A6A1|F9E400|FFAF00|F5004F|Mixed|rgb(87,166,161)  |Teal,Yellow,Orange,Red| 7c00fef9e400ffaf00f5004f')
  ds354=('FF77B7|B1D690|FEEC37|FFA24C|Mixed|rgb(255,119,183) |Pink,LightGreen,Yellow,Orange| b1d690feec37ffa24cff77b7')
  ds355=('3B1E54|9B7EBD|D4BEE4|EEEEEE|Mixed|rgb(59, 30, 84)  |DarkPurple,Purple,Violet,LightGrey| 3b1e549b7ebdd4bee4eeeeee' )

  dsPaletteCollection=("ds300" "ds301" "ds302" "ds303" "ds304" "ds351" "ds352" "ds353" "ds354" "ds355")
  consistencySelection=( $(shuf -e "Simil" "Mixed") ) #"Test0" #( $(shuf -e "Simil" "Mixed") )
  for (( n=${#dsPaletteCollection[@]}; n > 0 ; n-- )); do
      for set in "${dsPaletteCollection[$n - 1]}"; do declare -n paletteSet="$set"; done
      if [[ "${paletteSet[0]:28:5}" =~ $consistencySelection  ]]; then dsColor+=($set); fi
  done
  dsColor=(  $(shuf -e ${dsColor[@]} ) )    
  for set in "${dsColor}"; do declare -n colorSet="$set"; done
  IFS="|" read -r color1 color2 color3 color4 consistency bgGammaRGB paletteDescription https_colorhunt_co_palette <<< "${colorSet[0]}"
  logger+=("  consistencySelection--> $consistencySelection"); logger+=("  dsColorSet--> ${colorSet[0]}")
  #Coordinating Color Palette End

  #Logo Image Begin
  if [[ ! "${typed_arguments,,}" == *"-nologo"* ]] || [[ ! "${typed_arguments,,}" == *"-noposter"* ]] ; then
    ProcedureEchoFeedback 'LOGO_WORK' "Designing a unique logo with a color palette $paletteDescription...";  logger+=("LOGO_(START)")
    ProcedureFilenameToLinesArray "${base_name[@]}"

    if [ ! -f  "${f%.*}/_temp" ]; then mkdir -p "${f%.*}/_temp"; fi
    _temp="${f%.*}/_temp";
    placeholderImage="$_temp/_temp310x202.png"
    ffmpeg -f lavfi -i "color=c=0xffffff@0x00:s=310x202:duration=1,format=rgba" "$placeholderImage" -y -loglevel panic

    pixelHeightArray=(); unset pixelHeightArray[@]; dsFonts=(); unset dsFonts[@]  
    dsFontsForLine1=(); dsFontsForLine234=(); dsFontsForLongerThan20=(); unset dsFontsForLine1[@]; unset dsFontsForLine234[@]; unset dsFontsForLongerThan20[@]

    ds00=('0|0|1|MC|OK|Oswald'         '1|80|74'  '2|80|76' '3|74|72' '4|74|70' '5|60|64'  '6|60|66'  '7|64|56' '8|58|56' '9|58|62' '10|58|64' '11|60|64' '12|58|62' '13|52|54' '14|50|54' '15|48|54' '16|44|48' '17|28|32' '18|28|34' '19|28|30' '20|30|34')
    ds01=('0|0|1|MC|OK|MouseMemoirs'   '1|78|64'  '2|78|64' '3|78|64' '4|78|68' '5|78|64'  '6|88|70'  '7|86|70' '8|64|56' '9|68|62' '10|70|62' '11|72|70' '12|72|66' '13|70|64' '14|68|64' '15|64|60' '16|58|56' '17|58|56' '18|40|38' '19|40|38' '20|40|34')
    ds02=('1|1|0|MC|OK|Ranchers'       '1|78|70'  '2|78|70' '3|74|68' '4|64|62' '5|64|62'  '6|58|54'  '7|58|54' '8|54|60' '9|58|56' '10|48|48' '11|46|46' '12|48|48' '13|46|48' '14|46|48' '15|44|48' '16|40|44' '17|38|42' '18|30|34' '19|30|34' '20|30|34')
    ds03=('0|0|0|MC|OK|Jersey 25'      '1|98|66'  '2|98|66' '3|94|64' '4|90|62' '5|90|62'  '6|90|62'  '7|88|60' '8|86|62' '9|80|58' '10|72|58' '11|64|50' '12|56|42' '13|52|42' '14|52|44' '15|50|44' '16|44|38' '17|40|34' '18|38|34' '19|34|28' '20|34|30')
    ds04=('1|1|0|MC|OK|Darumadrop One' '1|104|68' '2|98|68' '3|96|68' '4|92|68' '5|100|72' '6|100|68' '7|78|52' '8|72|52' '9|70|56' '10|58|46' '11|58|50' '12|50|42' '13|44|38' '14|42|36' '15|40|34' '16|38|36' '17|36|34' '18|34|34' '19|30|30' '20|30|28')
    ds05=('0|1|0|MC|OK|Archivo Black'  '1|90|70'  '2|88|66' '3|84|66' '4|84|70' '5|82|68'  '6|80|64'  '7|64|60' '8|64|62' '9|54|52' '10|48|48' '11|46|46' '12|40|40' '13|36|36' '14|34|34' '15|32|34' '16|30|30' '17|28|30' '18|28|30' '19|26|28' '20|22|24')
    ds06=('1|1|0|MC|OK|Slackey'        '1|80|64'  '2|86|74' '3|84|68' '4|80|68' '5|80|66'  '6|68|56'  '7|62|50' '8|52|46' '9|50|48' '10|42|40' '11|38|38' '12|36|36' '13|32|30' '14|32|32' '15|28|30' '16|26|26' '17|26|26' '18|24|26' '19|22|24' '20|20|22')
    ds07=('1|1|0|MC|OK|Chewy'          '1|84|68'  '2|84|78' '3|82|78' '4|84|78' '5|82|78'  '6|68|60'  '7|60|56' '8|60|56' '9|60|52' '10|58|58' '11|54|54' '12|52|52' '13|48|44' '14|46|44' '15|44|44' '16|40|40' '17|34|41' '18|30|36' '19|30|36' '20|30|36')
    ds08=('1|0|0|UP|OK|Bungee'         '1|90|72'  '2|88|68' '3|86|68' '4|88|68' '5|84|68'  '6|68|56'  '7|60|48' '8|54|44' '9|48|40' '10|44|38' '11|42|36' '12|38|32' '13|34|30' '14|32|28' '15|30|26' '16|28|26' '17|26|24' '18|24|24' '19|22|20' '20|22|20')
    ds09=('1|0|0|UP|NA|Pixeldead'      '1|88|70'  '2|88|66' '3|88|68' '4|88|72' '5|88|78'  '6|82|70'  '7|72|56' '8|62|50' '9|60|50' '10|50|48' '11|48|42' '12|42|40' '13|40|36' '14|36|34' '15|34|34' '16|32|32' '17|28|26' '18|32|34' '19|30|30' '20|26|26')
    ds10=('1|0|0|UP|OK|Nosifer'        '1|90|72'  '2|86|78' '3|88|80' '4|86|80' '5|58|60'  '6|52|58'  '7|48|54' '8|42|50' '9|36|44' '10|34|40' '11|34|40' '12|30|34' '13|26|32' '14|26|34' '15|24|30' '16|22|28' '17|22|28' '18|20|24' '19|18|24' '20|16|22')
    ds11=('1|0|0|UP|OK|Arco'           '1|86|68'  '2|86|68' '3|84|68' '4|82|68' '5|78|64'  '6|70|60'  '7|54|46' '8|52|46' '9|50|44' '10|42|38' '11|40|36' '12|36|34' '13|34|32' '14|30|28' '15|28|26' '16|28|26' '17|28|26' '18|26|26' '19|24|24' '20|22|22')
    ds12=('1|0|0|UP|OK|Sigmar One'     '1|84|76'  '2|84|66' '3|84|54' '4|84|62' '5|78|58'  '6|68|56'  '7|54|40' '8|52|44' '9|48|38' '10|42|38' '11|42|36' '12|38|32' '13|32|26' '14|30|26' '15|30|30' '16|28|24' '17|28|26' '18|26|24' '19|24|24' '20|22|20')
    ds13=('1|1|0|UP|OK|Trade Winds'    '1|82|72'  '2|80|70' '3|80|68' '4|82|68' '5|76|68'  '6|72|62'  '7|62|60' '8|60|60' '9|58|52' '10|50|50' '11|48|48' '12|42|42' '13|38|40' '14|38|40' '15|36|40' '16|32|30' '17|30|34' '18|30|30' '19|28|28' '20|26|26')

    dsFonts=( "ds00" "ds01" "ds02" "ds03" "ds04" "ds05" "ds06" "ds07" "ds08" "ds09" "ds10" "ds11" "ds12" "ds13" )    
    for (( n=${#dsFonts[@]}; n >=0 ; n-- )); do
        for set in "${dsFonts[$n - 1]}"; do declare -n dataSet="$set"; done
        IFS="|" read -r flag1 flag2 flag3 flagCase flagActive fontName <<< "${dataSet[0]}";
        if [ $flag1 -eq 1 ] && [[ $flagActive =~ "OK" ]]; then dsFontsForLine1+=($set); fi
        if [ $flag2 -eq 1 ] && [[ $flagActive =~ "OK" ]]; then dsFontsForLine234+=($set); fi
        if [ $flag3 -eq 1 ] && [[ $flagActive =~ "OK" ]]; then dsFontsForLongerThan20+=($set); fi    
    done
    dsFontsForLine1=(  $(shuf -e ${dsFontsForLine1[@]} ) )
    dsFontsForLine234=( $(shuf -e ${dsFontsForLine234[@]} ) )
    dsFontsForLongerThan20=(  $(shuf -e ${dsFontsForLongerThan20[@]} ) )
    logger+=("  dsFontsForLine1--> $dsFontsForLine1");  logger+=("  dsFontsForLine234--> $dsFontsForLine234");  logger+=("  dsFontsForLongerThan20--> $dsFontsForLongerThan20")
  
    textAlignment=( $(shuf -e "1" "(w-text_w)/2" "w-text_w-3") )
    for (( n=${#lines_array[@]}; n >=0 ; n-- )); do 
      if [[ ${#lines_array[$n]} -gt 20 ]]; then textAlignment="w-text_w-3"; fi 
    done
    logger+=("  textAlignment--> $textAlignment")
    
    flag_fontSelected=0
    for (( i=0; i < ${#lines_array[@]}; i++ )); do
      if [ $i -eq 0 ]; then
          fontColor=$color2; fontBorderColor=$color3
          for set in "${dsFontsForLine1}"; do declare -n dataSet="$set"; done
          flagCase=${dataSet[0]:6:2}; 
          if [[ $flagCase =~ "MC" ]]; then flag_fontSelected=( $(shuf -e 1 0 1 1 0) ); fi
          y_offset=1;
      fi

      if [ $i -gt 0 ] && [ $flag_fontSelected -eq 0 ]; then        
          for set in "${dsFontsForLine234[0]}"; do declare -n dataSet="$set"; done
          fontColor=$color3; fontBorderColor=$color4
          flag_fontSelected=( $(shuf -e 0 1 1 1 0 1 1) )
      fi
      IFS="|" read -r charCount fontSize pixelHeight <<< "${dataSet[ $(( ${#lines_array[$i]} )) ]}"

      if [[ ${#lines_array[$i]} -gt 20 ]]; then
          flag3=${dataSet[0]:4:1};
          if [[ $flag3 =~ "0" ]]; then
              for set in "${dsFontsForLongerThan20[0]}"; do declare -n dataSet="$set"; done
              IFS="|" read -r charCount fontSize pixelHeight <<< "${dataSet[20]}"
          fi
      fi
      
      fontName=${dataSet[0]:12}
      pixelHeightArray+=($pixelHeight)
      y_offset=1
      for (( n = 1; n < ${#pixelHeightArray[@]}; ++n )); do y_offset=$((y_offset + ${pixelHeightArray[$n - 1]} )); done
      if [[ $(echo "$y_offset + $pixelHeight" | bc) -gt 202 ]]; then y_offset=$(echo "202 - $pixelHeight" | bc); fi

      logger+=("  [${lines_array[$i]}]  fontName--> $fontName,  fontData="$charCount"|"$fontSize"|"$pixelHeight",   y_offset=$y_offset")
      ffmpeg -i "$placeholderImage" \
             -filter_complex "[0:0]crop=2:2:in_w:in_h[img];color=c=0xffffff@0x00:s=310x202,format=rgba \
                             ,drawtext=text='${lines_array[$i]}':fontfile=$fontName:fontcolor=$fontColor:fontsize=$fontSize:bordercolor=$fontBorderColor:borderw=1:shadowx=3:shadowy=3:x=$textAlignment:y=$y_offset[bg]; \
                             [bg][img]overlay=0:0:format=rgb,format=rgba[out]" \
             -map [out] -c:v png -frames:v 1 \
             "$_temp/_tempClearlogo$i.png" -y -loglevel error
    done #for i=0 to max lines_array()
    ffmpeg_filter_complex="[1]scale=-1:-1[b];[0][b] overlay"
    case ${#lines_array[@]} in
      1)  mv "$_temp/_tempClearlogo0.png" "$_temp/_tempClearlogo.png";; 

      2)  ffmpeg -i "$_temp/_tempClearlogo0.png" -i "$_temp/_tempClearlogo1.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempClearlogo.png" -y -loglevel error ;;

      3)  ffmpeg -i "$_temp/_tempClearlogo0.png" -i "$_temp/_tempClearlogo1.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempDraw01.png" -y -loglevel error  
          ffmpeg -i "$_temp/_tempDraw01.png" -i "$_temp/_tempClearlogo2.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempClearlogo.png" -y -loglevel error ;;

      4)  ffmpeg -i "$_temp/_tempClearlogo0.png" -i "$_temp/_tempClearlogo1.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempDraw01.png" -y -loglevel error  
          ffmpeg -i "$_temp/_tempDraw01.png" -i "$_temp/_tempClearlogo2.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempDraw02.png" -y -loglevel error
          ffmpeg -i "$_temp/_tempDraw02.png" -i "$_temp/_tempClearlogo3.png" \
                  -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                  "$_temp/_tempClearlogo.png" -y -loglevel error ;;
    esac 
    mv "$_temp/_tempClearlogo.png" "${f%.*}/Clearlogo.png" 
    rm -f -- "$_temp"/_temp*.*

    min=-3;  max=9
    stillFrameRotationAngle=$(( RANDOM % (max-min+1) + min ))
    clearlogoRotationAngle=$(( RANDOM % (max-min+1) + min ))

    expansionExpressionReplaceSpacewPlus=${pixelHeightArray[@]/%/ +}0
    clearlogoDrawboxDeco_h=$(echo $(( ${expansionExpressionReplaceSpacewPlus} )) )
    logger+=("  stillFrameRotationAngle--> $stillFrameRotationAngle,  clearlogoRotationAngle--> $clearlogoRotationAngle,  clearlogoDrawboxDeco_h--> $clearlogoDrawboxDeco_h") 

    ffmpeg -f lavfi -i "color=c=0xffffff@0x00:s=360x282:duration=1,format=rgba" "$_temp/_temp360x282.png" -y -loglevel panic  
    ffmpeg -i "$_temp/_temp360x282.png" -i "${f%.*}/Clearlogo.png" \
           -filter_complex "[1]scale=-1:180[clearlogo];
                            [0][clearlogo]overlay=30:54,rotate=-$clearlogoRotationAngle*PI/180,crop=310:202" \
            -vframes 1 \
           "$_temp/ClearlogoRotated.png" -y -loglevel error 
    rm -f "$_temp/_temp360x282.png"       
     
    ProcedureEchoFeedback 'LOGO_DONE'
    logger+=("LOGO_(DONE)")
  fi
  #End Logo Image


  #Poster Images Begin
  if [[ ! "${typed_arguments,,}" == *"-noposter"* ]]; then
    ProcedureEchoFeedback 'POSTER_START' 'Working on posters'; logger+=("POSTER_(START)")
    if [ ! -f  "${f%.*}/_temp" ]; then mkdir -p "${f%.*}/_temp"; fi
    _temp="${f%.*}/_temp";

    indx=( $(shuf -e $(seq 0 $(bc <<<"${#TEASERS[@]} - 1") ) ) ); TEASER=${TEASERS[$indx]};  logger+=("  indx, TEASER--> $indx, $TEASER")
    fontNameInHDR='Sigmar One'; fontNameTeaser='Oswald'; colorPosterBg=$color1;

    if [[ $dynamicRange == *"HDR"* ]]; then
      drawbox_inHDR=",drawbox=x=0:y=(ih/1.96):w=(iw*0.27):h=(ih*0.052):color=white@0.5:thickness=fill"
      drawtext_inHDR=",drawtext=text='$INHDR_TEXT':fontcolor=$GUI_ACCENTCOLOR1:fontfile='$fontNameInHDR':x=(w*0.02):y=(h/1.9):fontsize=(h*0.03):bordercolor='$GUI_ACCENTCOLOR2':borderw=6"
    fi
    ffmpeg_roundcorner="format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${poster_radius})*gt(abs(H/2-Y),H/2-${poster_radius}),\
                        if(lte(hypot(${poster_radius}-(W/2-abs(W/2-X)),${poster_radius}-(H/2-abs(H/2-Y))),${poster_radius}),255,0),255)'"

    if [[ $(( RANDOM % (30 + 30) + (-30) )) -ge 0  ]]; then  #if randon mumber >=0, then rotate still frame and use rotated logo, else use horizontal clearlogo.png image
      ffmpeg_scale="scale=-1:(ih/1.8)"
      ProcedureRgbTo_ffmpeg_eq "$bgGammaRGB" #assign value to $ffmpeg_eq
      ffmpeg_stillTransform="rotate=$stillFrameRotationAngle*PI/180:c=none"
      clearlogo_imagefolder="$_temp/ClearlogoRotated.png"
    else
      ffmpeg_scale="scale=-1:660"
      ffmpeg_eq="eq=brightness=0.2:contrast=1:saturation=1.5"
      ffmpeg_stillTransform="crop=740:660:160:(in_h)"
      clearlogo_imagefolder="${f%.*}/Clearlogo.png"
    fi
    logger+=("  ffmpeg_scale--> $ffmpeg_scale"); logger+=("  ffmpeg_eq--> $ffmpeg_eq"); 
    logger+=("  ffmpeg_stillTransform--> $ffmpeg_stillTransform");  logger+=("  clearlogo_imagefolder--> $clearlogo_imagefolder")

    ds90=('55:675' '0:100'    '0:25:780:74'    'x=(w-text_w)/2:y=45'   '160:720' 'teaser@top----still@mid-----clearlogo@bottom')
    ds91=('55:10'  '0:350'    '0:950:720:90'   'x=(w-text_w)/2:y=960'  '0:0'     'clearlogo@top-still@mid-----teaser@bottom'   )
    ds92=('55:620' '0:40'     '0:1020:720:60'  'x=(w-text_w)/2:y=1030' '0:0'     'still@top-----clearlogo@mid-teaser@bottom'   )
    ds93=('55:0'   '0:478'    '0:420:720:56'   'x=(w-text_w)/2:y=430'  '0:0'     'clearlogo@top-teaser@mid----still@bottom'    )
    ds94=('55:675' '-100:100' '0:25:780:74'    'x=(w-text_w)/2:y=45'   '0:0'     'teaser@top----still@mid-----clearlogo@bottom')
    ds95=('55:10'  '0:350'    '220:80:720:280' 'x=(w-text_w)/2:y=1035' '40:80'   'clearlogo@top-still@mid-----teaser@bottom'   )
    ds96=('55:680' '40:80'    '0:0:2:2'        'x=(w-text_w)/2:y=35'   '0:25'    'clearlogo@top-still@fill----teaser@bottom'   )
    dsPosterDesign="ds90"   #( $(shuf -e "ds90" "ds91" "ds92" "ds93" "ds94" "ds95" "ds96" ) )
    declare -n posterSet="$dsPosterDesign"; 
    clearLogo_xy=${posterSet[0]};   still_xy=${posterSet[1]};  drawboxTeaser_xywh=${posterSet[2]}; 
    fontTeaser_xy=${posterSet[3]};  clearlogoDeco_xy_w_h=${posterSet[4]}:$(( 320 * 2 + 20 )):$(( $clearlogoDrawboxDeco_h * 2 - 40));
    logger+=("  dsPosterDesign--> $dsPosterDesign"); logger+=("  clearLogo_xy--> $clearLogo_xy"); 

    drawbox_bgcolor=$color4  #( $(shuf -e  $color4 $colorPosterBg $colorPosterBg ) ) 
    drawbox_teaser="drawbox=$drawboxTeaser_xywh:color='$drawbox_bgcolor'@1:thickness=fill"
    drawtext_teaser="drawtext=text='$TEASER':fontcolor='$GUI_ACCENTCOLOR1':fontfile=$fontNameTeaser:$fontTeaser_xy:fontsize=h/28:bordercolor='$GUI_ACCENTCOLOR2':borderw=2"
    randomDrawboxDeco=( $(shuf -e ',drawbox=0:0:1:1' ',drawbox=0:0:1:1' ',drawbox=x=0:y=0:w=720:h=1080:color='$colorPosterBg'@1:t=2' ',drawbox=0:0:1:1' ',drawbox=x=0:y=0:w=720:h=1080:color='$colorPosterBg'@1:t=10' ))
    logger+=("  drawbox_bgcolor--> $drawbox_bgcolor"); logger+=("  randomDrawboxDeco--> $randomDrawboxDeco") 

    ffmpeg -f lavfi -i color=c=0x$colorPosterBg:duration=1:s=720x1080:r=1 \
            -filter_complex "$ffmpeg_roundcorner,$drawbox_teaser,$drawtext_teaser" \
            "$_temp/_tempRoundCornerBg.png" -y -loglevel error          

    if [[ $ffprobe_height -ge 1080 ]]; then
      posterStyle=( $(shuf -e 'style2' 'style2' 'style2') ); 
    elif [[ $ffprobe_height -gt 720 ]] && [[ $ffprobe_height -le 1079 ]]; then
      posterStyle=( $(shuf -e 'style1' 'style2') ); 
    else
      posterStyle='style1'
    fi
    logger+=("  posterStyle--> $posterStyle")    

    for ((n=1; n<=$MAX_POSTERS; n++)); do
      ProcedureEchoFeedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
      ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.10" | bc)";  
      if [ $(echo "scale=2; $ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi   #must add leading zero if ffmpeg_ssAt is less than 1.00

      case $posterStyle in  
      'style1')
        #A SolidColor as Background
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -filter_complex "null" \
               -frames:v 1 -q:v 1 \
               "$_temp/_tempStill$n.png" -y -loglevel error #$colorPosterBg

        ffmpeg -i "$_temp/_tempRoundCornerBg.png" -i "$_temp/_tempStill$n.png" -i "$clearlogo_imagefolder" \
               -filter_complex "[1]$ffmpeg_scale,$ffmpeg_eq,$ffmpeg_stillTransform[still]; \
                                [2]scale=-1:404[clearlogo]; \
                                [0][still]overlay=$still_xy,drawbox=$clearlogoDeco_xy_w_h:color='$color4'@0.8:thickness=fill$randomDrawboxDeco[partial]; \
                                [partial][clearlogo]overlay=$clearLogo_xy$drawbox_inHDR$drawtext_inHDR" -q:v 1 \
               "$_temp/poster$n.png" -y -loglevel error  ;;
      'style2')
        #A StillFrame as Background
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
                -filter_complex "crop=720:1080,eq=brightness=0.2:contrast=1:saturation=3,$ffmpeg_roundcorner,$drawbox_teaser,$drawtext_teaser,\
                                 drawbox=$clearlogoDeco_xy_w_h:color='$colorPosterBg'@0.3:thickness=fill$randomDrawboxDeco" \
                -frames:v 1 -q:v 1 \
                "$_temp/_tempStill$n.png" -y -loglevel error

        ffmpeg -i "$_temp/_tempStill$n.png" -i "$clearlogo_imagefolder" \
               -filter_complex "[1]scale=-1:404[clearlogo]; \
                                [0][clearlogo]overlay=$clearLogo_xy$drawbox_inHDR$drawtext_inHDR" \
               -q:v 1 \
               "$_temp/poster$n.png" -y -loglevel error  ;;      
      esac              
      rm -f "$_temp/_tempStill$n.png"
    done # n <1..$MAX_POSTERS

    rm -f "$_temp/_tempRoundCornerBg.png"
    rm -f "$_temp/ClearlogoRotated.png" 

    pick_a_poster=$((2 % $MAX_POSTERS))
    mv "$_temp/poster$(echo "$pick_a_poster + 1" | bc).png" "${f%.*}/Poster.png"    
    ProcedureEchoFeedback 'POSTER_DONE' $n
    
    logger+=("POSTER_(DONE)")
	fi
  #End Poster Images


  #Background/Backdrop Images Begin
  if [[ ! "${typed_arguments,,}" == *"-noback"* ]]; then
    if [[ "${typed_arguments,,}" == *"-dorgb"* ]]
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
    ffmpeg_eqRandom=( $(shuf -e $eqR $eqG $eqB $eqC $eqM $eqV $eqY $eqT $eqS $eqP $eqG2 $eqK) );  
    logger+=("BACKDROPS_(START)");
    for ((n=1; n<=$MAX_BACKDROPS; n++)); do
      ProcedureEchoFeedback 'BACKGROUND_WORK' 'Working on background image' $n $MAX_BACKDROPS
      ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_BACKDROPS*$n)-0.1" | bc)";  
      if [ $(bc <<< "$ffmpeg_ssAt < 1.00") -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
      ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 2 "${f%.*}/backdrop$n.jpg" -y -loglevel error
    done
    ProcedureEchoFeedback 'BACKGROUND_DONE' $n
    logger+=("  ffmpeg_eqRandom--> $ffmpeg_eqRandom")    
    logger+=("BACKDROPS_(DONE)")    
  fi
  #End Background Images

  #Begin Metadata
  if [[ ! "${typed_arguments,,}" == *"-nometa"* ]]; then 
    ProcedureEchoFeedback 'METAFILE_WORK' 'Now the editable metadata file...'; logger+=("METAFILE_(START)")

    default_plot="<![CDATA[Enjoy '${streams_stream_0_nb_frames}' frames of awesome content in '${format_duration}' of duration.]]>"
    if [ ! -f  "$1/plots.txt" ]; then
      IFS=$'\n'    
      if (dpkg -s xidel &> /dev/null) && (dpkg -s libssl-dev &> /dev/null); then
        html=($(xidel -s 'https://www.imdb.com/list/ls052725661' -e '//div[@class="ipc-html-content-inner-div"]' )) #-silent and -extract
        logger+=("  xidel used on $html to create $1/plots.txt")
        for ((i=0; i < ${#html[@]}; i+=1)); do
          echo -e "<![CDATA["${html[i]}"]]>" >> "$1/plots.txt"
        done
      else
        echo -e $default_plot >> "$1/plots.txt"
      fi
      echo -n ". Retrieving random plots from IMDB. This takes no more than a minute. "
      sleep 45 #secs. required to complete the xidel download
    fi
    if [ -f "$1/plots.txt" ]; then readarray -t PLOTS < "$1/plots.txt"; else PLOTS=($default_plot); fi
    rating=( $(shuf -e 7 8 9 10) )
    decade=( $(shuf -e 1980 1990 2000 2010 ) ) 
    digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )
    index_plot=( $(shuf -e $(seq 0 $(echo ${#PLOTS[@]}-1 | bc ) ) ) )   #www.imdb.com/list/ls05272566 or www.imdb.com/list/ls052725672/
    index_director=( $(shuf -e $(seq 0 $(echo ${#DIRECTORS[@]}-1 | bc ) ) ) )
    index_studio=( $(shuf -e $(seq 0 $(echo ${#STUDIOS[@]}-1 | bc ) ) ) )     
    index_actor1=( $(shuf -e $(seq 0 $(echo ${#ACTORS[@]}-1 | bc ) ) ) )
    index_actor2=( $(shuf -e $(seq 0 $(echo ${#ACTORS[@]}-1 | bc ) ) ) )
    until [[ $index_actor1 -ne $index_actor2 ]]; do index_actor2=( $(shuf -e $(seq 0 $(echo ${#ACTORS[@]}-1 | bc ) ) ) ); done  
    index_role1=( $(shuf -e $(seq 0 $(echo ${#ROLES[@]}-1 | bc ) ) ) )
    index_role2=( $(shuf -e $(seq 0 $(echo ${#ROLES[@]}-1 | bc ) ) ) )
    until [[ $index_role1 -ne $index_role2 ]]; do index_role2=( $(shuf -e $(seq 0 $(echo ${#ROLES[@]}-1 | bc ) ) ) ); done
    index_genre1=( $(shuf -e $(seq 0 $(echo ${#GENRES[@]}-1 | bc ) ) ) )
    index_genre2=( $(shuf -e $(seq 0 $(echo ${#GENRES[@]}-1 | bc ) ) ) )
    until [[ $index_genre1 -ne $index_genre2 ]]; do index_genre2=( $(shuf -e $(seq 0 $(echo ${#GENRES[@]}-1 | bc ) ) ) ); done
    index_searchTag1=( $(shuf -e $(seq 0 $(echo ${#SEARCH_TAGS[@]}-1 | bc ) ) ) )
    index_searchTag2=( $(shuf -e $(seq 0 $(echo ${#SEARCH_TAGS[@]}-1 | bc ) ) ) )
    until [[ $index_searchTag1 -ne $index_searchTag2 ]]; do index_searchTag2=( $(shuf -e $(seq 0 $(echo ${#SEARCH_TAGS[@]}-1 | bc ) ) ) ); done
    index_trailerID=( $(shuf -e $(seq 0 $(echo ${#TRAILER_IDS[@]}-1 | bc ) ) ) )

    if [[ ! "${typed_arguments,,}" == *"-notrailer"* ]]; then
      trailer_elementDisabledOpen="<!-- "
      trailer_elementDisabledClose=" -->"
    fi   
    printf "<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<movie>
  <title>${base_name[@]}</title>
  <originaltitle>${base_name[@]}</originaltitle>
  <rating>${rating[1]}</rating>
  <criticrating>${rating[2]}.${digit[2]}</criticrating> 
  <year>$((${decade[1]} + ${digit[1]}))</year>
  <mpaa>Not $classificationLetter</mpaa>
  <dateadded>2021</dateadded>
  <tagline>Overview</tagline>
  <plot>
    ${PLOTS[$index_plot]}
  </plot>
  <actor>
    <name>${ACTORS[$index_actor1]}</name>
    <role>${ROLES[$index_role1]}</role>
  </actor>
  <actor>
    <name>${ACTORS[$index_actor2]}</name>
    <role>${ROLES[$index_role2]}</role>
  </actor>
  <genre>${GENRES[$index_genre1]}</genre>
  <genre>${GENRES[$index_genre2]}</genre>
  <director>${DIRECTORS[$index_director]}</director>  
  <studio>${STUDIOS[$index_studio]}</studio>
  <tag>${SEARCH_TAGS[$index_searchTag1]}</tag>
  <tag>${SEARCH_TAGS[$index_searchTag2]}</tag>
  $trailer_elementDisabledOpen<trailer>plugin://plugin.video.youtube/?action=play_video&amp;videoid=${TRAILER_IDS[$index_trailerID]}</trailer>$trailer_elementDisabledClose
</movie>" > "${f%.*}/${base_name[@]}"'.nfo'
    ProcedureEchoFeedback 'METAFILE_DONE'
    logger+=("  rating[1]         --> ${rating[1]}=<rating>")
    logger+=("  rating[2].digit[2]--> ${rating[2]}.${digit[2]}=<criticrating>")
    logger+=("  decade[1]+digit[1]--> ${decade[1]}+${digit[1]} =<year>")    
    logger+=("  index_plot        --> $index_plot, ${PLOTS[$index_plot]:0:48}...")
    logger+=("  index_actor1      --> $index_actor1, ${ACTORS[$index_actor1]}")
    logger+=("  index_role1       --> $index_role1, ${ROLES[$index_role1]}")
    logger+=("  index_actor2      --> $index_actor2, ${ACTORS[$index_actor2]}")
    logger+=("  index_role2       --> $index_role2, ${ROLES[$index_role2]}")
    logger+=("  index_genre1      --> $index_genre1, ${GENRES[$index_genre1]}")
    logger+=("  index_genre2      --> $index_genre2, ${GENRES[$index_genre2]}")
    logger+=("  index_director    --> $index_director, ${DIRECTORS[$index_director]}")      
    logger+=("  index_studio      --> $index_studio, ${STUDIOS[$index_studio]}")  
    logger+=("  index_searchTag1  --> $index_searchTag1, ${SEARCH_TAGS[$index_searchTag1]}")
    logger+=("  index_searchTag2  --> $index_searchTag2, ${SEARCH_TAGS[$index_searchTag2]}")
    logger+=("  index_trailerID   --> $trailer_elementDisabledOpen $index_trailerID, ${TRAILER_IDS[$index_trailerID]} $trailer_elementDisabledClose")
    logger+=("METAFILE_(DONE)")
  fi
  #End Metadata


  #Movie Trailer Begin
  if [[ ! "${typed_arguments,,}" == *"-notrailer"* ]]; then
    MAX_TRAILER_CLIPS=4;
    CLIP_DURATIONSECS="7.00"
    CLIP_SPANSECS="4.00"

    ProcedureEchoFeedback 'TRAILER' 'Generating a random rate screen for this film...';  logger+=("TRAILER_(START)")
    RATE_TITLE=('THE FOLLOWING FEATURE HAS NOT BEEN RATED' 'THIS PREVIEW HAS NOT BEEN RATED' 'THIS MOTION FILM NAS NOT BEEN RATED')
    indx=( $(shuf -e $(seq 0 $(bc <<<"${#RATE_TITLE[@]}-1") ) ) )
    rate_title=${RATE_TITLE[$indx]}
    logger+=("  MAX_TRAILER_CLIPS=$MAX_TRAILER_CLIPS, CLIP_DURATIONSECS=$CLIP_DURATIONSECS, CLIP_SPANSECS=$CLIP_SPANSECS")
    logger+=("  indx, rate_title --> $indx, $rate_title")  

    dsReason=( $(shuf -e 'Because Some Material|May Be Insanely Memorable|For Unprepared Viewers|' \
                         'Due to Over-emotional,|Intense, Undisturbing|Graphic Material|' \
                         'For Fool Scences,|Mild Appropiate Dialogs,|and Goofy Language|' \
                         'For Inoffensive Scenes|Fool and Goofy|Mild Expressions|' \
                         'Due to Implicit Content|Showing Scences Full Of|Memory and Happiness|') )
    IFS="|" read -r rateLine1 rateLine2 rateLine3 foo_unused_but_required_as_stopper_due_to_wspaces <<< "${dsReason[@]}"

    case $classificationLetter in
      'G'    ) dsClassification=('green|w*0.251|h*0.194|0.12|black|white|General Audiences Admitted|white|') ;;
      'PG'   ) dsClassification=('maroon|w*0.236|h*0.213|0.10|red|yellow|Family Guidance Suggested|yellow|') ;;
      'PG-13') dsClassification=('purple|w*0.218|h*0.241|0.06|11235A|F6ECA9|Unrestricted Under 13|F6ECA9|') ;;
      'R'    ) dsClassification=('darkblue|w*0.251|h*0.194|0.12|black|white|Restricted Audiences|white|') ;;
      'NR'   ) dsClassification=('black|w*0.236|h*0.213|0.10|white|maroon|Content Has Not Been Rated|white|') ;;
    esac
    IFS="|" read -r screenColor letterX letterY letterFontSize letterBgColor letterTextColor classificationLineText classificationLineTextColor foo_unused_but_required_as_stopper_due_to_wspaces <<< "${dsClassification[@]}"      
    
    _temp="${f%.*}/_temp"
    if [ ! -f "RATING-logo.png" ]; then
      output_file="RATING-logo.png"
      source_url='https://raw.githubusercontent.com/dragonmarsx/VirtualServerSeries/afa30684c30dc779366b71ab931b2a6b412d0d00/_resources/RATING-logo.png'
      curl -o "$output_file" $source_url -s
    fi
    melodyIndex=( $(shuf -e 4 3 2 1) )    
    if [ ! -f "AccentMelody$melodyIndex.mp3" ]; then
      output_file="AccentMelody$melodyIndex.mp3"
      source_url='https://filesamples.com/samples/audio/mp3/sample'$melodyIndex'.mp3'  
      curl -o "$output_file" $source_url -s 
    fi
    logger+=("  melodyIndex     --> $melodyIndex")
    
    rateScreenFontName="Archivo Black"
    classificationFontName="Sigmar One"      
    rateTextBorder='bordercolor=black:borderw=1:shadowx=3:shadowy=3'
    if [ $(echo "$ffprobe_height <= 1080" | bc ) ]; then logoScale=0.8; else logoScale=3.1; fi
    RATINGCLIP_DURATIONSECS="5.0"
    ffmpeg -f lavfi -i color=c=$screenColor@1:duration=$RATINGCLIP_DURATIONSECS:s=$ffprobe_width"x"$ffprobe_height:r=$ffprobe_frame_rate -i RATING-logo.png -f lavfi -t $RATINGCLIP_DURATIONSECS -i anullsrc \
           -filter_complex "[1:v]scale=-1:(ih*$logoScale)[ratelogo], \
                            [0:v][ratelogo]overlay=x=(main_w-overlay_w)/2:y=(main_h*0.66), \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.208):h=(ih*0.210):color='$letterBgColor'@1:thickness=fill:enable='between(t,0,$RATINGCLIP_DURATIONSECS)', \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.32):color='white'@1:t=10:enable='between(t,0,$RATINGCLIP_DURATIONSECS)', \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.210):color='white'@1:t=5:enable='between(t,0,$RATINGCLIP_DURATIONSECS)', \
                            drawtext=text='$rate_title':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.10):fontsize=(w*0.030):$rateTextBorder, \
                            drawtext=text='$classificationLetter':fontcolor='$letterTextColor':fontfile='$classificationFontName':x=$letterX:y=$letterY:fontsize=(w*$letterFontSize):$rateTextBorder, \
                            drawtext=text='$(echo -e $rateLine1"\n"$rateLine2"\n"$rateLine3)':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.438):y=(h*0.210+8):fontsize=(w*0.022):$rateTextBorder, \
                            drawtext=text='$classificationLineText':fontcolor='$classificationLineTextColor':fontfile='$classificationFontName':x=(w-text_w)/2:y=(h*0.40):fontsize=(w*0.03):$rateTextBorder, \
                            drawtext=text='BY SOME':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.55):fontsize=(w*0.025):$rateTextBorder, \
                            drawtext=text='MOTION FILM CLASSIFICATION SYSTEM ON EARTH':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.60):fontsize=(w*0.025):$rateTextBorder, \
                            drawtext=text='www.popcornratings.corn':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.07):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
                            drawtext=text='www.freefamily.films':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.76):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
                            drawtext=text='®':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.83):y=(h*0.45):fontsize=(w*0.035):$rateTextBorder" \
          "$_temp/_tempRating.mp4" -y -loglevel error
    rm -f "$_temp/_tempClips.txt"
    echo "file '_tempRating.mp4'" >> "$_temp/_tempClips.txt"

    LOGOCLIP_DURATIONSECS="7.0"  #MIN 4.0
    ffmpeg -f lavfi -i color=c=$color1@1:duration=$LOGOCLIP_DURATIONSECS:s=$ffprobe_width"x"$ffprobe_height:r=$ffprobe_frame_rate -i "${f%.*}/Clearlogo.png" -f lavfi -t $LOGOCLIP_DURATIONSECS -i anullsrc \
           -filter_complex "[1:v]scale=(iw*4):-1[clearlogo],\
                            [0:v][clearlogo]overlay=x='if(lte(t,3), 50+(t/3)*100, 200)':y=(main_h-overlay_h)/2-60,\
                            drawbox=x=0:y=(ih-60):w=$ffprobe_width:h=60:color=$color1@1:thickness=fill:enable='between(t,0,$CLIP_DURATIONSECS)', \
                            drawtext=text='$TEASER ($dynamicRange video quality)':fontcolor='$color3':fontfile='$rateScreenFontName':bordercolor=$color4:borderw=1:x=(w-text_w)/2:y=(h-50):fontsize=30, \
                            fade=type=out:duration=3.0:start_time=2.0" \
          "$_temp/_tempLogo.mp4" -y -loglevel error
  
    for ((n=1; n<=$MAX_TRAILER_CLIPS; n++)); do
      ProcedureEchoFeedback "TRAILERS" $n $MAX_TRAILER_CLIPS
      ffmpeg_ssAt=$(echo "scale=1;($ffprobe_duration/$MAX_TRAILER_CLIPS*$n)-($CLIP_SPANSECS - 1.00)" | bc);  #formula to calculate where the $MAX_TRAILER_CLIPS clips starts within the total length of video (w/1 second pad)
      ffmpeg_ssTo=$(echo "scale=1;($ffmpeg_ssAt + $CLIP_SPANSECS)" | bc);  
      if [ $(echo "scale=1;$ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi	#Add a zero, in case the first(s) clip start less than 1 second.
      if [ $(echo "scale=1;$ffmpeg_ssTo < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssTo='0'$ffmpeg_ssTo; fi
      logger+=("  n=$n, ffmpeg_ssAt=$ffmpeg_ssAt, ffmpeg_ssTo=$ffmpeg_ssTo")

      ffmpeg -i "${ffmpeg_i[@]}" -ss $ffmpeg_ssAt -to $ffmpeg_ssTo -c copy "$_temp/_tempClip$n.mp4" -y -loglevel error  #Creates small clip lasting $CLIP_SPANSECS.       
      if [ $n -lt $MAX_TRAILER_CLIPS ]; then #clipTail zoomed-in
        echo "file '_tempClip$n.mp4'" >> "$_temp/_tempClips.txt"
        ffmpeg -ss $ffmpeg_ssTo -i "${ffmpeg_i[@]}" -vframes 1 -q:v 2 "$_temp/_tempClipTail$n.jpg" -y -loglevel error
        ffmpeg -loop 1 -framerate $ffprobe_frame_rate -i "$_temp/_tempClipTail$n.jpg" -f lavfi -t $CLIP_DURATIONSECS -i anullsrc \
                -filter_complex "zoompan=z='zoom+0.006':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2):d=6*$ffprobe_frame_rate:s=$ffprobe_width"x"$ffprobe_height:fps=$ffprobe_frame_rate" \
                -t 2 -c:v libx264 -pix_fmt yuv420p \
        "$_temp/_tempClipTail$n.mp4" -y -loglevel error
        rm -f "$_temp/_tempClipTail$n.jpg"
      else #clipTail frozen 
        ffmpeg -i "$_temp/_tempClip$n.mp4" \
               -vcodec copy -af apad -t $(echo "$CLIP_SPANSECS + 2.00" | bc) \
        "$_temp/_tempClipTail$n.mp4" -y -loglevel error        
      fi
      echo "file '_tempClipTail$n.mp4'" >> "$_temp/_tempClips.txt"
    done
    echo "file '_tempLogo.mp4'" >> "$_temp/_tempClips.txt"
    ProcedureEchoFeedback 'TRAILER' "Merging ${YELLOW}$(echo "$n*2" | bc )${NC} individual clips take processing power.  Be patient, be patient..."
 
    trailer_bit_rate=$(echo "$ffprobe_bit_rate_kbps*1000/8" | bc)    #lower the trailer bitrate in ~1/8th. 
    ffmpeg -f concat -safe 0 -i "$_temp/_tempClips.txt" -c:v libx264 -crf 30 -b:v $trailer_bit_rate "$_temp/_temptrailer_nobackmusic.mp4" -y -loglevel error
    logger+=("  trailer_bit_rate--> $trailer_bit_rate  ($ffprobe_bit_rate_kbps*1000/8)")

    ProcedureEchoFeedback 'TRAILER' 'Finalizing trailer may take a while...'
    delayms=$(echo "$CLIP_DURATIONSECS*100 + 100" | bc)
    ffmpeg -i "$_temp/_temptrailer_nobackmusic.mp4" -i "AccentMelody$melodyIndex.mp3" \
           -filter_complex "[1:a] adelay=$delayms|$delayms,volume=0.05,apad[music]; \
                            [0:a][music]amerge[out]" \
           -c:v copy -map 0:v -map "[out]" \
           "${f%.*}/${base_name[@]}-trailer.mp4" -y -loglevel panic
    mv "$_temp/_tempRating.mp4" "${f%.*}/${base_name[@]}-rating.mp4"
    rm -f -- "$_temp"/_temp*.*    
    ProcedureEchoFeedback "TRAILER_DONE"
    logger+=("TRAILER_(DONE)")
  fi
  #End Movie Trailer

  #Background Audio Begin
  if [[ ! "${typed_arguments,,}" == *"-nomusic"* ]] && [ $COUNTER -lt 6 ]; then
    ProcedureEchoFeedback 'THEME_WORK' ' Creating theme song (limited to 5)...';  logger+=("THEME_(START)")
    output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/theme.mp3"  
    source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'  
    curl -o "$output_file" $source_url -s      
    ProcedureEchoFeedback 'THEME_DONE';   logger+=("THEME_(DONE)")
  else
    echo -e "${RED}THEME AUDIO :${NC} ...${RED}SKIPPED!${NC}"  
  fi
  #End Background Audio

  if [ -z "$( ls -A "${f%.*}/_temp" )" ]; then  #_temp directory is empty
    rm -Rf "${f%.*}/_temp"   #"${f%.*}/_temp"
  fi

  echo
  printf '%s\n' "${logger[@]}" > "$_temp/_log.txt" 
  let COUNTER++
done
#End Richerize Process


#Summary and clean-up
count=$(find "$1" -type f -name "*.jpg" | wc -l)
count=$(echo "$count + $(find "$1" -type f -name "*.mp4" | wc -l)" | bc)
count=$(echo "$count + $(find "$1" -type f -name "*.png" | wc -l)" | bc)
echo -e "SUMMARY: At least ${count} images and other assets were created to enhance the user viewing experience.\n\n" 
#End Summary and clean-up

#EOF
#Script's starting point: AskUbuntu-Iterate over files in directory, create folders based on file names and move files into respective folders
