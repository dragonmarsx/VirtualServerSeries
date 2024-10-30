#!/bin/bash
MAX_POSTERS=3
MAX_BACKDROPS=2
ACTORS=('Sara Hayek' 'Liza Taylor' 'Gina Close' 'Jimmy Chan' 'Lucho DiCaprio' 'Ant Banderas' 'Penelope Reyes')
ROLES=('the guest star' 'the home princess' 'the queen been' 'the goofy' 'the bully' 'the car driver' 'the expert biker' 'the football coach' 'the neighbor' 'ice cream seller' 'the action hero' 'the aristocratic actor' 'the cat lady' 'the choosen one' 'the con arist' 'the damsel in distress' 'the latin lover' 'the bandido' 'the femme fatale' 'the figaro' 'the last standing' 'the folk hero' 'the jocker' 'the supernatural entity' 'the gypsy' 'the harlequin' 'the igor' 'the innocent' 'the knight-errant' 'the machiavelle' 'the eccentric' 'the dreamy' 'the attactive' 'the friendly villain' 'the diva' 'the legend' 'the noble prince' 'the mischievous' 'the preppy' 'the seductor' 'the schoolma`am' 'the impostor' 'the sidekick' 'the southern belle' 'the wise' 'the yuppie')
DIRECTORS=('Dhina Marca' 'Elmher Curio' 'Steban Dido' 'Elba Lazo' 'Elma Montt' 'Mario Neta' 'Yola Prieto')
GENRES=('Thriller' 'Action' 'Reality' 'Adventure' 'Fiction' 'Suspense' 'Comedy drama' 'Family drama' 'Romance' 'Drama' 'Comedy' 'Mystery' 'Soap opera' 'Documentary' 'Sports' )
STUDIOS=('Metro Golden Meyer' '20th Century Fox' 'Marvel Universe' 'Hanna-Barbera Studios' 'DreamWorks Animation' 'Paramount Pictures' 'Universal Pictures' 'Columbia Pictures' 'Warner Bros. Studios' 'Sony Picture Studios')
SEARCH_TAGS=('Birthday' 'Beach' 'Dancing' 'Streets' 'park' 'city' 'lake' 'snow' 'river')
TRAILER_IDS=('v-PjgYDrg70' 'iurbZwxKFUE' 'hu9bERy7XGY' 'G2gO5Br6r_4' 'un7a-i6pTS4' '-xjqxtt18Ys' 'LAr8SrBkDTI' 'vZnBR4SDIEs' 'mfw2JSDXUjE' 'CxwTLktovTU' 'eHcZlPpNt0Q' 'CwXOrWvPBPk' '-UaGUdNJdRQ' 'eTjHiQKJUDY' 'CZ1CATNbXg0' '1XHf94YqGyQ' 'xBgSfhp5Fxo' 'GUvk7NNmB64' 'HKH7_n425Ss' 'JFsGn_JwzCc' 'sJCjKQQOqT0' '9oQ628Seb9w' 'glPzcdMX5wI' 'CGbgaHoapFM' 'DFTIL0ciHik' 'xNWSGRD5CzU' 'mE35XQFxbeo' '5iB82S8rHyg' '_MoIr7811Bs' '_MoIr7811Bs' 'siLm9q4WIjI' '9OAC55UWAQs' 'G2z-xAZRFcQ' 'WYTE2_W2O00' 'ie53R2HEZ6g' 'orAqhC-Hp_o' 'Wlo-sYrADlw' 'TQhRqtt-Fpo' 'Su7g8JVY0xI' '1sD4qkCymtI' 'kkrGBlvGK4I' 'HLw7pSXJe64' 'HlNRVZ871os' 'GV5y4yTDtBI' 'RFeNB8IlPlc' 'eRNPQmk6wLU' '4ffrsBbrrQU' 'O6i3lyx1I_g' 'Njf8U5SnM4w' 'M0vnBeHeuzs' 'i4noiCRJRoE' 'pfESEXIZ_lw' 'JX6btxoFhI8' 'eTjDsENDZ6s' '-agq5R3b43U' 'Vngk9Wp9bGk' 'vZIY2-kH-wE' '8IBNZ6O2kMk' 'ZS_8btMjx2U' 'SPHfeNgogVs' 'qCKdkbsMUA8' 'sED6FRXIHJc' 'lFzVJEksoDY' '-qCPMP4mNcQ' 'usEkWtuNn-w' 'SyYESEvDNIg' 'hAGzq5jLCEk' '2BkVf2voCr0')
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
    'POSTER_DONE'    ) echo -ne "${RED}POSTERS     : ${YELLOW}$(echo "$n-1" | bc)${NC} image posters created. ${RED}DONE!${NC}. Other ${YELLOW}$(echo "$n-2" | bc)${NC} in /_temp directory maybe more appealing.\n" ;;
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

  #STEP 3): Attempt to make the output lines prettier
  if [[ ${#lines_array[@]} -eq 1 ]]; then #Make ACRONYM from 3 first words
      first_letters=""; remove_for_acronym="[(-,[¡¿\']" 
      input=${lines_array[0]//$remove_for_acronym/$''}" "${lines_array[1]//$remove_for_acronym/$''}" "${lines_array[2]//$remove_for_acronym/$''}
      for word in $input; do word=${word^^}; first_letters+="${word:0:1}"; done
      for (( i=${#lines_array[@]}; i >=0 ; i-- )); do lines_array[i]=${lines_array[$i - 1]}; done 
      lines_array[0]=$first_letters"\:"
  fi
  case ${#lines_array[@]} in
    "1") lines_array[2]=$(seq -s▀ $((${#lines_array[0]} + 1))|tr -d '[:digit:]') ;;
    "2") lines_array[3]=$(seq -s… $((${#lines_array[1]} + 1))|tr -d '[:digit:]') ;;
    "3") lines_array[4]=$(seq -s─ $((${#lines_array[2]} + 1))|tr -d '[:digit:]') ;;
  esac

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

  #Begin Move File and Chapterize(s)
  [ -d "$f" ] && continue; 
  if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi

  new_f=${f%.*}/"$(basename -- "$f")"   #the new file absolute path
  ffmpeg_i=("$new_f")                   #file names in array deals w/white spaces.
  new_f_array=("$new_f"); x1=${new_f_array[@]}; x2=${x1%.*}
  base_name=${x2##*/}
  ProcedureEchoFeedback 'WORKING_ON' $COUNTER $TOTAL_COUNTER "$(basename -- "$f")"
  mkdir -p "${f%.*}"

  ffmpeg_f=("$f"); chapter_info=("${f%.*}.chapters.txt"); ffmpeg_i_with_chapters="${ffmpeg_i[@]}"
  if [[ "${typed_arguments,,}" == *"-docopy"* ]]; then 
    if [ -f "${chapter_info[@]}" ]; then          #chapter file exist, we need to work on it
      echo -e -n " Processing chapter..." 
      ProcedureCreateChapterFile "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      ProcedureEchoFeedback 'COPY_MOVE' 'COPIED!' 'Chapters created in the process.'
    else
      cp -a "$f" "${f%.*}/"
      ProcedureEchoFeedback 'COPY_MOVE' 'COPIED!'
      #echo -e "${RED}COPIED!${NC}"
    fi
  else
    if [ -f "${chapter_info[@]}" ]; then
      echo -e -n " Processing chapter..."
      ProcedureCreateChapterFile "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      sleep 5;
      rm "$f"
      ProcedureEchoFeedback 'COPY_MOVE' 'MOVED!' 'With chapters created in the process.'
    else
      mv "$f" "${f%.*}/"
      ProcedureEchoFeedback 'COPY_MOVE' 'MOVED!'
    fi
  fi
  #Move File(s) and Chapterize End

  #Begin File Profile
  eval $(ffprobe -v error -select_streams v:0 -count_packets -show_entries stream=codec_name,width,height,display_aspect_ratio,pix_fmt,color_range,color_primaries,color_space,color_transfer,r_frame_rate,nb_read_packets -of flat=s=_ "${ffmpeg_i[@]}")
  ffprobe_width=$streams_stream_0_width
  ffprobe_height=$streams_stream_0_height  
  ffprobe_codec_name=$streams_stream_0_codec_name             #h264
  ffprobe_pix_fmt=$streams_stream_0_pix_fmt                   #yuv420p
  ffprobe_color_range=$streams_stream_0_color_range           #tv
  ffprobe_color_primaries=$streams_stream_0_color_primaries   #Color primaries
  ffprobe_color_transfer=$streams_stream_0_color_transfer     #Transfer characteristics
  ffprobe_color_space=$streams_stream_0_color_space           #Matrix coefficients
  ffprobe_aspect_ratio=$streams_stream_0_display_aspect_ratio #"4:3"
  ffprobe_frame_rate="$(echo "scale=0; $streams_stream_0_r_frame_rate*1" | bc )"
  ffprobe_frames=$streams_stream_0_nb_read_packets
  ffprobe_duration=$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "${ffmpeg_i[@]}")
  dynamicRange="in SDR"
  if [[ $ffprobe_color_primaries == *"2020"* ]] && [[ $ffprobe_color_space == *"2020"* ]] && ( [[ $ffprobe_color_transfer != *"709"* ]] || [[ $ffprobe_color_transfer == *"601"* ]] ); then 
    dynamicRange="in HDR"
  fi
  classificationLetter=( $(shuf -e 'G' 'PG' 'PG-13' 'R' 'G' 'NR' 'PG-13' 'PG'))
  echo -e "${RED}METADATA    :${NC} $ffprobe_width"w×"$ffprobe_height"h" $ffprobe_aspect_ratio-$ffprobe_codec_name-$ffprobe_duration"secs w/$ffprobe_frames frames @$ffprobe_frame_rate"fps $dynamicRange. Not $classificationLetter"
  #File Profile End

  #Begin Coordinating Color Palette for use in Logo and Poster(s)
  colorPalette=( $(shuf -e '11235A|596FB7|C6CF9B|F6ECA9|596FB7|DarkBlue,Blue,LightGreen,LightYellow. 11235a596fb7c6cf9bf6eca9' \
                           '240750|344C64|577B8D|57A6A1|344C64|Cold:DarkBlue,Teal. 240750344c64577b8d57a6a1'\
                           '7C00FE|F9E400|FFAF00|F5004F|F9E400|Blue,Yellow,Orange,Red. 7c00fef9e400ffaf00f5004f' \
                           'B1D690|FEEC37|FFA24C|FF77B7|FEEC37|LightGreen,Yellow,Orange,Pink,Yellow. b1d690feec37ffa24cff77b7' \
                           '3B1E54|9B7EBD|D4BEE4|EEEEEE|9B7EBD|DarkPurple,Purple,Violet,LightGrey,DarkPurple. 3b1e549b7ebdd4bee4eeeeee' ) )
  IFS="|" read -r color1 color2 color3 color4 color5 paletteDescription  <<< "$colorPalette"
  #Coordinating Color Palette End

  #Logo Image Begin
  if [[ ! "${typed_arguments,,}" == *"-nologo"* ]] || [[ ! "${typed_arguments,,}" == *"-noposter"* ]] ; then
    ProcedureEchoFeedback 'LOGO_WORK' "Designing a unique logo with a color palette ($color1)($color2)($color3)($color4)($color5)($paletteDescription)... \n"
    ProcedureFilenameToLinesArray "${base_name[@]}"

    if [ ! -f  "${f%.*}/_temp" ]; then mkdir -p "${f%.*}/_temp"; fi
    _temp="${f%.*}/_temp";
    placeholderImage="$_temp/_temp310x202.png"
    ffmpeg -f lavfi -i "color=c=0xffffff@0x00:s=310x202:duration=1,format=rgba" "$placeholderImage" -y -loglevel panic    

    #Hint: ('RelativeSize-SML#AllCaps?' 'Fontname'   'charCount|fontSize|pixelHeight' )
    dataset00=('S#'  'Oswald'         '0|0|0' '1|80|82'  '2|80|82' '3|74|76' '4|74|76' '5|60|62'  '6|60|62'  '7|64|64' '8|58|60' '9|58|62' '10|58|62' '11|60|62' '12|58|62' '13|52|54' '14|50|50' '15|48|50' '16|44|48' '17|28|37' '18|28|37' '19|28|37' '20|30|37')
    dataset01=('L#'  'MouseMemoirs'   '0|0|0' '1|78|68'  '2|78|68' '3|78|68' '4|78|68' '5|78|68'  '6|88|84'  '7|86|82' '8|64|62' '9|68|68' '10|70|64' '11|72|72' '12|72|70' '13|70|68' '14|68|64' '15|64|62' '16|58|50' '17|58|50' '18|54|50' '19|50|48' '20|42|42')
    dataset02=('L#'  'Ranchers'       '0|0|0' '1|78|68'  '2|78|68' '3|74|68' '4|64|68' '5|64|68'  '6|58|60'  '7|58|60' '8|54|60' '9|58|64' '10|48|50' '11|46|50' '12|48|50' '13|46|50' '14|46|50' '15|44|48' '16|36|42' '17|38|42' '18|36|40' '19|32|38' '20|32|38')
    dataset03=('L#'  'Jersey 25'      '0|0|0' '1|102|68' '2|98|68' '3|94|68' '4|90|68' '5|140|68' '6|90|68'  '7|88|68' '8|86|68' '9|82|68' '10|74|68' '11|64|50' '12|56|46' '13|54|42' '14|52|44' '15|50|44' '16|46|40' '17|40|38' '18|38|34' '19|34|33' '20|34|33')
    dataset04=('M#'  'Darumadrop One' '0|0|0' '1|104|68' '2|98|68' '3|96|68' '4|92|68' '5|100|68' '6|100|68' '7|78|50' '8|74|50' '9|70|50' '10|62|50' '11|58|50' '12|50|48' '13|44|38' '14|44|42' '15|44|40' '16|38|38' '17|36|34' '18|34|30' '19|30|28' '20|30|28')
    dataset05=('S#'  'Archivo Black'  '0|0|0' '1|90|68'  '2|88|68' '3|84|68' '4|84|68' '5|84|68'  '6|80|68'  '7|64|50' '8|64|50' '9|64|50' '10|50|50' '11|46|48' '12|40|44' '13|36|36' '14|34|34' '15|34|36' '16|32|32' '17|30|28' '18|28|26' '19|26|26' '20|22|24')
    dataset06=('M#'  'Slackey'        '0|0|0' '1|80|68'  '2|86|68' '3|84|68' '4|80|68' '5|80|68'  '6|68|68'  '7|62|68' '8|52|50' '9|50|48' '10|42|42' '11|44|48' '12|40|46' '13|32|30' '14|32|34' '15|30|28' '16|28|28' '17|30|28' '18|28|28' '19|26|28' '20|22|26')
    dataset07=('S#'  'Chewy'          '0|0|0' '1|84|68'  '2|84|68' '3|82|68' '4|84|68' '5|82|68'  '6|68|50'  '7|60|50' '8|58|50' '9|60|50' '10|60|50' '11|60|50' '12|58|50' '13|48|50' '14|46|50' '15|44|50' '16|40|46' '17|28|36' '18|30|36' '19|30|36' '20|30|36')
    dataset50=('S#C' 'Bungee'         '0|0|0' '1|90|68'  '2|88|68' '3|86|68' '4|88|68' '5|84|68'  '6|68|68'  '7|60|48' '8|54|46' '9|48|40' '10|46|40' '11|42|36' '12|38|34' '13|36|36' '14|32|28' '15|32|32' '16|30|32' '17|28|32' '18|28|30' '19|22|24' '20|22|24')
    dataset51=('M#C' 'pixeldead'      '0|0|0' '1|88|68'  '2|88|68' '3|88|68' '4|88|68' '5|88|68'  '6|82|78'  '7|72|58' '8|62|50' '9|60|50' '10|56|50' '11|48|42' '12|44|42' '13|42|38' '14|38|36' '15|36|36' '16|34|32' '17|36|36' '18|34|34' '19|30|30' '20|26|26')
    dataset52=('X#C' 'Nosifer'        '0|0|0' '1|90|68'  '2|86|68' '3|88|68' '4|86|68' '5|54|50'  '6|52|50'  '7|46|50' '8|48|46' '9|38|40' '10|34|36' '11|32|32' '12|28|34' '13|28|32' '14|26|26' '15|24|26' '16|22|24' '17|22|24' '18|22|24' '19|20|22' '20|16|20')
    dataset53=('M#C' 'arco'           '0|0|0' '1|86|68'  '2|86|68' '3|84|68' '4|82|68' '5|80|66'  '6|70|50'  '7|54|50' '8|52|48' '9|50|46' '10|42|38' '11|40|36' '12|36|34' '13|34|32' '14|30|26' '15|30|26' '16|28|26' '17|30|26' '18|28|26' '19|26|26' '20|24|26')
    dataset54=('M#C' 'Sigmar One'     '0|0|0' '1|84|68'  '2|84|68' '3|84|68' '4|84|68' '5|84|68'  '6|68|50'  '7|54|48' '8|52|46' '9|48|40' '10|44|38' '11|42|38' '12|38|36' '13|32|30' '14|30|28' '15|30|28' '16|28|28' '17|30|28' '18|28|28' '19|24|24' '20|22|20')
    dataset55=('M#C' 'Trade Winds'    '0|0|0' '1|82|68'  '2|80|68' '3|80|68' '4|82|68' '5|76|68'  '6|72|68'  '7|62|64' '8|60|50' '9|58|50' '10|54|50' '11|48|48' '12|44|46' '13|38|44' '14|38|40' '15|36|36' '16|34|34' '17|32|36' '18|30|30' '19|28|28' '20|26|26')

    justification=( $(shuf -e "1" "(w-text_w)/2" ) )
    flag_fontSet=0  
    for (( i=0; i < ${#lines_array[@]}; i++ )); do
      if [ $i -eq 0 ]; then  #AllCaps fonts
        datasetCollection=( $(shuf -e "dataset50" "dataset51" "dataset52" "dataset53" "dataset54" "dataset55" ) );
        for sets in "${datasetCollection[0]}"; do declare -n fontData="$sets"; done
        fontColor=$color2; fontBorderColor=$color3
        flag_fontSet=( $(shuf -e 0 0 0 0 1 1) )
      fi

      if [ $flag_fontSet -eq 0 ] && [ $i -gt 0 ]; then
        datasetCollection=( $(shuf -e "dataset00" "dataset01" "dataset02" "dataset03" "dataset04" "dataset05" "dataset06" "dataset07" ) )
        for sets in "${datasetCollection[1]}"; do declare -n fontData="$sets"; done
        fontColor=$color3; fontBorderColor=$color4
        flag_fontSet=( $(shuf -e 0 1 1 1) )
      fi 

      if [[ ${#lines_array[$i]} -gt 20 ]]; then  #the film title exceeds 20 char lenght.
        IFS="|" read -r charCount fontSize pixelHeight <<< "${fontData[22]}"; 
      else  #Grabs dataset values based on char lenght. Example dataset00 w/7 chars: ${fontData[7+2]}='7|86|82' --> 'charCount fontSize pixelHeight'
        IFS="|" read -r charCount fontSize pixelHeight <<< "${fontData[ $(( ${#lines_array[$i]} + 2 )) ]}"  
      fi
      fontName=${fontData[1]}

      case $i in
        0)  y_offset=1 ;; 
        1)  y_offset=68 ;;
        2)  y_offset=118 ;; #(118=68px + 50px)      
        3)  y_offset=168    #(168=68px + 50px + 50px , 37px left for Height)
            elementAt=23    #(the last dataset element.  Example '20|24|22')
            if [ $charCount -le 18 ]; then 
              while [ $elementAt -gt 3 ]; do
                IFS="|" read -r charCountDismissedHere fontSize pixelHeight <<< "${fontData[ ${elementAt} ]}"
                if [[ $pixelHeight -gt 35 ]] && [[ $pixelHeight -lt 41 ]]; then elementAt=0 ;fi 
                let elementAt--
              done              
            fi 
            if [[ ${#lines_array[$i]} -gt 20 ]]; then justification="1"; fi ;; 
      esac

echo "\$i=$i,  fontName="$fontName",    fontData="$charCount"|"$fontSize"|"$pixelHeight",            ["${lines_array[$i]}"]"   #4Debug
            
      ffmpeg -i "$placeholderImage" \
             -filter_complex "[0:0]crop=2:2:in_w:in_h[img];color=c=0xffffff@0x00:s=310x202,format=rgba \
                             ,drawtext=text='${lines_array[$i]}':fontfile=$fontName:fontcolor=$fontColor:fontsize=$fontSize:bordercolor=$fontBorderColor:borderw=1:shadowx=3:shadowy=3:x=$justification:y=$y_offset[bg]; \
                             [bg][img]overlay=0:0:format=rgb,format=rgba[out]" \
             -map [out] -c:v png -frames:v 1 \
             "$_temp/_tempClearlogo$i.png" -y -loglevel error   
    done
    ffmpeg_filter_complex="[1]scale=-1:-1[b];[0:v][b] overlay"
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
    ProcedureEchoFeedback 'LOGO_DONE'
  fi
  #End Logo Image

  #Poster Images Begin
  if [[ ! "${typed_arguments,,}" == *"-noposter"* ]]; then
    ProcedureEchoFeedback 'POSTER_START' 'Working on posters'
    if [ ! -f  "${f%.*}/_temp" ]; then mkdir -p "${f%.*}/_temp"; fi
    _temp="${f%.*}/_temp";

    idx=( $(shuf -e $(seq 0 $(bc <<<"${#TEASERS[@]} - 1") ) ) ); 
    teaser=${TEASERS[$idx]}
    fontNameInHDR='SigmarOne-Regular'
    colorPosterBg=$color1
    colorTextInHDR=$color1

    inHDR_overlay=""
    if [[ $dynamicRange == *"HDR"* ]]; then
      inHDR_overlay=",drawbox=x=0:y=(ih/1.96):w=(iw*0.29):h=(ih*0.062):color=white@0.5:thickness=fill, \
                      drawtext=text='in HDR!':fontcolor=$GUI_ACCENTCOLOR1:fontfile='$fontNameInHDR':x=(w*0.02):y=(h/1.9):fontsize=(h*0.035):bordercolor='$GUI_ACCENTCOLOR2':borderw=6"
    fi
    ffmpeg_roundcorner="format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${poster_radius})*gt(abs(H/2-Y),H/2-${poster_radius}),if(lte(hypot(${poster_radius}-(W/2-abs(W/2-X)),${poster_radius}-(H/2-abs(H/2-Y))),${poster_radius}),255,0),255)'"

    if [[ $ffprobe_height -ge 1080 ]]; then
      logo_design=( $(shuf -e '1080p-design1' '1080p-design2') ); 
    elif [[ $ffprobe_height -gt 720 ]] && [[ $ffprobe_height -le 1079 ]]; then
      logo_design=( $(shuf -e '1080p-design1' '1080p-design2' '1079p') )
    else
      logo_design='1079p'
    fi
    case $logo_design in
    '1080p-design1')
      dataset0=('x=20:y=25:w=680:h=50'   'Oswald' 'x=(w-text_w)/2:y=35:fontsize=h/28'   '55:680' )  #teasertop-clearlogobottom-->(drawbox:y:h, fontname, positionx:y:fontsize, clearlogoposx:y)
      dataset1=('x=20:y=970:w=680:h=50'  'Oswald' 'x=(w-text_w)/2:y=980:fontsize=h/28'  '55:0'   )  #teaserbottom-clearlogotop
      dataset2=('x=20:y=1020:w=680:h=50' 'Oswald' 'x=(w-text_w)/2:y=1030:fontsize=h/28' '55:620' )  #clearlogo&teaser-bottom
      datasetCollection=( $(shuf -e "dataset0" "dataset1" "dataset2" ) ) 
      declare -n teaserData="$datasetCollection"
      teaser_overlay=",drawbox=${teaserData[0]}:color='$colorPosterBg'@1:thickness=fill,drawtext=text='$teaser':fontcolor='$GUI_ACCENTCOLOR1':fontfile=${teaserData[1]}:${teaserData[2]}:bordercolor='$GUI_ACCENTCOLOR2':borderw=2"
		
      for ((n=1; n<=$MAX_POSTERS; n++)); do
        ProcedureEchoFeedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
        ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.10" | bc)";  
        if [ $(echo "scale=2; $ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi #leading zero for _ssAt less than 1.00
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -filter_complex "crop=in_w/2:in_h,eq=brightness=0.2,$ffmpeg_roundcorner$teaser_overlay" \
               -frames:v 1 -q:v 2 \
               "$_temp/_temp$n.png" -y -loglevel error
        ffmpeg -i "$_temp/_temp$n.png" -i "${f%.*}/Clearlogo.png" \
               -filter_complex "[1]scale=-1:404[logo]; [0][logo]overlay=${teaserData[3]}$inHDR_overlay" \
               -q:v 2 \
               "$_temp/poster$n.png" -y -loglevel error
        rm -f "$_temp/_temp$n.png"
      done ;;
    '1080p-design2')
      teaser_overlay=",drawtext=text='$teaser':fontcolor='$GUI_ACCENTCOLOR1':fontfile='Oswald':x=(w-text_w)/2:y=1035:fontsize=h/28:bordercolor='$GUI_ACCENTCOLOR2':borderw=2"
      ffmpeg -f lavfi -i color=c=0x$colorPosterBg:duration=1:s=720x1080:r=1 \
             "$_temp/_tempbase.mp4" -y -loglevel error
      ffmpeg -ss 0 -i "$_temp/_tempbase.mp4" \
             -filter_complex "$ffmpeg_roundcorner$teaser_overlay" \
             -frames:v 1 -q:v 1 \
             "$_temp/_temproundteaser.png" -y -loglevel error; 
      rm -f "$_temp/_tempbase.mp4"
      for ((n=1; n<=$MAX_POSTERS; n++)); do
        ProcedureEchoFeedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
        ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.1" | bc)";  
		    if [ $(echo "scale=2;$ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -frames:v 1 -q:v 2 \
               "$_temp/_temp$n.png" -y -loglevel error
        ffmpeg -i "$_temp/_temproundteaser.png" -i "$_temp/_temp$n.png" -i "${f%.*}/Clearlogo.png" \
               -filter_complex "[1]scale=-1:660,eq=brightness=0.2:contrast=1:saturation=1.5,crop=740:660:160:(in_h)[still]; \
                                [2]scale=-1:404[logo]; \
                                [0][still]overlay=-1:360[partial]; \
                                [partial][logo]overlay=55:10$inHDR_overlay" -q:v 1 \
               "$_temp/poster$n.png" -y -loglevel error
        rm -f "$_temp/_temp$n.png"
      done ;;      
    '1079p') 
      dataset0=('55' 'Oswald' 'x=(w-text_w)/2:y=10:fontsize=h/28'   '55:680' )  #teasertop-clearlogobottom-->('n/a', fontname, positionx:y:fontsize, clearlogoposx:y)
      dataset1=('40' 'Oswald' 'x=(w-text_w)/2:y=1035:fontsize=h/28' '55:0'   )  #clearlogotop-teaserbottom
      dataset2=('40' 'Oswald' 'x=(w-text_w)/2:y=1035:fontsize=h/28' '55:620' )  #clearlogo&teaser-bottom
      datasetCollection=( $(shuf -e "dataset0" "dataset1" "dataset2" ) ) 
      declare -n teaserData="$datasetCollection"                                #for debug: teaserData=("${dataset2[@]}")
      teaser_overlay=",drawtext=text='$teaser':fontcolor='$GUI_ACCENTCOLOR1':fontfile=${teaserData[1]}:${teaserData[2]}:bordercolor='$GUI_ACCENTCOLOR2':borderw=2"

      ffmpeg -f lavfi -i color=c=0x$colorPosterBg:duration=1:s=720x1080:r=1 \
             "$_temp/_tempbase.mp4" -y -loglevel error
      ffmpeg -ss 0 -i "$_temp/_tempbase.mp4" \
             -filter_complex "$ffmpeg_roundcorner$teaser_overlay" \
             -frames:v 1 -q:v 1 \
             "$_temp/_temproundteaser.png" -y -loglevel error; 
      rm -f "$_temp/_tempbase.mp4"

      for ((n=1; n<=$MAX_POSTERS; n++)); do
        ProcedureEchoFeedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
        ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.1" | bc)"
		    if [ $(echo "scale=2;$ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -frames:v 1 -q:v 2 \
               "$_temp/_temp$n.png" -y -loglevel error
        ffmpeg -i "$_temp/_temproundteaser.png" -i "$_temp/_temp$n.png" -i "${f%.*}/Clearlogo.png" \
               -filter_complex "[1]scale=-1:970,eq=brightness=0.2:contrast=1:saturation=1.5,crop=720:970:160:in_h,drawbox=x=0:y=0:w=720:h=990:color=$colorPosterBg@1:t=20[still]; \
                                [2]scale=-1:404[logo]; \
                                [0][still]overlay=0:${teaserData[0]}[partial]; \
                                [partial][logo]overlay=${teaserData[3]}$inHDR_overlay" -q:v 1 \
               "$_temp/poster$n.png" -y -loglevel error
		    rm -f "$_temp/_temp$n.png"
      done
      rm -f "$_temp/_temproundteaser.png" ;;
    esac
    pick_a_poster=$((2 % $MAX_POSTERS))
    mv "$_temp/poster$(echo "$pick_a_poster + 1" | bc).png" "${f%.*}/Poster.png"    
    ProcedureEchoFeedback 'POSTER_DONE' $n
	fi
  #End Poster Images


  #Background/Backdrop Images Begin
  if [[ ! "${typed_arguments,,}" == *"-noback"* ]]; then
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
    for ((n=1; n<=$MAX_BACKDROPS; n++)); do
      ProcedureEchoFeedback 'BACKGROUND_WORK' 'Working on background image' $n $MAX_BACKDROPS
      ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_BACKDROPS*$n)-0.1" | bc)";  if [ $(bc <<< "$ffmpeg_ssAt < 1.00") -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
      ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 2 -loglevel error "${f%.*}/backdrop$n.jpg" -y
    done
    ProcedureEchoFeedback 'BACKGROUND_DONE' $n
  fi
  #End Background Images

  #Begin Metadata
  if [[ ! "${typed_arguments,,}" == *"-nometa"* ]]; then 
    ProcedureEchoFeedback 'METAFILE_WORK' 'Now the editable metadata file...'
    #echo -e -n "${RED}METAFILE    :${NC} Now the editable metadata file..."

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
      echo -n ". Retrieving random plots from IMDB. This takes no more than a minute. "
      sleep 45 #secs. required to complete the xidel download
    fi
    if [ -f "$1/plots.txt" ]; then readarray -t PLOTS < "$1/plots.txt"; else PLOTS=($default_plot); fi
    rating=( $(shuf -e 7 8 9 10) )
    decade=( $(shuf -e 1980 1990 2000 2010 2020) ) 
    digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )
    if [ $COUNTER -eq 1 ]; then #do  random shuffle only one time
      plot=( $(shuf -e $(seq 0 $(bc <<<"${#PLOTS[@]} - 1") ) ) )  
      actor=( $(shuf -e $(seq 0 $(bc <<<"${#ACTORS[@]} - 1") ) ) )
      role=( $(shuf -e $(seq 0 $(bc <<<"${#ROLES[@]} - 1") ) ) ) 
      director=( $(shuf -e $(seq 0 $(bc <<<"${#DIRECTORS[@]} - 1") ) ) )
      genre=( $(shuf -e $(seq 0 $(bc <<<"${#GENRES[@]} - 1") ) ) )
      studio=( $(shuf -e $(seq 0 $(bc <<<"${#STUDIOS[@]} - 1") ) ) )
      tag=( $(shuf -e $(seq 0 $(bc <<<"${#SEARCH_TAGS[@]} - 1") ) ) )
      trailer=( $(shuf -e $(seq 0 $(bc <<<"${#TRAILER_IDS[@]} - 1") ) ) )
    fi
    if [[ ! "${typed_arguments,,}" == *"-notrailer"* ]]; then
      trailer_elementDisabledOpen="<!--Disabled  "
      trailer_elementDisabledClose="  Disabled-->"
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
  <plot>${PLOTS[${plot[$COUNTER]}]}
  </plot>
  <actor>
    <name>${ACTORS[${actor[$(bc <<<"2*$COUNTER-1")]}]}</name>
    <role>${ROLES[${role[$(bc <<<"2*$COUNTER")]}]}</role>
  </actor>
  <actor>
    <name>${ACTORS[${actor[$(bc <<<"2*$COUNTER-2")]}]}</name>
    <role>${ROLES[${role[$(bc <<<"2*$COUNTER")]}]}</role>
  </actor>
  <director>${DIRECTORS[${director[$COUNTER]}]}</director>
  <genre>${GENRES[${genre[$COUNTER]}]}</genre>
  <genre>${GENRES[${genre[$COUNTER+2]}]}</genre>
  <studio>${STUDIOS[${studio[$COUNTER]}]}</studio>
  <tag>${SEARCH_TAGS[${tag[$COUNTER]}]}</tag>
  <tag>${SEARCH_TAGS[${tag[$COUNTER+1]}]}</tag>
  $trailer_elementDisabledOpen<trailer>plugin://plugin.video.youtube/?action=play_video&amp;videoid=${TRAILER_IDS[${trailer[$COUNTER]}]}</trailer>$trailer_elementDisabledClose
</movie>" > "${f%.*}/${base_name[@]}"'.nfo'
    ProcedureEchoFeedback 'METAFILE_DONE'
  fi
  #End Metadata


  #Movie Trailer Begin
  if [[ ! "${typed_arguments,,}" == *"-notrailer"* ]]; then
    MAX_TRAILER_CLIPS=3;
    CLIP_DURATIONSECS="3.00"
    CLIP_SPANSECS="5.00"

    ProcedureEchoFeedback 'TRAILER' 'Generating a random rate screen for this film...'
    RATE_TITLE=('THE FOLLOWING FEATURE HAS NOT BEEN RATED' 'THIS PREVIEW HAS NOT BEEN RATED' 'THIS MOTION FILM NAS NOT BEEN RATED')
    idx=( $(shuf -e $(seq 0 $(bc <<<"${#RATE_TITLE[@]}-1") ) ) )
    rate_title=${RATE_TITLE[$idx]}

    dataset1=( $(shuf -e 'Because Some Material|May Be Insanely Memorable|For Unprepared Viewers|' \
                         'Due to Over-emotional,|Intense, Undisturbing|Graphic Material|' \
                         'For Fool Scences,|Mild Appropiate Dialogs,|and Goofy Language|' \
                         'For Inoffensive Scenes|Fool and Goofy|Mild Expressions|' \
                         'Due to Implicit Content|Showing Scences Full Of|Memory and Happiness|') )
    IFS="|" read -r rateLine1 rateLine2 rateLine3 foo_unused_but_required_as_stopper_due_to_wspaces <<< "${dataset1[@]}"

    case $classificationLetter in
      'G'    ) dataset2=('green|w*0.251|h*0.194|0.15|black|white|General Audiences Admitted|white|') ;;
      'PG'   ) dataset2=('maroon|w*0.236|h*0.213|0.10|red|yellow|Family Guidance Suggested|yellow|') ;;
      'PG-13') dataset2=('purple|w*0.218|h*0.241|0.06|11235A|F6ECA9|Unrestricted Under 13|F6ECA9|') ;;
      'R'    ) dataset2=('darkblue|w*0.251|h*0.194|0.15|black|white|Restricted Audiences|white|') ;;
      'NR'   ) dataset2=('black|w*0.236|h*0.213|0.10|white|maroon|Content Has Not Been Rated|white|') ;;
    esac
    IFS="|" read -r screenColor letterX letterY letterFontSize letterBgColor letterTextColor classificationLineText classificationLineTextColor foo_unused_but_required_as_stopper_due_to_wspaces <<< "${dataset2[@]}"      
    
    _temp="${f%.*}/_temp"
    if [ ! -f "logo-mpaa.png" ]; then
      output_file="logo-mpaa.png"
      source_url='https://atlascinemas.net/images/rating-mpaa.png'  #338x143 --> scale ih*1.1
      curl -o "$output_file" $source_url -s
    fi
    melodyIndex=( $(shuf -e 4 3 2 1) )    
    if [ ! -f "AccentMelody$melodyIndex.mp3" ]; then
      output_file="AccentMelody$melodyIndex.mp3"
      source_url='https://filesamples.com/samples/audio/mp3/sample'$melodyIndex'.mp3'  
      curl -o "$output_file" $source_url -s 
    fi
    
    rateScreenFontName="ArchivoBlack-Regular"
    classificationFontName="SigmarOne-Regular"      
    rateTextBorder='bordercolor=black:borderw=1:shadowx=3:shadowy=3'
    if [ $(echo "$ffprobe_height <= 1080" | bc ) ]; then logoScale=0.8; else logoScale=3.1; fi
    ffmpeg -f lavfi -i color=c=$screenColor@0.8:duration=$CLIP_DURATIONSECS:s=$ffprobe_width"x"$ffprobe_height:r=$ffprobe_frame_rate -i logo-mpaa.png -f lavfi -t $CLIP_DURATIONSECS -i anullsrc \
           -filter_complex "[1:v]scale=-1:(ih*$logoScale)[ratelogo], \
                            [0:v][ratelogo]overlay=x=(main_w-overlay_w)/2:y=(main_h*0.66), \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.208):h=(ih*0.210):color='$letterBgColor'@1:thickness=fill:enable='between(t,0,$CLIP_DURATIONSECS)', \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.32):color='white'@1:t=10:enable='between(t,0,$CLIP_DURATIONSECS)', \
                            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.210):color='white'@1:t=5:enable='between(t,0,$CLIP_DURATIONSECS)', \
                            drawtext=text='$rate_title':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.10):fontsize=(w*0.030):$rateTextBorder, \
                            drawtext=text='$classificationLetter':fontcolor='$letterTextColor':fontfile='$classificationFontName':x=$letterX:y=$letterY:fontsize=(w*$letterFontSize):$rateTextBorder, \
                            drawtext=text='$(echo -e $rateLine1"\n"$rateLine2"\n"$rateLine3)':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.438):y=(h*0.210+8):fontsize=(w*0.022):$rateTextBorder, \
                            drawtext=text='$classificationLineText':fontcolor='$classificationLineTextColor':fontfile='$classificationFontName':x=(w-text_w)/2:y=(h*0.40):fontsize=(w*0.03):$rateTextBorder, \
                            drawtext=text='BY THE':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.55):fontsize=(w*0.025):$rateTextBorder, \
                            drawtext=text='CLASSIFICATION AND RATING ADMINISTRATION':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.60):fontsize=(w*0.025):$rateTextBorder, \
                            drawtext=text='MOTION PICTURE ASSOCIATION OF AMERICA':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w-text_w)/2:y=(h*0.85):fontsize=(w*0.012):$rateTextBorder, \
                            drawtext=text='www.popcornratings.corn':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.07):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
                            drawtext=text='www.freefamily.films':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.76):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
                            drawtext=text='®':fontcolor=f2f2f2@0.9:fontfile='$rateScreenFontName':x=(w*0.83):y=(h*0.45):fontsize=(w*0.035):$rateTextBorder,fade=t=in:st=0:d=0.2" \
          "$_temp/_tempRating.mp4" -y -loglevel error
    rm -f "$_temp/_tempClips.txt"
    echo "file '_tempRating.mp4'" >> "$_temp/_tempClips.txt"

    ffmpeg -f lavfi -i color=c=$color1@1:duration=$CLIP_DURATIONSECS:s=$ffprobe_width"x"$ffprobe_height:r=$ffprobe_frame_rate -i "${f%.*}/Clearlogo.png" -f lavfi -t $CLIP_DURATIONSECS -i anullsrc \
           -filter_complex "[1:v]scale=620:404[clearlogo],\
                            [0:v][clearlogo]overlay=x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2-60,\
                            drawbox=x=0:y=(ih-60):w=$ffprobe_width:h=60:color=$color1@1:thickness=fill:enable='between(t,0,$CLIP_DURATIONSECS)', \
                            drawtext=text='$teaser ($dynamicRange)':fontcolor='$color3':fontfile='$rateScreenFontName':bordercolor=$color4:borderw=1:x=(w-text_w)/2:y=(h-50):fontsize=30" \
          "$_temp/_tempLogo.mp4" -y -loglevel error
    echo "file '_tempLogo.mp4'" >> "$_temp/_tempClips.txt"
  
    for ((n=1; n<=$MAX_TRAILER_CLIPS; n++)); do
      ProcedureEchoFeedback "TRAILERS" $n $MAX_TRAILER_CLIPS
      ffmpeg_ssAt=$(echo "scale=2;($ffprobe_duration/$MAX_TRAILER_CLIPS*$n)-($CLIP_SPANSECS - 1.00)" | bc);  #formula to calculate where the $MAX_TRAILER_CLIPS clips starts within the total length of video (w/1 second pad)
      ffmpeg_ssTo=$(echo "scale=2;($ffmpeg_ssAt + $CLIP_SPANSECS)" | bc);  
      if [ $(echo "scale=2;$ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi	#Add a zero, in case the first(s) clip start less than 1 second.
      if [ $(echo "scale=2;$ffmpeg_ssTo < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssTo='0'$ffmpeg_ssTo; fi

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
    ProcedureEchoFeedback 'TRAILER' "Merging ${YELLOW}$n${NC} clips"
    ffmpeg -f concat -safe 0 -i "$_temp/_tempClips.txt" -c copy "$_temp/_temptrailer_nobackmusic.mp4" -y -loglevel error

    ProcedureEchoFeedback 'TRAILER' 'Finalizing trailer may take a while...'
    delayms=$(echo "$CLIP_DURATIONSECS*1000 + 1000" | bc)
    ffmpeg -i "$_temp/_temptrailer_nobackmusic.mp4" -i "AccentMelody$melodyIndex.mp3" \
           -filter_complex "[1:a] adelay=$delayms|$delayms,volume=0.15,apad[music]; \
                            [0:a][music]amerge[out]" \
           -c:v copy -map 0:v -map "[out]" \
           "${f%.*}/${base_name[@]}-trailer.mp4" -y -loglevel panic
    mv "$_temp/_tempRating.mp4" "${f%.*}/${base_name[@]}-rating.mp4"
    rm -f -- "$_temp"/_temp*.*    
    ProcedureEchoFeedback "TRAILER_DONE"

  fi
  #End Movie Trailer

  #Background Audio Begin
  if [[ ! "${typed_arguments,,}" == *"-nomusic"* ]] && [ $COUNTER -lt 6 ]; then
    ProcedureEchoFeedback 'THEME_WORK' ' Creating theme song (limited to 5)...'
    output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/theme.mp3"  
    source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'  
    curl -o "$output_file" $source_url -s      
    ProcedureEchoFeedback 'THEME_DONE'
  else
    echo -e "${RED}THEME AUDIO :${NC} ...${RED}SKIPPED!${NC}"  
  fi
  #End Background Audio

  if [ -z "$( ls -A "${f%.*}/_temp" )" ]; then  #_temp directory is empty
    rm -Rf "${f%.*}/_temp"
  fi

  echo  
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
#Inspiration: AskUbuntu-Iterate over files in directory, create folders based on file names and move files into respective folders
