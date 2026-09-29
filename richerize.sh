#!/bin/bash
#REM LAST EDITED CALI MAY 1ST 2025.  TODO: AtMoment... replace character with another character in string
MAX_POSTERS=3
MAX_BACKDROPS=2
INHDR_TEXT='In  HDR!'
MELODY_LIST_DOWNLOAD_FILEID="1AugOZWcL9ZAfNPpeT5O6SPfQJCBTmaSR"
METAINFO_LIST_DOWNLOAD_FILEID="1d6wBrb2Z7L4duCd_aMcN3VMTHQC-g5iE"
WORKART_LIST_DOWNLOAD_FILEID="TODO"
THEME_LIST_DOWNLOAD_FILEID="TODO"
#A Message for the end-user: Do not modify below this script line


#Functions Begin
function fn_chronometer() {
    local chronometerName=$1
    local prompt=$2
    if [[ $prompt == *"START"* ]] || [[ $prompt == *"RESET"* ]]; then 
      startTime=$(date +%s)
      chronometer_array["$chronometerName"]=$startTime
      return 0; 
    fi
    local nowTime=$(($(date +%s)))    
    chronStart=${chronometer_array["$chronometerName"]}
    local elapsedSecs=$(($nowTime-$chronStart ))
    local hours=$((elapsedSecs / 3600))
    local minutes=$(((elapsedSecs % 3600) / 60))
    local seconds=$((elapsedSecs % 60))
    if [[ $prompt == *"STOP"* ]]; then 
      chronometer_array["$chronometerName"]=$nowTime
      prompt=" spent"
    fi
    if (( $hours == 0 )) && (( $minutes == 0 )); then
      printf "(%2ds$prompt)" $seconds
    elif (( $hours == 0 )); then
      printf "(%02dm:%02ds$prompt)" $minutes $seconds
    else
       printf "(%02d:%02d:%02d$prompt)" $hours $minutes $seconds
    fi
}

function fn_repeat_char() {
  local char=$1;   local lenght=$2;  local result=""
  for ((i=0; i<lenght; i++)); do result+=$char; done
  echo "$result"
}

function string_pad_function() { 
  [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"; 
}

function echo_feedback_function() {
  case $1 in
    'COPY_MOVE'      ) echo -ne "${RED}$2${NC} $3   \n"; return 1 ;;
  esac
  echo -ne "\033[0K\r"
  case $1 in
    'GROUNDWORK_MELO') echo -ne "${RED}GROUNDWORK  : ${NC}${YELLOW}$2${NC} $3\033[0K";;
    'GROUNDWORK_INFO') echo -ne "${RED}GROUNDWORK  : ${NC}$2 ${YELLOW}$3${NC} $4\033[0K";;    
    'ERROR'          ) echo -ne "${RED}ERROR       : ${NC}$2 ${YELLOW}$3${NC}\n" ;;
    'WARNING'        ) echo -ne "${YELLOW}WARNING  : ${NC}$2 ${YELLOW}$3${NC}\n" ;;
    'WORKING_ONn'    ) echo -ne "${RED}("$2"of"$3")${NC} Working on ${YELLOW}"$4${NC}"                                ..." ;;
    'POSTER_START'   ) echo -ne "${YELLOW}POSTERS     : ${NC}Working on posters...\033[0K" ;;

    'LOGO_WORK'      ) echo -ne "${YELLOW}LOGO        : ${NC}$2\033[0K" ;;
    'POSTER_WORK'    ) echo -ne "${YELLOW}POSTERS     : ${NC}$2 ${YELLOW}$3${NC} of $4...\033[0K" ;;
    'BACKGROUND_WORK') echo -ne "${YELLOW}BACKGROUNDS : ${NC}$2 ${YELLOW}$3${NC} of $4...\033[0K" ;;
    'METAINFO_WORK'  ) echo -ne "${YELLOW}METAINFO    : ${NC}$2\033[0K" ;;
    'THEME_WORK'     ) echo -ne "${YELLOW}THEME AUDIO : ${NC}$2\033[0K" ;;

    'LOGO_DONE'      ) echo -ne "${RED}LOGO        : ${NC}Logo for the film and poster created.  ${RED}DONE!${NC}\n" ;;
    'POSTER_DONE'    ) echo -ne "${RED}POSTERS     : ${YELLOW}$(echo "$n-1" | bc)${NC} image posters created. ${RED}DONE!${NC}. Other ${YELLOW}$(echo "$n-2" | bc)${NC} in ${YELLOW}/posters${NC} folder might be better.\n" ;;
    'BACKGROUND_DONE') echo -ne "${RED}BACKGROUNDS : ${YELLOW}$2${NC} background images created.  ${RED}DONE!${NC}\n" ;;
    'METAINFO_DONE'  ) echo -ne "${RED}METAINFO    : ${NC}Movie meta-info file with extension nfo sucessfully created.  ${RED}DONE!                               ${NC}\n" ;;
    'THEME_DONE'     ) echo -ne "${RED}THEME AUDIO : ${NC}Thematic background audio file sucessfully created.  ${RED}DONE!${NC}\n" ;;

    'TRAILER'        ) echo -ne "${YELLOW}$(string_pad_function $1 -12): ${NC}$(fn_chronometer "CHRON-TRAILER" ' elapsed') $2$3\033[0K" ;;
    'TRAILERn'       ) echo -ne "${YELLOW}TRAILER     : ${NC}$(fn_chronometer "CHRON-TRAILER" ' elapsed') Now, preparing trailer clip ${YELLOW}$2${NC} of $3. $4 \033[0K" ;;
    'TRAILER_DONE'   ) echo -ne "${RED}TRAILER     : ${NC}$(fn_chronometer "CHRON-TRAILER" ' STOP') Trailer clip sucessfully created. ${RED}DONE!${NC}                            \n" ;;


    'BACKGROUNDS'    ) echo -ne "${YELLOW}BACKGROUNDS : ${NC}Now, preparing background images ${YELLOW}$2${NC} of $3...\033[0K" ;;
                    *) echo -ne "${YELLOW}$(string_pad_function $1 -12): ${NC}$2$3\033[0K" ;;
  esac
}

#Returns true if the script argument to be tested is in the white-list of VALID_ARGUMENTS
function fn_is_excluded_from_script_options() {	#rename as: if fn_is_absent_from_script  recognized_args  -notrailer; then ... fi
  local -n recognized_arguments=$1
  local check_arg=$2
  if [[ ! "${recognized_arguments[@]}" == *$check_arg* ]]; then
    true
  else
    false
  fi
  #Sample implementation: 
  #if fn_is_excluded_from_script_options recognized_args -noposter; then ...code to do posters; fi
}

function generate_chapter_file_function() {
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
  ffmpeg -i "$1" -loglevel error -f ffmetadata -i "${ffmpeg_chapter_file[@]}" -c copy "$3" -y
    #$1 $f=    $ffmpeg_f                 #Test Video/CancunFamilyTrip.mp4
    #$2 $chapter_info                    #Test Video/CancunFamilyTrip.chapters.txt
    #$3 $film= $ffmpeg_i_with_chapters"  #Test Video/CancunFamilyTrip/CancunFamilyTrip.mp4
    #$4 $f=    ${ffmpeg_f[@]}            #Test Video/CancunFamilyTrip.mp4
}

function fn_is_chapter_film_created() {
  local -n arg1="$1"
  local rootPath=${arg1[root_path]}         #(1)
  local workPath=${arg1[work_path]}         #(2)
  local filmBasename=${arg1[film_basename]} #(3)
  local film=${arg1[full_path]}             #(4)
  local extension=${arg1[film_extension]}   #(5)
  local logsPath=${arg1[logs_path]}
  local -n arg2="$2"
  local length=${arg2[duration_sexagesimal]}            #(6)
  
  local userEntryProblems=()
  local userEntryLineNumber=0
  local userEntries="$workPath/$filmBasename.chapters.txt"
  local ffmpegEntries="$workPath/chapters.txt"
  local originalFilm="$workPath/$filmBasename.ORIGINAL.$extension"

  local text=';FFMETADATA1\n# '"$filmBasename"' chapter(s) --as ffmpeg metadata format.\n\n'  
  local rexprTxtFile="^([0-9]):([0-5][0-9]):([0-5][0-9].[0-9][0-9])[[:space:]](.*)?" #h:mm:ss.ff (Anytext)
  local rexprFfprobe="^([0-9]):([0-5][0-9]):([0-5][0-9])(.*)?"  #h:mm:ss.ff
  while IFS= read -r line; do
    if [[ "$line" =~ $rexprTxtFile ]]; then
      local title="${BASH_REMATCH[4]}"
      local timestamp=$(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc )
      local chapterLines+=("${BASH_REMATCH[1]}:${BASH_REMATCH[2]}:${BASH_REMATCH[3]} $title")
      local proTimestamp+=($timestamp)
      local proTitle+=("$title") 
    else
	  userEntryProblems+=('Problematic line#'$(printf "%02d" "$((userEntryLineNumber + 1))")': '"$line")
    fi
	 userEntryLineNumber=$((userEntryLineNumber + 1))
  done < "$userEntries"
  if [[ ${#userEntryProblems[@]} -gt 0 ]]; then  
	userEntryProblems=("ERROR(s) FOUND:" "1) Verify/fix the user created chapters text file:"  "$userEntries" " "
                     "2) Then, to have chapters in the film re-execute the script as this:" "$0 '$rootPath' -dochapter" " " 
					           "LIST OF ERRORS:"  "${userEntryProblems[@]}")
    printf "%s\n" "${userEntryProblems[@]}" > "$logsPath/.log-user-chapter.txt"
	return 1; 
  fi
  if [[ $length =~ $rexprFfprobe ]]; then
    local proTimestamp+=( $(echo "($(echo "scale=2; ${BASH_REMATCH[3]} + $(($((${BASH_REMATCH[2]} + $((${BASH_REMATCH[1]} * 60)) )) * 60))" | bc )*1000)/1" | bc ) )
  fi
  for ((i=0; i<${#proTimestamp[@]} - 1; ++i)); do
    text+="# ${chapterLines[$i]}\n[CHAPTER]\nTIMEBASE=1/1000\nSTART=${proTimestamp[$i]}\nEND=$(bc <<<"${proTimestamp[$i + 1]} - 1")\ntitle=${proTitle[$i]}\n\n"    
  done      
  printf "$text" > "$ffmpegEntries"
  mv "$film" "$originalFilm"
  ffmpeg -i "$originalFilm" -f ffmetadata -i "$ffmpegEntries" -c copy "$film" -y -loglevel error 2> "$logsPath/.log-ffmpeg-chapter.txt"
  return 0
  #(1) rootPath     =Test Video
  #(2) workPath     =Test Video/CancunFamilyTrip
  #(3) filmBasename =CancunFamilyTrip
  #(4) film         =Test Video/CancunFamilyTrip/CancunFamilyTrip.mp4
  #(5) extension     =mp4
  #(6) length         0:01:35.22
}

function rgb_to_ffmpeg_eq_function() {
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

#Returns a string of FFMPEG-color-EQ hex equivalent values from a rgb(red,green,blue) formatted input
function get_ffmpegeq_from_rgb_fn() {
  local rgbValues=$1 
  local regexParenthesis='.*?\((.+?)\)'
  local valueR=""; local valueG=""; local valueB=""; 
  local returnFfmpegEQ=""
  
  if [[ $rgbValues =~ ${regexParenthesis} ]]; then 
    rgbValues="${BASH_REMATCH[1]}"
    IFS="," read -r valueR valueG valueB <<< "${rgbValues}"
    valueR=$(printf "%.2f\n" $(echo "scale=2; $valueR/100" | bc ) )
    valueG=$(printf "%.2f\n" $(echo "scale=2; $valueG/100" | bc ) )
    valueB=$(printf "%.2f\n" $(echo "scale=2; $valueB/100" | bc ) )
    returnFfmpegEQ="eq=gamma_r=$valueR:gamma_g=$valueG:gamma_b=$valueB:gamma_weight=1"         
  else
    returnFfmpegEQ=$rgbValues; return 1
  fi
  echo $returnFfmpegEQ; return 0
  # Sample input: 'rgb(125, 28, 20)'
  # Output      : 'eq=gamma_r=1.25:gamma_g=0.28:gamma_b=0.20'
}

function get_title_from_film_basename_fn() {
  local basename="$1"
  local linesArray=(); 
  local wordsArray=()
  local  i=0; local lineCounter=0; local str=""; local enclosed="" 
  basename="${basename[@]^}"
  if [[ ! ${basename:0:19} =~ [[:space:]] ]]; then  #filename has no spaces in the first 20 chars.
    if [[ ${basename:0:19} =~ [A-Z] ]]; then        #filename has no spaces, but words can be segregated by inital capital letter
      basename=$(echo "${basename:0:19}${basename:19:${#basename}}" | sed 's/[A-Z]/ &/g')
    else                                              #filename has no spaces nor capital letter in the first 20 chars (this is worst case for title/logo design).
      lineCounter=0; length=${#basename}
      while [ $lineCounter -lt $length ] && [ $lineCounter -le 17 ]; do
        str+=${basename:$lineCounter:6}" "
        let lineCounter="$lineCounter + 6"
      done
      str+=${basename:$lineCounter:${#basename}}  #this is the 4th line which contains all remaining chars
      basename=$str
    fi
  fi
  basename=$(echo "$basename" | sed -r 's/[-_]+/ /g' )
  local regexArray=(); 
  local delimiter=""; 
  local regexExclam3='.*?,[[:blank:]](.+?)\!'; 
  local regexExclam2='.*?,(.+?)\!'; 
  local regexExclam1='(?<=).*(?=!)'; 
  local regexLatinExclam='.*?¡(.+?)!'; 
  local regexQuestion3uestion3='.*?,[[:blank:]](.+?)\?'; 
  local regexQuestion3uestion2='.*?,(.+?)\?'; 
  local regexQuestion3uestion1='(?<=).*(?=?)'; 
  local regexLatinQuestion='.*?¿(.+?)\?'; 
  local regexParenthesis='.*?\((.+?)\)'; 
  local regexBracket='.*?\[(.+?)\]'; 
  local regexSingleQuotes="'(.*?)'"; 
  if [[ $basename =~ $regexBracket ]]; then regexArray+=("]|$regexBracket|bracket"); fi
  if [[ $basename =~ $regexParenthesis ]]; then regexArray+=(")|$regexParenthesis|parenthesis"); fi
  if [[ $basename =~ $regexSingleQuotes ]]; then regexArray+=("'|$regexSingleQuotes|singlequotes"); fi
  if [[ $basename =~ $regexLatinExclam ]]; then  regexArray+=("!|$regexLatinExclam|latinexclam"); 
  elif [[ $basename =~ $regexExclam3 ]]; then regexArray+=("!|$regexExclam3|exclam3")
  elif [[ $basename =~ $regexExclam2 ]]; then regexArray+=("!|$regexExclam2|exclam2")
  elif [[ $basename =~ $regexExclam1 ]]; then regexArray+=("!|$regexExclam1|exclam1"); fi
  if [[ $basename =~ $regexLatinQuestion ]]; then  regexArray+=("?|$regexLatinQuestion|latimexclam");
  elif [[ $basename =~ $regexQuestion3uestion3 ]]; then regexArray+=("?|$regexQuestion3uestion3|question3")
  elif [[ $basename =~ $regexQuestion3uestion2 ]]; then regexArray+=("?|$regexQuestion3uestion2|question2")
  elif [[ $basename =~ $regexQuestion3uestion1 ]]; then regexArray+=("?|$regexQuestion3uestion1|question1"); fi
  for regex in "${regexArray[@]}"; do 
    IFS="|" read -r delimiter regex whendebug <<< "${regex}"
    if [[ $basename =~ $regex ]]; then #echo -n "whendebug=$whendebug "
      local enclosed="${BASH_REMATCH[1]}$delimiter"
      filler=$(seq -s■ $((20 - ${#enclosed} ))|tr -d '[:digit:]')
      basename=${basename/$enclosed/${enclosed//$' '/$'▀'}$filler} #read: on $basename, find $enclosed and replace by the filler stuff
    fi
  done
   
  #STEP 2): Regroup the words.  First 2 lines with more emphasis (less max chars=bigger fontsize)
  IFS=' ' read -ra wordsArray <<< "$basename"
  for (( i=0; i <= ${#wordsArray[@]} - 1; i++ )); do wordsArray[i]=${wordsArray[$i]//[■]/$''}; done  #; echo -n "${#wordsArray[$i]} "
  n1=${#wordsArray[i]}; n2=0; 
  if [ ${#wordsArray[i + 1]} ]; then n2=${#wordsArray[i + 1]}; fi
  n3=${#wordsArray[i+2]}; 
  n3=0;
  if [ ${#wordsArray[i + 3]} ]; then n4=${#wordsArray[i + 3]}; fi  
 
  i=0; lineCounter=0;   
  while [ $i -lt ${#wordsArray[@]} ]; do    
    if [[ $lineCounter -le 2 ]]; then 
      if [[ $(( $n1 + $n2 )) -le 9 ]]; then
          linesArray[$lineCounter]="${wordsArray[i]}"▀"${wordsArray[i + 1]}"; let i++  #these 2 words are in one line, jump to i+1
      else 
        linesArray[$lineCounter]=${wordsArray[i]}; 
      fi
      if [[ $lineCounter -ge 3 ]]; then
        if [[ $(( $n3 + $n4 )) -le 14 ]]; then
          linesArray[$lineCounter]="${wordsArray[i]}"▀"${wordsArray[i + 3]}"; let i++  #these 2 words are in one line, jump to i+1
        else 
          linesArray[$lineCounter]=${wordsArray[i]}; 
        fi
      fi
    else 
      linesArray[3]+="${wordsArray[i]}▀"; 
    fi #keep adding everything else to last line #4
    let lineCounter++; let i++
  done  #at this moment we have final linesArrays. Next step replace some fillers
  
  for (( i=0; i < ${#linesArray[@]}; i++ )); do linesArray[i]=${linesArray[$i]//[▀]/$' '}; done 
  for (( i=0; i < ${#linesArray[@]}; i++ )); do linesArray[i]=${linesArray[$i]//[:]/$'\:'}; done 
  for (( i=0; i < ${#linesArray[@]}; i++ )); do linesArray[i]="${linesArray[i]%"${linesArray[i]##*[![:space:]]}"}"; done 

  #STEP 3): Attempt to make the output lines prettier
  if [[ ${#linesArray[@]} -eq 1 ]]; then #Make ACRONYM from 3 first words
      local firstLetter=""; 
	  local removeForAcronym="[(-,[¡¿\']" 
      local =${linesArray[0]//$removeForAcronym/$''}" "${linesArray[1]//$removeForAcronym/$''}" "${linesArray[2]//$removeForAcronym/$''}
      for word in $input; do word=${word^^}; firstLetter+="${word:0:1}"; done
      for (( i=${#linesArray[@]}; i >=0 ; i-- )); do linesArray[i]=${linesArray[$i - 1]}; done 
      linesArray[0]=$firstLetter"\:"
  fi

  IFS=$'|'; local pipeDelimitedString="${linesArray[*]^}"; IFS=" " 
  printf '%s\n' "$pipeDelimitedString"
  return 0
}

#Returns a pipe-delimeted string with any palette of colors to choose from a dataset
function get_color_palette_fn() {
  local dsPaletteCollection=()
  local consistencySelection=""
  local dsColor=()
  local returnColorSet=""

  local ds300=('404040|ffffff|C0C0C0|000000|Simil|format=gray|DarkGrey,White,LightGray,Black| 404040ffffffC0C0C0000000')
  local ds301=('603F26|FFEAC5|FFDBB5|6C4E31|Simil|rgb(96, 63, 38)  |DarkBrown,LightWeath,Weath,Brown| ffeac5ffdbb56c4e31603f26')
  local ds302=('640D6B|F1EAFF|E5D4FF|DCBFFF|Simil|rgb(100, 13,107) |DarkPurple,VeryLightViolet,LightViolet,OtherViolet| f1eaffe5d4ffdcbfffd0a2f7')
  local ds303=('16423C|C4DAD2|6A9C89|E9EFEC|Simil|rgb(22, 66, 60)  |DarkGreen,LightGreen,Green,VeryLightGreen| 16423c6a9c89c4dad2e9efec')
  local ds304=('176B87|86B6F6|B4D4FF|EEF5FF|Simil|rgb(23, 107, 135)|DarkAqua,Blue,LightBlue,VeryLightBlue| eef5ffb4d4ff86b6f6176b87')
  local ds351=('6C946F|FFD35A|FFA823|DC0083|Mixed|rgb(108,148,111) |Green,Yellow,Orange,Purple| 6c946fffd35affa823dc0083')
  local ds352=('FF8000|4C1F7A|219B9D|FFF455|Mixed|rgb(255,128, 0)  |Orange,Purple,Teal,Yellow(wasLightGray)| ff80004c1f7a219b9deeeeee')
  local ds353=('57A6A1|F9E400|FFAF00|F5004F|Mixed|rgb(87,166,161)  |Teal,Yellow,Orange,Red| 7c00fef9e400ffaf00f5004f')
  local ds354=('FF77B7|B1D690|FEEC37|FFA24C|Mixed|rgb(255,119,183) |Pink,LightGreen,Yellow,Orange| b1d690feec37ffa24cff77b7')
  local ds355=('3B1E54|9B7EBD|D4BEE4|EEEEEE|Mixed|rgb(59, 30, 84)  |DarkPurple,Purple,Violet,LightGrey| 3b1e549b7ebdd4bee4eeeeee' )
  dsPaletteCollection=(  "ds355" "ds354" "ds353" "ds352" "ds351" "ds304" "ds303" "ds302" "ds301" "ds300")
  consistencySelection=( $(shuf -e "Simil" "Mixed") )
  for (( n=${#dsPaletteCollection[@]}; n > 0 ; n-- )); do
      for set in "${dsPaletteCollection[$n - 1]}"; do declare -n paletteSet="$set"; done
      if [[ "${paletteSet[0]:28:5}" =~ $consistencySelection  ]]; then dsColor+=($set); fi
  done
  dsColor=(  $(shuf -e ${dsColor[@]} ) )    
  for set in "${dsColor}"; do declare -n returnColorSet="$set"; done
  echo "${returnColorSet[0]}"
  return 0
  # Implementation: declare color_set=$(get_color_palette_fn)
  # Sample return : see element on ds301
}

# INPUT  : param $1 is an array of input values
# OUTCOME: 2 images, ClearLogo.png and ClearLogoRotated.png on movie folder
function generate_clearlogo_image_function() {
    local -n param="$1"               #option n is a reference to the global array
    local out_drawbox_logodeco_height="$2"	
    local logo_folder=${param[0]};local -n ref_movie_title=${param[1]};  local -n refLogger=${param[2]}
	
    local placeholder_image;      local -a pixel_heights=(); local -a font_datasets=(); local -a fonts_for_line1=(); local -a fonts_for_line234=();      local -a fonts_for_longer_than20=()
    local -i text_alignment;      local flag_font_selected;  local font_color;          local ffmpeg_filter_complex; local -i stil_frame_rotation_angle; local -i clearlogo_rotation_angle
    local -i expansion_expression_replace_space_wplus;       local -i min;              local -i max;                local y_offset
    local flag1;                  local flag2;               local flag3;               local flag_case;             local flag_active; 
    local font_name;              local char_count;          local font_size;           local px_height
    unset pixel_heights[@]; unset font_datasets[@]; unset fonts_for_line1[@]; unset fonts_for_line234[@]; unset fonts_for_longer_than20[@]
	
    local ds00=('0|0|1|MC|OK|Oswald'         '1|80|74'  '2|80|76' '3|74|72' '4|74|70' '5|60|64'  '6|60|66'  '7|64|56' '8|58|56' '9|58|62' '10|58|64' '11|60|64' '12|58|62' '13|52|54' '14|50|54' '15|48|54' '16|44|48' '17|28|32' '18|28|34' '19|28|30' '20|26|32')
    local ds01=('0|0|1|MC|OK|MouseMemoirs'   '1|78|64'  '2|78|64' '3|78|64' '4|78|68' '5|78|64'  '6|88|70'  '7|86|70' '8|64|56' '9|68|62' '10|70|62' '11|72|70' '12|72|66' '13|70|64' '14|68|64' '15|64|60' '16|58|56' '17|58|56' '18|40|38' '19|40|38' '20|40|34')
    local ds02=('1|1|0|MC|OK|Ranchers'       '1|78|70'  '2|78|70' '3|74|68' '4|64|62' '5|64|62'  '6|58|54'  '7|58|54' '8|54|60' '9|58|56' '10|48|48' '11|46|46' '12|48|48' '13|46|48' '14|46|48' '15|44|48' '16|40|44' '17|38|42' '18|30|34' '19|30|34' '20|30|34')
    local ds03=('0|0|0|MC|OK|Jersey 25'      '1|98|66'  '2|98|66' '3|94|64' '4|90|62' '5|90|62'  '6|90|62'  '7|88|60' '8|86|62' '9|80|58' '10|72|58' '11|64|50' '12|56|42' '13|52|42' '14|52|44' '15|50|44' '16|44|38' '17|40|34' '18|38|34' '19|34|28' '20|34|30')
    local ds04=('1|1|0|MC|OK|Darumadrop One' '1|104|68' '2|98|68' '3|96|68' '4|92|68' '5|100|72' '6|100|68' '7|78|52' '8|72|52' '9|70|56' '10|56|46' '11|50|50' '12|46|42' '13|44|38' '14|42|36' '15|40|34' '16|38|36' '17|36|34' '18|34|34' '19|30|30' '20|30|28')
    local ds05=('0|1|0|MC|OK|Archivo Black'  '1|90|70'  '2|88|66' '3|84|66' '4|84|70' '5|82|68'  '6|80|64'  '7|62|60' '8|60|62' '9|54|52' '10|48|48' '11|46|46' '12|40|40' '13|36|36' '14|34|34' '15|32|34' '16|30|30' '17|28|30' '18|28|30' '19|26|28' '20|22|24')
    local ds06=('1|1|0|MC|OK|Slackey'        '1|80|64'  '2|86|74' '3|84|68' '4|80|68' '5|80|66'  '6|68|56'  '7|62|50' '8|52|46' '9|50|48' '10|42|40' '11|38|38' '12|36|36' '13|32|30' '14|32|32' '15|28|30' '16|26|26' '17|26|26' '18|24|26' '19|22|24' '20|20|22')
    local ds07=('1|1|0|MC|OK|Chewy'          '1|84|68'  '2|84|78' '3|82|78' '4|84|78' '5|82|78'  '6|68|60'  '7|60|56' '8|60|56' '9|60|52' '10|58|58' '11|54|54' '12|52|52' '13|48|44' '14|46|44' '15|44|44' '16|40|40' '17|34|41' '18|30|36' '19|30|36' '20|30|36')
    local ds08=('1|0|0|UP|OK|Bungee'         '1|90|72'  '2|88|68' '3|86|68' '4|88|68' '5|84|68'  '6|68|56'  '7|60|48' '8|54|44' '9|48|40' '10|44|38' '11|42|36' '12|38|32' '13|34|30' '14|32|28' '15|30|26' '16|28|26' '17|26|24' '18|24|24' '19|22|20' '20|22|20')
    local ds09=('1|0|0|UP|NA|Pixeldead'      '1|88|70'  '2|88|66' '3|88|68' '4|88|72' '5|88|78'  '6|82|70'  '7|72|56' '8|62|50' '9|60|50' '10|50|48' '11|48|42' '12|42|40' '13|40|36' '14|36|34' '15|34|34' '16|32|32' '17|28|26' '18|32|34' '19|30|30' '20|26|26')
    local ds10=('1|0|0|UP|OK|Nosifer'        '1|90|72'  '2|86|78' '3|88|80' '4|86|80' '5|58|60'  '6|52|58'  '7|48|54' '8|42|50' '9|36|44' '10|34|40' '11|34|40' '12|30|34' '13|26|32' '14|26|34' '15|24|30' '16|22|28' '17|22|28' '18|20|24' '19|18|24' '20|16|22')
    local ds11=('1|0|0|UP|OK|Arco'           '1|86|68'  '2|86|68' '3|84|68' '4|82|68' '5|78|64'  '6|70|60'  '7|54|46' '8|52|46' '9|50|44' '10|42|38' '11|40|36' '12|36|34' '13|34|32' '14|30|28' '15|28|26' '16|28|26' '17|28|26' '18|26|26' '19|24|24' '20|22|22')
    local ds12=('1|0|0|UP|OK|Sigmar One'     '1|84|76'  '2|84|66' '3|84|54' '4|84|62' '5|78|58'  '6|68|56'  '7|54|40' '8|52|44' '9|48|38' '10|42|38' '11|38|36' '12|34|32' '13|32|26' '14|30|26' '15|30|30' '16|28|24' '17|28|26' '18|26|24' '19|24|24' '20|22|20')
    local ds13=('1|1|0|UP|OK|Trade Winds'    '1|82|72'  '2|80|70' '3|80|68' '4|82|68' '5|76|68'  '6|72|62'  '7|62|60' '8|60|60' '9|58|52' '10|50|50' '11|48|48' '12|42|42' '13|38|40' '14|38|40' '15|36|40' '16|32|30' '17|30|34' '18|30|30' '19|28|28' '20|26|26')

    font_datasets=( 'ds13' 'ds12' 'ds11' 'ds10' 'ds09' 'ds08' 'ds07' 'ds06' 'ds05' 'ds04' 'ds03' 'ds02' 'ds01' 'ds00' )
    for (( n=${#font_datasets[@]}; n >=0 ; n-- )); do
        for set in "${font_datasets[$n - 1]}"; do declare -n dataset="$set"; done
        IFS="|" read -r flag1 flag2 flag3 flag_case flag_active font_name <<< "${dataset[0]}";
        if [ $flag1 -eq 1 ] && [[ $flag_active =~ 'OK' ]]; then fonts_for_line1+=($set); fi
        if [ $flag2 -eq 1 ] && [[ $flag_active =~ 'OK' ]]; then fonts_for_line234+=($set); fi
        if [ $flag3 -eq 1 ] && [[ $flag_active =~ 'OK' ]]; then fonts_for_longer_than20+=($set); fi    
    done
    fonts_for_line1=(  $(shuf -e ${fonts_for_line1[@]} ) )
    fonts_for_line234=( $(shuf -e ${fonts_for_line234[@]} ) )
    fonts_for_longer_than20=(  $(shuf -e ${fonts_for_longer_than20[@]} ) )
  
    text_alignment=( $(shuf -e "1" "(w-text_w)/2" "w-text_w-3") )
    for (( n=${#ref_movie_title[@]}; n >=0 ; n-- )); do 
      if [[ ${#ref_movie_title[$n]} -gt 20 ]]; then text_alignment="w-text_w-3"; fi 
    done
    
    if [ ! -d "$logo_folder" ]; then mkdir -p "$logo_folder"; fi   
    placeholder_image="$logo_folder/temp310x202.png"
    ffmpeg -f lavfi -i "color=c=0xffffff@0x00:s=310x202:duration=1,format=rgba" "$placeholder_image" -y -loglevel panic    
    flag_font_selected=0
    for (( i=0; i < ${#ref_movie_title[@]}; i++ )); do
      if [ $i -eq 0 ]; then
          font_color=$color2; fontBorderColor=$color3
          for set in "${fonts_for_line1}"; do declare -n dataset="$set"; done
          flag_case=${dataset[0]:6:2}; 
          if [[ $flag_case =~ "MC" ]]; then flag_font_selected=( $(shuf -e 1 0 1 1 0) ); fi
          y_offset=1;
      fi

      if [ $i -gt 0 ] && [ $flag_font_selected -eq 0 ]; then        
          for set in "${fonts_for_line234[0]}"; do declare -n dataset="$set"; done
          font_color=$color3; fontBorderColor=$color4
          flag_font_selected=( $(shuf -e 0 1 1 1 0 1 1) )
      fi
      IFS="|" read -r char_count font_size px_height <<< "${dataset[ $(( ${#ref_movie_title[$i]} )) ]}"

      if [[ ${#ref_movie_title[$i]} -gt 20 ]]; then
          flag3=${dataset[0]:4:1};
          if [[ $flag3 =~ "0" ]]; then
              for set in "${fonts_for_longer_than20[0]}"; do declare -n dataset="$set"; done
              IFS="|" read -r char_count font_size px_height <<< "${dataset[20]}"
          fi
      fi
      
      font_name=${dataset[0]:12}
      pixel_heights+=($px_height)
      y_offset=1
      for (( n = 1; n < ${#pixel_heights[@]}; ++n )); do y_offset=$((y_offset + ${pixel_heights[$n - 1]} )); done
      if [[ $(echo "$y_offset + $px_height" | bc) -gt 202 ]]; then y_offset=$(echo "202 - $px_height" | bc); fi

      ffmpeg -i "$placeholder_image" \
             -filter_complex "[0:0]crop=2:2:in_w:in_h[img];color=c=0xffffff@0x00:s=310x202,format=rgba \
                             ,drawtext=text='${ref_movie_title[$i]}':fontfile=$font_name:fontcolor=$font_color:fontsize=$font_size:bordercolor=$fontBorderColor:borderw=1:shadowx=3:shadowy=3:x=$text_alignment:y=$y_offset[bg]; \
                             [bg][img]overlay=0:0:format=rgb,format=rgba[out]" \
             -map [out] -c:v png -frames:v 1 \
             "$logo_folder/tempClearlogo$i.png" -y -loglevel error
      refLogger+=("  generate_rating_screen_clip() title[$i]          --> $font_name, fontData="$char_count"|"$font_size"|"$px_height",  y_offset=$y_offset, text='${ref_movie_title[$i]}'")
    done #for i=0 to max ref_movie_title()
    ffmpeg_filter_complex="[1]scale=-1:-1[b];[0][b] overlay"
    case ${#ref_movie_title[@]} in
      1)  mv "$logo_folder/tempClearlogo0.png" "$logo_folder/tempClearlogo.png";; 

      2)  ffmpeg -i "$logo_folder/tempClearlogo0.png" -i "$logo_folder/tempClearlogo1.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempClearlogo.png" -y -loglevel error ;;

      3)  ffmpeg -i "$logo_folder/tempClearlogo0.png" -i "$logo_folder/tempClearlogo1.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempDraw01.png" -y -loglevel error  
          ffmpeg -i "$logo_folder/tempDraw01.png" -i "$logo_folder/tempClearlogo2.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempClearlogo.png" -y -loglevel error ;;

      4)  ffmpeg -i "$logo_folder/tempClearlogo0.png" -i "$logo_folder/tempClearlogo1.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempDraw01.png" -y -loglevel error  
          ffmpeg -i "$logo_folder/tempDraw01.png" -i "$logo_folder/tempClearlogo2.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempDraw02.png" -y -loglevel error
          ffmpeg -i "$logo_folder/tempDraw02.png" -i "$logo_folder/tempClearlogo3.png" \
                 -filter_complex "$ffmpeg_filter_complex" -vframes 1 \
                 "$logo_folder/tempClearlogo.png" -y -loglevel error ;;
    esac 
    mv "$logo_folder/tempClearlogo.png" "${logo_folder%/*}/Clearlogo.png"

    min=-3; max=9
    stil_frame_rotation_angle=$(( RANDOM % (max-min+1) + min ))
    clearlogo_rotation_angle=$(( RANDOM % (max-min+1) + min ))
    expansion_expression_replace_space_wplus=${pixel_heights[@]/%/ +}0
    out_drawbox_logodeco_height=$(echo $(( ${expansion_expression_replace_space_wplus} )) )

    ffmpeg -f lavfi -i "color=c=0xffffff@0x00:s=360x282:duration=1,format=rgba" "$logo_folder/temp360x282.png" -y -loglevel panic  
    ffmpeg -i "$logo_folder/temp360x282.png" -i "${logo_folder%/*}/Clearlogo.png" \
           -filter_complex "[1]scale=-1:180[clearlogo];
                            [0][clearlogo]overlay=30:54,rotate=-$clearlogo_rotation_angle*PI/180,crop=310:202" \
           -vframes 1 \
           "${logo_folder%/*}/ClearlogoRotated.png" -y -loglevel error
    drawbox_logodeco_height=$out_drawbox_logodeco_height
    rm -Rd "$logo_folder"

    refLogger+=("  generate_rating_screen_clip() font_datasets     --> fonts_for_line1=$fonts_for_line1, fonts_for_line234=$fonts_for_line234, fonts_for_longer_than20=$fonts_for_longer_than20")
    refLogger+=("  generate_rating_screen_clip() text_alignment    --> $text_alignment")
    refLogger+=("  generate_rating_screen_clip() Clearlogo Rotated --> stil_frame_rotation_angle=$stil_frame_rotation_angle, clearlogo_rotation_angle=$clearlogo_rotation_angle")	
	  refLogger+=("  generate_rating_screen_clip() out_drawbox_logodeco_height=$out_drawbox_logodeco_height (AS OUTPUT VALUE)")	
    return 0 #sucess
}

########################################BREAKPOINT POSTERS
#Creates posters images for the film
function generate_poster_images_function() { #pre-production candidate
    local -n val1=$1; local -n ref2=$2; local -n ref3=$3; local -n ref4=$4; local -n refLogger=$5
    local inHDRFont=${val1[fontNameInHDR]};            local teaserFont=${val1[fontNameTeaser]}
    local posterRadius=${val1[posterCornerRadius]};    local guiAccentColor1=${val1[guiAccentColor1]}
    local guiAccentColor2=${val1[guiAccentColor2]};    local teaserText=${val1[teaser]} 
	  local maxPosters=${val1[maxPosters]};              local dsColors=${val1[dsColors]}  
    local -n drawboxLogoDecoHeight=${ref2[0]}
    local durationSecs=${ref3[duration]};              local height=${ref3[height]}
    local dynamicRange=${ref3[dynamic_range]}
    local workPath=${ref4[work_path]};                 local cachePath=${ref4[cache_path]}
    local film=${ref4[full_path]}  

    local postersPath="$workPath/posters"
	  local eq='eq=brightness=0.2:contrast=1:saturation=1.5'
    IFS="|" read -r posterBgColor  color2  color3  color4  consistency  bgGammaRGB  paletteDescr  paletteID  <<< "$dsColors"
    local clearlogoImagePath='';  local logoImagePositionXY='';  local logoDecoXY_WH=''
    local scale=''; 		          local stillTransform='';       local stillIimagePositionXY=''
    local inHDRDrawbox=''; 		    local inHDRDrawtext='';        local posterStyle=''
    local teaserDrawboxXY_WH='';  local teaserFontPositionXY;    local drawboxBgColor=''    
    local drawboxTeaser='';       local drawtextTeaser;          local randomDrawboxDecoXY_WH=''
    local min=-3;                 local max=9;                   local ssAt=''
    local stillFrameRotationAngle=$(( RANDOM % (max-min+1) + min ))
	  local roundCorner="format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${posterRadius})*gt(abs(H/2-Y),H/2-${posterRadius}),\
                       if(lte(hypot(${posterRadius}-(W/2-abs(W/2-X)),${posterRadius}-(H/2-abs(H/2-Y))),${posterRadius}),255,0),255)'"

    if [ ! -d "$postersPath" ]; then 
      mkdir -p "$postersPath"
    fi
    if [[ $dynamicRange == *"HDR"* ]]; then
      inHDRDrawbox=",drawbox=x=0:y=(ih/1.96):w=(iw*0.27):h=(ih*0.052):color=white@0.5:thickness=fill"
      inHDRDrawtext=",drawtext=text='$dynamicRange':fontcolor=$guiAccentColor1:fontfile='$inHDRFont':x=(w*0.02):y=(h/1.9):fontsize=(h*0.03):bordercolor=0x$guiAccentColor2:borderw=6"
    fi
    
    if [[ $(( RANDOM % (30 + 30) + (-30) )) -ge 0  ]]; then  #if randon mumber >=0, then rotate still frame and use rotated logo, else use horizontal clearlogo.png image
      scale="scale=-1:(ih/1.8)"
      if ! eq=$(get_ffmpegeq_from_rgb_fn "$bgGammaRGB"); then
        refLogger+=('  Failed to obtain intended eq value. Using default: '"$eq" )
      fi
      stillTransform="rotate=$stillFrameRotationAngle*PI/180:c=none"  
      clearlogoImagePath="$workPath/ClearlogoRotated.png"
    else
      scale="scale=-1:660"
      stillTransform="crop=740:660:160:(in_h)"
      clearlogoImagePath="$workPath/Clearlogo.png"        
    fi
    eq="eq=brightness=0.2:contrast=1:saturation=1.5" #DEBUG
    local ds90=('55:675' '0:100'    '0:25:780:74'    'x=(w-text_w)/2:y=45'   '160:720' 'teaser@top----still@mid-----clearlogo@bottom')
    local ds91=('55:10'  '0:350'    '0:950:720:90'   'x=(w-text_w)/2:y=960'  '0:0'     'clearlogo@top-still@mid-----teaser@bottom'   )
    local ds92=('55:620' '0:40'     '0:1020:720:60'  'x=(w-text_w)/2:y=1030' '0:0'     'still@top-----clearlogo@mid-teaser@bottom'   )
    local ds93=('55:0'   '0:478'    '0:420:720:56'   'x=(w-text_w)/2:y=430'  '0:0'     'clearlogo@top-teaser@mid----still@bottom'    )
    local ds94=('55:675' '-100:100' '0:25:780:74'    'x=(w-text_w)/2:y=45'   '0:0'     'teaser@top----still@mid-----clearlogo@bottom')
    local ds95=('55:10'  '0:350'    '220:80:720:280' 'x=(w-text_w)/2:y=1035' '40:80'   'clearlogo@top-still@mid-----teaser@bottom'   )
    local ds96=('55:680' '40:80'    '0:0:2:2'        'x=(w-text_w)/2:y=35'   '0:25'    'clearlogo@top-still@fill----teaser@bottom'   )
    local dsPoster=( $(shuf -e   "ds96" "ds95" "ds94" "ds93" "ds92" "ds91" "ds90" ) )
    dsPoster="ds94" #DEBUG
    local -n poster="$dsPoster"  #required alias array
    logoImagePositionXY=${poster[0]};   
    stillIimagePositionXY=${poster[1]};  
    teaserDrawboxXY_WH=${poster[2]}; 
    teaserFontPositionXY=${poster[3]}
    logoDecoXY_WH=${poster[4]}:$(( 320 * 2 + 20 )):$(( $drawboxLogoDecoHeight * 2 - 40));

    drawboxBgColor=( $(shuf -e  $color4 $posterBgColor $posterBgColor ) ) 
    drawboxTeaser="drawbox=$teaserDrawboxXY_WH:color='$drawboxBgColor'@1:thickness=fill"
    drawtextTeaser="drawtext=text='$teaserText-$dsPoster':fontcolor='$guiAccentColor1':fontfile=$teaserFont:$teaserFontPositionXY:fontsize=h/28:bordercolor=0x$guiAccentColor2:borderw=5"
    randomDrawboxDecoXY_WH=( $(shuf -e ',drawbox=0:0:1:1' ',drawbox=0:0:1:1' ',drawbox=x=0:y=0:w=720:h=1080:color='$posterBgColor'@1' \
                                       ',drawbox=0:0:1:1' ',drawbox=x=0:y=0:w=720:h=1080:color='$posterBgColor'@1' )) 
    if [[ $height -ge 1080 ]]; then
      posterStyle=( $(shuf -e 'style2' 'style2' 'style2') ); 
    elif [[ $height -gt 720 ]] && [[ $height -le 1079 ]]; then
      posterStyle=( $(shuf -e 'style1' 'style2') ); 
    else
      posterStyle='style1'
    fi

    for ((n=1; n<=$maxPosters; n++)); do
      echo_feedback_function 'POSTER_WORK' 'Working on poster image' $n $maxPosters
      ssAt=$(fn_fix_decimal "$(echo "scale=2; ($durationSecs/$maxPosters*$n)-0.32" | bc)")
      case $posterStyle in  
      'style1')
        #A SolidColor as Background
        ffmpeg -f lavfi -i color=c=0x$posterBgColor:duration=1:s=720x1080:r=1 -i "$cachePath/artwork/landscape-green-01.png" \
               -filter_complex "[1]crop=720:1080:0:0,colorchannelmixer=aa=0.9[art]; \
                                [0][art]overlay=0:0,$roundCorner" \
              "$postersPath/.tempRoundCornerBg.png" -y -loglevel error    #Invalid file index 1 in filtergraph description
  
        ffmpeg -ss $ssAt -i "$film" \
               -filter_complex "null" \
               -frames:v 1 -q:v 1 \
               "$postersPath/.tempStill$n.png" -y -loglevel error

        ffmpeg -i "$postersPath/.tempRoundCornerBg.png" -i "$postersPath/.tempStill$n.png" -i "$clearlogoImagePath" \
               -filter_complex "[1]$scale,$eq,$stillTransform[still]; \
                                [2]scale=-1:404[clearlogo]; \
                                [0][still]overlay=$stillIimagePositionXY,drawbox=$logoDecoXY_WH:color=0x$color4@0.8:thickness=fill$randomDrawboxDecoXY_WH,$roundCorner[partial]; \
                                [partial][clearlogo]overlay=$logoImagePositionXY$inHDRDrawbox$inHDRDrawtext,$drawtextTeaser" -q:v 1 \
               "$postersPath/Poster$n.png" -y -loglevel error  ;;
      'style2')
        #A StillFrame as Background
        ffmpeg -ss $ssAt -i "$film" \
               -filter_complex "crop=720:1080,eq=brightness=0.2:contrast=1:saturation=3,$ffmpeg_roundcorner,$drawboxTeaser,$drawtextTeaser,\
                                drawbox=$logoDecoXY_WH:color='$posterBgColor'@0.3:thickness=fill$randomDrawboxDecoXY_WH" \
               -frames:v 1 -q:v 1 \
               "$postersPath/.tempStill$n.png" -y -loglevel error

        ffmpeg -i "$postersPath/.tempStill$n.png" -i "$clearlogoImagePath" \
               -filter_complex "[1]scale=-1:404[clearlogo]; \
                                [0][clearlogo]overlay=$logoImagePositionXY$inHDRDrawbox$inHDRDrawtext" \
               -q:v 1 \
               "$postersPath/Poster$n.png" -y -loglevel error  ;;      
      esac              
      #rm -f "$postersPath/.tempStill$n.png"
    done # n <1..$maxPosters
    #rm -f "$postersPath/.tempRoundCornerBg.png"

    random_poster=$((2 % $maxPosters));  random_poster=1
    mv "$postersPath/Poster$(echo "$random_poster + 1" | bc).png" "${postersPath%/*}/Poster-"$dsPoster".png" # ${postersPath%/*} removes the '/posters' part from ${param[0]}

    refLogger+=('_________'"$dsPoster"'__________'  "logoImagePositionXY=$logoImagePositionXY|  |posterBgColor=$posterBgColor|"  "  scale=$scale|  |eq=$eq|  |stillTransform=$stillTransform|  |drawbox=logoDecoXY_WH:color=0x$color4") 
    refLogger+=("[still]" "  overlay stillIimagePositionXY=\$poster[1]=$stillIimagePositionXY" ) 
    refLogger+=("  logoDecoXY_WH=(( XY \$poster[4] )):(( WH $logoDecoXY_WH))," "  drawboxLogoDecoHeight=$drawboxLogoDecoHeight (AS INPUT VALUE)" ) 
    refLogger+=("  randomDrawboxDecoXY_WH=|$randomDrawboxDecoXY_WH|  |inHDRDrawbox, inHDRDrawtext are empty") 
    refLogger+=("[partial][clearlogo]" "  overlay=$logoImagePositionXY" "  inHDRDrawbox=$inHDRDrawbox"  "  inHDRDrawtext=$inHDRDrawtext"  "  drawtextTeaser=$drawtextTeaser" "_______________________")     

    refLogger+=("ffmpeg -i '$postersPath/.tempRoundCornerBg.png' -i '$postersPath/.tempStill$n.png' -i '$clearlogoImagePath'")
    refLogger+=(' -filter_complex \"[1]'$scale,$eq,$stillTransform'[still];\ ')
    refLogger+=('   [2]scale=-1:404[clearlogo];\ ')
    refLogger+=('   [0][still]overlay='$stillIimagePositionXY',drawbox='$logoDecoXY_WH':color='$color4'@0.8:thickness=fill'$randomDrawboxDecoXY_WH',$roundCorner[partial];\ ')
    refLogger+=('   [partial][clearlogo]overlay='"$logoImagePositionXY$inHDRDrawbox$inHDRDrawtext,$drawtextTeaser"'\" -q:v 1\ ')
    refLogger+=("""$postersPath/Poster-"$dsPoster".png""")
    refLogger+=("_______________________")
    refLogger+=("  scale            --> $scale");          refLogger+=("  eq               --> $eq")
    refLogger+=("  stillTransform   --> $stillTransform"); refLogger+=("  clearlogoImagePath   --> $clearlogoImagePath")
    refLogger+=("  dsPoster          --> $dsPoster");        refLogger+=("  logoImagePositionXY  --> $logoImagePositionXY")
    refLogger+=("  drawboxBgColor         --> $drawboxBgColor");       refLogger+=("  randomDrawboxDecoXY_WH--> $randomDrawboxDecoXY_WH")
    refLogger+=("  logoDecoXY_WH         --> $logoDecoXY_WH");       refLogger+=("  drawboxLogoDecoHeight --> $drawboxLogoDecoHeight (AS INPUT VALUE)")
    refLogger+=("  posterStyle             --> $posterStyle");           refLogger+=("  random_poster           --> $random_poster")
    refLogger+=("-------------------------------")
    # refLogger+=('ffmpeg -f lavfi -i color=c=0x$posterBgColor:duration=1:s=720x1080:r=1 -i '"$cachePath/artwork/landscape-green-01.png"'\ ')
    # refLogger+=('  -filter_complex \"[1]crop=720:1080:0:0,colorchannelmixer=aa=0.9[art];\ ')
    # refLogger+=('   [0][art]overlay=0:0,$roundCorner\" ')
    # refLogger+=("$postersPath/.tempRoundCornerBg.png"  "-------------------------------")

    # refLogger+=("val1" "$inHDRFont" "$teaserFont" $posterRadius $guiAccentColor1 $guiAccentColor2 "$teaserText" 
    #           "----ref" $drawboxLogoDecoHeight "-----" $durationSecs $height "$dynamicRange" "----" "poster folder=$postersPath" "MAX POSTERS=$maxPosters" "ssAt=$ssAt" "stillFrameRotationAngle=$stillFrameRotationAngle")
    # refLogger+=("---ds_color--" $color1 $color2 $color3 $color4 $consistency "$bgGammaRGB" "posterBgColor=$posterBgColor"  "eq=$eq" "-----END-----" )
    # printf '%s\n' "${refLogger[@]}" > "Test Video/New Year Celebration 92/_log.txt"     
    return 0 #sucess
	# INPUT  : param $1 is an array of input values
	# OUTCOME : at least 1 Poster.png on movie folder (other candidates on posters folder)	
}


#INPUT : $1=Folder where file actors.txt and other *.txt  must be saved. $2=Unique Id of the source metainfo-list.txt
#OUTPUT: n/a
function fn_initialize_metainfo() {
  IFS=$'\n'
  if (dpkg -s xidel &> /dev/null) && (dpkg -s libssl-dev &> /dev/null); then
    echo_feedback_function 'GROUNDWORK_INFO' 'Movie meta-info requested. Getting data for' 'plots' 'takes about a minute...'
    local html=($(xidel -s 'https://www.imdb.com/list/ls052725661' -e '//div[@class="ipc-html-content-inner-div"]' )) #-silent and -extract
    for ((i=0; i < ${#html[@]}; i+=1)); do
      echo -e "<![CDATA["${html[i]}"]]>" >> "$1/metainfo/plots.txt"
    done      
  fi
  sleep 45 #secs. recommended to complete the xidel download  

  local metainfo_list_filename="$1/metainfo-list.txt"; 
  local download_fileId="$2"
  local item_filename=""; local item_download_fileId=""
  if [ ! -f "$metainfo_list_filename" ]; then curl -s -L ${resource_base_url//$'{PLACEHOLDER-ID}'/$download_fileId} > "$metainfo_list_filename"; fi
  while IFS= read -r line; do
    if [[ $line == metainfo* ]] && [[ $line =~ \|(.*)\| ]]; then 
      item_download_fileId="${BASH_REMATCH[1]}"
      if [[ $line =~ .*\|(.*) ]]; then
        item_filename="${BASH_REMATCH[1]//[$'\r\n']/$''}"
        echo_feedback_function 'GROUNDWORK_INFO' 'Now, obtaining data for' "${item_filename//$'.txt'/$''}" 'is quite fast.'
        if [ ! -f "$1/metainfo/$item_filename" ]; then curl --location -s ${resource_base_url//$'{PLACEHOLDER-ID}'/$item_download_fileId} > "$1/metainfo/$item_filename"; fi
      fi
    fi
  done < "$metainfo_list_filename"
  logger+=("  generate_film_metainfo()")
  logger+=('    path:         : '"$1")
  logger+=('    downloadFileID: '"$download_fileId")
  
}


#Procedure to create an xml file --nfo extension, with random film information such as plot, rating, genre(s), actor(s), etc.
function fn_generate_film_metainfo() { 
    local -n val1=$1
    local dsPlots=${val1[dsPlots]};              local dsActors=${val1[dsActors]}
    local dsRoles=${val1[dsRoles]};              local dsDirectors=${val1[dsDirectors]}
    local dsGenres=${val1[dsGenres]};            local dsStudios=${val1[dsStudios]}
    local dsSearchTags=${val1[dsSearchTags]};    local dsTrailerIDs=${val1[dsTrailerIDs]}
    local classificationLetter=${val1[classificationLetter]}
    local -n ref2=$2
    local recognizedArgs=${ref2[recognized_args]}
    local -n ref3=$3
    local cachePath=${ref3[cache_path]}
    local fullBasename=${ref3[full_basename]}
    local filmBasename=${ref3[film_basename]}
    local -n refLogger=$4
    local rating=10;              local decade=1980;           local digit=0
    local indexPlot="";           local indexDirector="";      local indexStudio=""
    local indexActor1="";         local indexActor2="";        local indexRole1=""
    local indexGenre1="";         local indexGenre2=""
    local indexSearchTag1="";     local indexSearchTag2="";    local indexTrailerID=""
    local trailerElementDisabledOpen=""
    local trailerElementDisabledClose=""

    metainfoDir="$cachePath/metainfo"
    if [ -f "$metainfoDir/plots.txt" ]; then readarray -t dsPlots < "$metainfoDir/plots.txt"; fi
    if [ -f "$metainfoDir/actors.txt" ]; then readarray -t dsActors < "$metainfoDir/actors.txt"; fi
    if [ -f "$metainfoDir/roles.txt" ]; then readarray -t dsRoles < "$metainfoDir/roles.txt"; fi
    if [ -f "$metainfoDir/directors.txt" ]; then readarray -t dsDirectors < "$metainfoDir/directors.txt"; fi
    if [ -f "$metainfoDir/genres.txt" ]; then readarray -t dsGenres < "$metainfoDir/genres.txt"; fi
    if [ -f "$metainfoDir/studios.txt" ]; then readarray -t dsStudios < "$metainfoDir/studios.txt"; fi
    if [ -f "$metainfoDir/search-tags.txt" ]; then readarray -t dsSearchTags < "$metainfoDir/search-tags.txt"; fi
    if [ -f "$metainfoDir/trailer-ids.txt" ]; then readarray -t dsTrailerIDs < "$metainfoDir/trailer-ids.txt"; fi

    rating=( $(shuf -e 7 8 9 10) )
    decade=( $(shuf -e 1980 1980 1990 2000 2010 ) )
    digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )
    indexPlot=( $(shuf -e $(seq 0 $(echo ${#dsPlots[@]}-1 | bc ) ) ) )
    indexDirector=( $(shuf -e $(seq 0 $(echo ${#dsDirectors[@]}-1 | bc ) ) ) )
    indexStudio=( $(shuf -e $(seq 0 $(echo ${#dsStudios[@]}-1 | bc ) ) ) )
    indexActor1=( $(shuf -e $(seq 0 $(echo ${#dsActors[@]}-1 | bc ) ) ) )
    indexActor2=( $(shuf -e $(seq 0 $(echo ${#dsActors[@]}-1 | bc ) ) ) )
    until [[ $indexActor1 -ne $indexActor2 ]]; do indexActor2=( $(shuf -e $(seq 0 $(echo ${#dsActors[@]}-1 | bc ) ) ) ); done
    indexRole1=( $(shuf -e $(seq 0 $(echo ${#dsRoles[@]}-1 | bc ) ) ) )
    index_role2=( $(shuf -e $(seq 0 $(echo ${#dsRoles[@]}-1 | bc ) ) ) )
    until [[ $indexRole1 -ne $index_role2 ]]; do index_role2=( $(shuf -e $(seq 0 $(echo ${#dsRoles[@]}-1 | bc ) ) ) ); done
    indexGenre1=( $(shuf -e $(seq 0 $(echo ${#dsGenres[@]}-1 | bc ) ) ) )
    indexGenre2=( $(shuf -e $(seq 0 $(echo ${#dsGenres[@]}-1 | bc ) ) ) )
    until [[ $indexGenre1 -ne $indexGenre2 ]]; do indexGenre2=( $(shuf -e $(seq 0 $(echo ${#dsGenres[@]}-1 | bc ) ) ) ); done
    indexSearchTag1=( $(shuf -e $(seq 0 $(echo ${#dsSearchTags[@]}-1 | bc ) ) ) )
    indexSearchTag2=( $(shuf -e $(seq 0 $(echo ${#dsSearchTags[@]}-1 | bc ) ) ) )
    until [[ $indexSearchTag1 -ne $indexSearchTag2 ]]; do indexSearchTag2=( $(shuf -e $(seq 0 $(echo ${#dsSearchTags[@]}-1 | bc ) ) ) ); done
    indexTrailerID=( $(shuf -e $(seq 0 $(echo ${#dsTrailerIDs[@]}-1 | bc ) ) ) )

    if fn_is_excluded_from_script_options recognizedArgs -notrailer; then
      trailerElementDisabledOpen="<!-- "
      trailerElementDisabledClose=" -->"    
    fi
    printf "<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<movie>
  <title>$filmBasename</title>
  <originaltitle>$filmBasename</originaltitle>
  <rating>${rating[1]}</rating>
  <criticrating>${rating[2]}.${digit[2]}</criticrating> 
  <year>$((${decade[1]} + ${digit[1]}))</year>
  <mpaa>Not $classificationLetter</mpaa>
  <dateadded>2021</dateadded>
  <tagline>Overview</tagline>
  <plot>
    ${dsPlots[$indexPlot]}
  </plot>
  <actor>
    <name>${dsActors[$indexActor1]//[$'\r\n']/$''}</name>
    <role>${dsRoles[$indexRole1]//[$'\r\n']/$''}</role>
  </actor>
  <actor>
    <name>${dsActors[$indexActor2]//[$'\r\n']/$''}</name>
    <role>${dsRoles[$index_role2]//[$'\r\n']/$''}</role>
  </actor>
  <genre>${dsGenres[$indexGenre1]//[$'\r\n']/$''}</genre>
  <genre>${dsGenres[$indexGenre2]//[$'\r\n']/$''}</genre>
  <director>${dsDirectors[$indexDirector]//[$'\r\n']/$''}</director>  
  <studio>${dsStudios[$indexStudio]//[$'\r\n']/$''}</studio>
  <tag>${dsSearchTags[$indexSearchTag1]//[$'\r\n']/$''}</tag>
  <tag>${dsSearchTags[$indexSearchTag2]//[$'\r\n']/$''}</tag>
  $trailerElementDisabledOpen<trailer>plugin://plugin.video.youtube/?action=play_video&amp;videoid=${dsTrailerIDs[$indexTrailerID]//[$'\r\n']/$''}</trailer>$trailerElementDisabledClose
</movie>" > "$fullBasename"'.nfo'
    refLogger+=("  generate_film_metainfo()")
    refLogger+=("    rating[1]         : ${rating[1]}=<rating>")
    refLogger+=("    rating[2].digit[2]: ${rating[2]}.${digit[2]}=<criticrating>")
    refLogger+=("    decade[1]+digit[1]: ${decade[1]}+${digit[1]} =<year>")    
    refLogger+=("    indexPlot         : $indexPlot, ${dsPlots[$indexPlot]:0:48}...")
    refLogger+=("    indexActor1       : $indexActor1, ${dsActors[$indexActor1]}")
    refLogger+=("    indexRole1        : $indexRole1, ${dsRoles[$indexRole1]}")
    refLogger+=("    indexActor2       : $indexActor2, ${dsActors[$indexActor2]}")
    refLogger+=("    index_role2       : $index_role2, ${dsRoles[$index_role2]}")
    refLogger+=("    indexGenre1       : $indexGenre1, ${dsGenres[$indexGenre1]}")
    refLogger+=("    indexGenre2       : $indexGenre2, ${dsGenres[$indexGenre2]}")
    refLogger+=("    indexDirector     : $indexDirector, ${dsDirectors[$indexDirector]}")      
    refLogger+=("    indexStudio       : $indexStudio, ${dsStudios[$indexStudio]}")  
    refLogger+=("    indexSearchTag1   : $indexSearchTag1, ${dsSearchTags[$indexSearchTag1]}")
    refLogger+=("    indexSearchTag2   : $indexSearchTag2, ${dsSearchTags[$indexSearchTag2]}")
    refLogger+=("    indexTrailerID    : $trailerElementDisabledOpen $indexTrailerID, ${dsTrailerIDs[$indexTrailerID]//[$'\r\n']/$''} $trailerElementDisabledClose")
}

#Procedure to capture all trailer melodies registered and available from cache or online.
function fn_initialize_melodies() {
  local -n val=$1
  local cachePath=${val[cachePath]}
  local resourceBaseURL=${val[resourceBaseURL]}
  local downloadFileID=${val[downloadFileID]}
  local -n ref=$2
  local -n _maxMelodyIndex=${ref[0]}                          #(1)
  local -n _melodyFileIDs=${ref[1]}
  local -n _melodyAttributions=${ref[2]}
  local -n _melodyAttr=${ref[3]}
  local -n _refLogger=$3
  local melodyListFilenamePath="$cachePath/melody-list.txt"  #(2)
  unset _melodyFileIDs[@]
  unset _melodyAttributions[@]
  _melodyFileIDs+=("Placeholder_FID0_OK")
  _melodyAttributions+=("Placeholder_Inf0_OK")

  if [ ! -f "$melodyListFilenamePath" ]; then 
    curl -s -L ${resourceBaseURL//$'{PLACEHOLDER-ID}'/$downloadFileID} > "$melody_list_filename"
  fi
  while IFS= read -r line; do
    echo_feedback_function 'GROUNDWORK_MELO' 'Movie trailers requested.' 'Identifying soundtrack melodies...'
    if [[ $line == melody* ]] && [[ $line =~ \|(.*)\| ]] && [[ ${#BASH_REMATCH[1]} == *"33"* ]]; then
      ((_maxMelodyIndex++))
      downloadFileID="${BASH_REMATCH[1]}"
      if [[ $line =~ .*\|(.*) ]]; then
      _melodyAttr="${BASH_REMATCH[1]}"
      if [ ! -z "$_melodyAttr" ]; then _melodyAttr="Soundtrack Attribution-$_melodyAttr"; fi
      fi
      _melodyFileIDs+=("$downloadFileID")
      _melodyAttributions+=("$_melodyAttr")
    fi
  done < "$melodyListFilenamePath" 
  _refLogger+=($(fn_repeat_char '-' 64) "  initialize_melodies():" 
               "    _maxMelodyIndex=$_maxMelodyIndex, _melodyAttributions="$((${#_melodyAttributions[@]}-1))", _melodyFileIDs="$((${#_melodyFileIDs[@]}-1))
               $(fn_repeat_char '-' 64))
  #(1) Underscore naming convention to avoid 'circular name reference' errors when called from generate melodies function
  #(2) Folder where file melody-list.txt must be found.  
  #(3) Unique Id of the original source melody-list.txt on a shared location
}

function fn_generate_melodies() {
  local -n var=$1
  local cachePath=${var[cachePath]};        local resourceBaseURL=${var[resourceBaseURL]}
  local downloadFileID=${var[downloadFileID]};     
  local -n ref=$2
  local -n maxMelodyIndex=${ref[0]};       local -n melodyIndex=${ref[1]}
  local -n melodyCounter=${ref[2]};        local -n melodyFileIDs=${ref[3]}
  local -n melodyAttributions=${ref[4]};   local -n melodyAttr=${ref[5]}
  local -n melodyIndexes=${ref[6]}
  local -n refLogger=$3

  if [[ maxMelodyIndex -gt 0 ]]; then
    ((melodyCounter++))
    melodyIndex=$(( RANDOM % ($maxMelodyIndex) + 1 ))
    if [[ $melodyCounter -le $maxMelodyIndex ]]; then
      while [[ " ${melodyIndexes[*]} " = *"$melodyIndex"* ]]; do
        melodyIndex=$(( RANDOM % ($maxMelodyIndex) + 1 ))
      done
    else
      local -A bykeyvalue=([cachePath]=$cachePath   [resourceBaseURL]=$resourceBaseURL   [downloadFileID]=$downloadFileID)
      local -a byreference=(maxMelodyIndex   melodyFileIDs   melodyAttributions   melodyAttr)
      fn_initialize_melodies  bykeyvalue  byreference  refLogger	  
      melodyIndex=$(( RANDOM % ($maxMelodyIndex) + 1 ))
      melodyCounter=1
    fi
    melodyIndexes+=("$melodyIndex")
    if [ ! -f "$cachePath/melodies/_melody$melodyIndex.mp3" ]; then
      curl -s -L ${resourceBaseURL//$'{PLACEHOLDER-ID}'/${melody_fileIDs[$melodyIndex]}} > "$cachePath/melodies/_melody$melodyIndex.mp3"
    fi
  else
      if [ ! -f "$cachePath/melodies/_melody$melodyIndex.mp3" ]; then
        melodyIndex=( $(shuf -e 4 3 2 1) )
        curl --location -s 'https://filesamples.com/samples/audio/mp3/sample'$melodyIndex'.mp3'} > "$cachePath/melodies/_melody$melodyIndex.mp3"
      fi
  fi
  melodyAttr=${melody_attributions[$melodyIndex]}
	refLogger+=("  generate_melodies():" "    melodyCounter="$melodyCounter  "    melodyIndex="${melodyIndex[@]}  "    melodyAttr=""${melodyAttr[@]}")
  return 0 
}

# Provides film's metadata in a bash associative array structure
function fn_get_film_metadata() {
  local film=$1;      
  local -A metadata=()
  eval $(ffprobe -v error -select_streams v:0 -count_packets -show_entries \
         stream=codec_name,width,height,display_aspect_ratio,pix_fmt,color_range,color_primaries,color_space,color_transfer,bit_rate,r_frame_rate,nb_read_packets \
         -of flat=s=_ "$film")
  metadata[width]=$streams_stream_0_width
  metadata[height]=$streams_stream_0_height
  metadata[codec_name]=$streams_stream_0_codec_name             				        #h264
  metadata[pix_fmt]=$streams_stream_0_pix_fmt                   				        #yuv420p
  metadata[color_range]=$streams_stream_0_color_range           				        #tv
  metadata[aspect_ratio]=$streams_stream_0_display_aspect_ratio                 #"4:3"
  metadata[bit_rate]=$(echo "$streams_stream_0_bit_rate" | bc ) 
  metadata[frame_rate]=$(echo "scale=2; $streams_stream_0_r_frame_rate" | bc )  #33000
  metadata[color_primaries]=$streams_stream_0_color_primaries                   #bt709
  metadata[color_transfer]=$streams_stream_0_color_transfer                     #bt709
  metadata[color_space]=$streams_stream_0_color_space                           #bt709
  metadata[frames]=$streams_stream_0_nb_read_packets 
  metadata[duration_sexagesimal]="$(ffprobe -of csv=p=0 -show_entries format=duration -sexagesimal "$film" -loglevel error )"
  metadata[duration]="$(ffprobe -of csv=p=0 -show_entries format=duration "$film" -loglevel error)"
  if [[ $streams_stream_0_color_primaries == *"2020"* ]] && [[ $streams_stream_0_color_space == *"2020"* ]] && 
   ( [[ $streams_stream_0_color_transfer != *"709"* ]] || [[ $streams_stream_0_color_transfer == *"601"* ]] ); then 
    metadata[dynamic_range]="HDR"
  else
    metadata[dynamic_range]="SDR"
  fi 
  echo "${metadata[@]@K}"  #(1) 
  return 0 
  #(1) Prints all key-value pairs, i.e.: (width "640" bitrate "29.97" height "480" framerate "3000" ... ) 
  #    Also, to print all values of the associative array, you can use echo "${metadata[@]@Q}"
  #    See "Parameter Expansion" in man bash:  K produces a possibly-quoted version of the value of parameter,
  #    except that it prints the values of indexed and associative arrays as a sequence of quoted key-value pairs. 
  # Credits: How to combine associative arrays in bash? @stackoverflow.com/a/75182516
  # Sample output : (width "640" bitrate "29.97" height "480" framerate "3000" ... )
  # Implementation: declare -A fn_get_film_metadata="($(fn_get_film_metadata "$dir/$filmname.mp4"))"
}

#Gets an associative array containing file resources such as directory, extension, filename of the film to work on.
function fn_get_film_resources_location() {
  local fullPath=$1
  if [ ! -f "$fullPath" ]; then return 1; fi	      
  local -A resource=()
  local newDirectory=$(dirname -- "$fullPath")/$(basename -- "${fullPath%.*}") #(1)
  resource[root_path]=$(dirname -- "$fullPath")
  resource[work_path]="$newDirectory"
  resource[full_path]="$newDirectory/$(basename -- "$fullPath")"
  resource[full_basename]="${fullPath%.*}/$(basename -- "${fullPath%.*}")"
  resource[film_basename]="$(basename -- "${fullPath%.*}")"
  resource[film_name]="$(basename -- "$fullPath")"  
  resource[film_extension]="$(basename -- "${fullPath##*.}")"  
  echo "${resource[@]@K}"  #(2)
  return 0
  #(1) -- means if file starts with hypen, then remove it and process.  Variables in quotation to deal with white spaces.
  #(2) Expand as key-value form, so global associative array can capture this local return value.
  #Sample values:
  #fullPath (fentry) =Family Video/New Year Celebration 92.mp4
  #   root_path      =Family Video
  #   work_path      =Family Video/New Year Celebration 92   
  #   full_path      =Family Video/New Year Celebration 92.mp4/New Year Celebration 92.mp4
  #   full_basename  =Family Video/New Year Celebration 92.mp4/New Year Celebration 92   
  #   film_basename  =New Year Celebration 92
  #   film_name      =New Year Celebration 92.mp4    
  #   film_extension =mp4
  # Sample implementation: 
  #   declare -A res=(); eval res+=($(fn_get_film_resources_location "$file_entry"))
}

#Custom function converts film timestamps into hour minute format.
fn_to_hhmm() {
    local seconds=$(echo "$1" | sed 's/.[0-9]*$//')                 #(1)
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local seconds_left=$((seconds % 60)) 
    if [ $hours -eq 0 ] && [ $minutes -eq 0 ]; then 
        printf "00\\\:00\\\:%2d" $seconds_left  
    elif [ $hours -eq 0 ]; then
        if [ $minutes -eq 1 ]; then
            printf "00\\\:%2d\\\:%2d" $minutes $seconds_left 
        else
            printf "00\\\:%2d\\\:00" $minutes
        fi    
    else
        printf "%2d\\\:%2d\\\:00" $hours $minutes
    fi
    # local timestamp=$(echo "$1" | sed 's/.[0-9]*$//')                 #(1)
    # local hours=$((timestamp / 3600))
    # local minutes=$(((timestamp % 3600) / 60))
    # local seconds=$((timestamp % 60))
    # if [ $hours -eq 0 ] && [ $minutes -eq 0 ]; then
    #   printf "%2dsecs" $seconds
    # elif [ $hours -eq 0 ]; then
    #   printf "%02dm:%02ds" $minutes $seconds
    # else
    #    printf "%02d:%02d:%02d" $hours $minutes $seconds
    # fi
    return 0;
    #(1) To remove trailing zeros from a timestamp string number, including the decimal 
    # Debug with printf "%02dh - %02dm -  %02ds\n" $hours $minutes $seconds_left
    # Sample input timestamp variable tsTo=103.000000 produces output '@minute 1.43...''
}

#Returns s value for a knwon key in string array (sample input: "width,640|height")
#Usage: width=$(fn_get_metavalue "width" "dynamic_range=SDR|width=640|height=480|")
function fn_get_metavalue() {
  local targetKey=$1;     local keyValuesString=$2
  local keyValuesArray=()
  IFS="|" read -ra keyValuesArray <<< $keyValuesString
  for pair in ${keyValuesArray[@]}; do
    if [[ $pair == *"$targetKey"*  ]]; then
        IFS="=" read -ra keyValueArray <<< $pair
        value=${keyValueArray[1]}; break
	  fi
  done
  echo $value; return 0
}

#Given an array with numbers to search for, return the closest one to the target (Sequential search).
function fn_find_nearest() {
  local target=$1;     local subset=(${@:2})
  local nearest=${subset[0]}
  local recordDiff=$(fn_fix_decimal $(echo "scale=6; $nearest - $target" | bc ))     #(1)
  local foundLevel=0
  if [ $(echo "scale=6; $recordDiff < 0" | bc) -eq 1 ]; then
      recordDiff=$(echo "scale=6; $recordDiff-($recordDiff*2)" | bc)                 #(2) 
  fi
  for num in "${subset[@]}"; do
      local diff=$(fn_fix_decimal $(echo "scale=6; $num - $target" | bc ))
      if [ $(echo "scale=6; $diff < 0" | bc) -eq 1 ]; then
          diff=$(fn_fix_decimal $(echo "scale=6; $diff-($diff*2)" | bc))
      fi
      if [ $(echo "scale=6; $diff < $recordDiff" | bc) -eq 1 ]; then
          recordDiff=$diff;  nearest=$num; foundLevel=0; 
      else 
          foundLevel=$(($foundLevel+1))
      fi
      if [[ $foundLevel -gt 3 ]]; then break; fi
  done
  echo $nearest; return 0
  #(1) Adds a leading zero if number less that 1. Bash nuisance...
  #(2) A negative real numer converted to positive!  Bash nuisance...
}

#Prefix a decimal string number with zero if less than 1
#Sample input '.123 ' returns '0.123'
function fn_fix_decimal() {
	local decimal=$1
	if [ $(echo "$decimal < 1" | bc ) -eq 1 ] &&  
	   [ $(echo "$decimal > 0" | bc ) -eq 1 ]; then 
		decimal='0'$1
	fi
	echo $decimal; return 0
}

#When the difference between the proposed keyframe is less or way to far than the clip duration,  we need to
#read the film's complete list of timestamps (which includes the keyframes).  This function help to decide.
function fn_cannot_find_next_keyframe_difference_in_range() {
    local difference=$1
    local duration=$2

    # Calculate perent of the input parameter
    local range_percent=$(echo "$difference * 0.2" | bc -l)

    # Calculate the lower and upper bounds
    local lower_bound=$(echo "$difference - $range_percent" | bc -l)
    local upper_bound=$(echo "$difference + $range_percent" | bc -l)

    # Check if the duration is within the range
    if (( $(echo "$duration >= $lower_bound" | bc -l) && $(echo "$duration <= $upper_bound" | bc -l) )); then
        return 1  # False: The difference is still in percent range.  Keep using keyframes.
    else
        return 0  # True: Cannot find difference in percent range.  Would have to use timeframes instead.
    fi
}

#Return a string with film's keyframes-timecodes of interest
#Sample return "19.686333,24.691333|39.672967,45.578867|61.327933,67.233833|82.982900,84.951533|"
function fn_retrieve_film_timestamps() {
    local film=$1;               local maxNumberOfClips=$2;   local clipDurationSecs=$3
    local retrieve_ssAt_tsTo=(); local subset=();             local dsTS=(); 
    local iLeap=1;               local ssAt=0.000000;         local tsTo=0.000000
    local i=0
    
    if ! test -f "$film"; then echo "0.00|0.00|"; return 1;    fi
    local dsKF=($(echo $(ffprobe -loglevel error -select_streams v:0 -show_entries packet=pts_time,flags \
                                 -of csv=print_section=0 "$film" | awk -F',' '/K/ {print $1}')))              #(1)

    iLeap=$(echo "scale=0; ${#dsKF[@]}/$maxNumberOfClips - ${#dsKF[@]}/20" | bc)                              #(2)
    for ((i=iLeap; i <= $(($iLeap*$maxNumberOfClips)); i+=iLeap)); do
      subset="${dsKF[@]:$i:$iLeap}"
      ssAt=$(fn_fix_decimal "${dsKF[$i-1]}")
      nextKeyframe=$(echo "scale=6; $ssAt + $clipDurationSecs" | bc)
      tsTo=$(fn_find_nearest $nextKeyframe $subset)                                         #(3)
      difference=$(echo "scale=6; $tsTo - $ssAt" | bc)
      if fn_cannot_find_next_keyframe_difference_in_range $difference $clipDurationSecs; then                 #(4)
          if [[ -z "${dsTS[@]}" ]]; then                                                                      #(5)
              dsTS=($(echo $(ffprobe -loglevel error -select_streams v:0 -show_entries packet=pts_time,flags \
                                      -of csv=print_section=0 "$film" | awk -F',' '/_/ {print $1}')))
          fi      
          local iOnTS=$(echo ${dsTS[@]/$ssAt//} | cut -d/ -f1 | wc -w | tr -d ' ')                            #(6)
          subset="${dsTS[@]:$(($iOnTS + 1))}"    
          nextTimestamp=$(echo "scale=6; $ssAt + $clipDurationSecs" | bc)
          tsTo=$(fn_find_nearest $nextTimestamp $subset)
      fi
      retrieve_ssAt_tsTo+=$ssAt","$tsTo"|"                                                                    #(7)
    done
    echo $retrieve_ssAt_tsTo; return 0
    #(1) Populate Keyframes array. Ffmpeg timestamps keyframe's are suffixed with ,K__, then removed in with awk
    #(2) Formula to find the first index position of the array (padding of 1/20th removed at the end)
    #(3) Find the nearest keyframe clipDurationSecs away.  Fix decimal if clip start less than 1sec. (Bash nuisance)
    #(4) When the difference between the proposed keyframe is less or way to far than the clip duration,
    #    we need to read the film's complete list of timestamps (which includes the keyframes)    
    #(5) if not already loaded onto memory then grab timestamps from file
    #    enclose in the if --for debug/Understanding: echo "$dsTS" >> dsTS_subset_$i.txt
    #(6) Sample value=19.686333 (TS)
    #(7) Find current ssAt index. Credits "Get the index of a value in a Bash array" @stackoverflow.com/a/30895333
    #    Return value. For debuging, prepend with "(cdsecs="$clipDurationSecs" diff="$(echo "$tsTo-$ssAt" | bc)"  i="$i" iOnTS="$iOnTS")"
    #For Debug/understanding purposes this line saves to a file all timestamps (replace "$film")
    #eval $(ffprobe -loglevel error -select_streams v:0 -show_entries packet=pts_time,flags -of csv=print_section=0 "$film" | awk -F',' '/_/ {print $1}' >> timestamps.txt)
}

#Procedure to create inner-clip-fragments (MAX_NUMBER_OF_CLIPS) and ambient-sound for final trailer
function pr_generate_trailer_inner_clips() {
    local -n arg1="$1"
    local maxNumberOfClips=${arg1[maxNumberOfClips]};                local aproxDurationSecs=${arg1[aproxDurationSecs]}
    local transitionDurationsSecs=${arg1[transitionDurationsSecs]};  local ratingDurationSecs=${arg1[ratingDurationSecs]}
    local logoDurationSecs=${arg1[logoDurationSecs]};                local dsColors=${arg1[dsColors]}
    local -n arg2="$2"
    local width=${arg2[width]};                   local height=${arg2[height]};          local bitRate=${arg2[bit_rate]}
    local frameRate=${arg2[frame_rate]};          local pixFmt=${arg2[pix_fmt]};         local colorPrimaries=${arg2[color_primaries]}
    local colorTransfer=${arg2[color_transfer]};  local colorSpace=${arg2[color_space]}  
    local -n arg3="$3"
    local tempPath=${arg3[temp_path]};            local logsPath=${arg3[logs_path]};     local -a film=${arg3[full_path]}
    local -n refLogger="$4"

    if ! test -f "$film"; then refLogger+=(' ERROR: Exit from process.  Test condition not true for film='"$film"); return 1;	fi
    local i=0;            local effect="";        local ts=()

    local dsTimestamps=$(fn_retrieve_film_timestamps "$film" $maxNumberOfClips $aproxDurationSecs)
    IFS="|" read -r color1 color2 color3 color4 consistency bgGammaRGB paletteDescription https_colorhunt_co_palette <<< $dsColors

    refLogger+=("  generate_trailer_inner_clips():");for key in "${!arg1[@]}"; do refLogger+=("    arg1: "$key'='"${arg1[$key]}"); done

    #Step 1-Create max number of clips,each lasting an aproximate duration in secs
    IFS="|" read -ra dsTS <<< $dsTimestamps
    for (( n = 1; n <= $maxNumberOfClips; n++ )); do
      echo_feedback_function 'TRAILERn' $n $maxNumberOfClips 'Quick slicing.'
      IFS="," read -r ssAt tsTo <<< "${dsTS[$(($n-1))]}"
      ffmpeg -ss $ssAt -to $tsTo -i "$film" \
             -c copy \
             $tempPath/clip$n.mp4 -y -loglevel error 2> $logsPath/.log-clip$n.txt
      ts+=($ssAt); ts+=($tsTo)
    done
    
    #Step 2-Slice-cut ambient audio and snap pictures for transitions
    echo_feedback_function 'TRAILER' 'First transition artifact.'
    local n=0
    ffmpeg -ss $(echo "${ts[0]} - $ratingDurationSecs/2" | bc) -i "$film" \
           -af "afade=t=in:st=0:d=$(echo "$ratingDurationSecs/2" | bc)" -q:a 0 -map a \
           -t $(echo "$ratingDurationSecs/2" | bc) $tempPath/audio-rating.mp3 -y -loglevel error 2> $logsPath/.log-audio-rating.txt

    ffmpeg -ss $(echo "${ts[1]} + $transitionDurationsSecs" | bc) -i "$film" -q:a 0 -map a \
           -t $transitionDurationsSecs $tempPath/audio1-tail.mp3 -y -loglevel error 2> $logsPath/.log-audio1-tail.txt

    ffmpeg -ss ${ts[1]} -i "$film" \
           -filter_complex "scale=-1:-1" -vframes 1 -q:v 2 \
           $tempPath/snap1-tail.jpg -y -loglevel error 2> $logsPath/.log-snap1-tail.txt
    n=2
    for (( x=2; x < $maxNumberOfClips*2-3; x+=2)); do
      echo_feedback_function 'TRAILERn' $n $maxNumberOfClips 'More transition artifacts...'
      ffmpeg -ss $(echo "${ts[$x]} - $transitionDurationsSecs" | bc) -i "$film" \
             -q:a 0 -map a \
             -t $transitionDurationsSecs $tempPath/audio$n-head.mp3 -y -loglevel error 2> $logsPath/.log-audio$n-head.txt

      ffmpeg -ss $(echo "${ts[$x+1]} + $transitionDurationsSecs" | bc) -i "$film" \
             -q:a 0 -map a \
             -t $transitionDurationsSecs $tempPath/audio$n-tail.mp3 -y -loglevel error 2> $logsPath/.log-audio$n-tail.txt

      ffmpeg -ss ${ts[$x]} -i "$film" \
             -filter_complex "scale=-1:-1" -vframes 1 -q:v 2 \
             $tempPath/snap$n-head.jpg -y -loglevel error 2> $logsPath/.log-snap$n-head.txt

      ffmpeg -ss ${ts[$x+1]} -i "$film" \
             -filter_complex "scale=-1:-1" -vframes 1 -q:v 2 \
             $tempPath/snap$n-tail.jpg -y -loglevel error 2> $logsPath/.log-snap$n-tail.txt
      let n++
    done
    echo_feedback_function 'TRAILER' 'Completing transition artifacts...'
    n=$maxNumberOfClips
    ffmpeg -ss $(echo "${ts[$n*2-2]} - $transitionDurationsSecs" | bc) -i "$film" \
           -q:a 0 -map a \
           -t $transitionDurationsSecs $tempPath/audio$n-head.mp3 -y -loglevel error 2> $logsPath/.log-audio$n-head.txt

    ffmpeg -ss ${ts[$n*2-1]} -i "$film" \
           -q:a 0 -map a \
           -t $transitionDurationsSecs $tempPath/audio-clip$n-tail.mp3 -y -loglevel error 2> $logsPath/.log-audio-clip$n-tail.txt

    ffmpeg -ss $(echo "${ts[$n*2-1]} + $transitionDurationsSecs" | bc) -i "$film" \
           -af "afade=t=out:st=$(echo "$logoDurationSecs*0.2" | bc):d=$(echo "$logoDurationSecs - $logoDurationSecs*0.2" | bc)" -q:a 0 -map a \
           -t $logoDurationSecs $tempPath/audio-logo.mp3 -y -loglevel error 2> $logsPath/.log-audio-logo.txt

    ffmpeg -ss ${ts[$n*2-2]} -i "$film" \
           -filter_complex "scale=-1:-1" -vframes 1 -q:v 2 \
           $tempPath/snap$n-head.jpg -y -loglevel error 2> $logsPath/.log-snap$n-head.txt

    #Step 3-Create the transition clips with previously created artifacts
    local atMomentDrawbox="drawbox=x=0:y=0:w=(iw*0.27):h=(ih*0.1):color=$color2@0.5:thickness=fill"
    local atMomentDescription="fontcolor=$color1:fontfile='MouseMemoirs':x=(w*0.02):y=(h/1.9):fontsize=(h*0.03):bordercolor=0x$color3:borderw=6"
    transitionEffectType=0  #( $(shuf -e 1 0 0 1 0 0 1 1) ); transitionEffectType=( $(shuf -e $transitionEffectType 1 1 0 0 1 0 0 1 ) )
    if [[ $transitionEffectType -eq 1 ]]; then
      dsfps="d=6*$frameRate:s=$width"x"$height:fps="$frameRate
      for (( n = 1; n <= $maxNumberOfClips-1; n++ )); do #zoompan transition
        echo_feedback_function 'TRAILERn' $n $maxNumberOfClips 'Composing zoompan transition...'        
        transition=( $(shuf -e "zoompan=z='zoom+0.006':x=iw/2-(iw/zoom/2):y=ih/2-(ih/zoom/2)" \
                               "zoompan=z='zoom+0.006':x=0:y=0" \
                               "zoompan=z='zoom+0.006':x=iw/2-(iw/zoom/2):y=0" ))    #Ken Burns Zoom to Top Left    and to Top                                         
        atMoment="'@1-$(fn_to_hhmm ${ts[$n*2-2]})'"
        ffmpeg \
        -i $tempPath/audio$n-tail.mp3 \
        -i $tempPath/clip$n.mp4 \
        -i $tempPath/snap$n-tail.jpg \
        -filter_complex "[1:v][2:v]overlay=0:0,$transition:$dsfps, \
                                   drawbox=x=0:y=50:w=(iw*0.24):h=(ih*0.052):color=yellow@0.3:thickness=fill,\
                                   drawtext=text='$atMoment':x=(w*0.02):y=68:fontfile='DejaVuSans-Bold':fontcolor=ffffff:fontsize=(h*0.03):bordercolor=000000:borderw=2[v]; \
                         [0:a]volume=1[a]" \
        -map "[v]" -map "[a]" \
        -r $frameRate -b:v $bitRate -c:v libx264 -pix_fmt $pixFmt -color_primaries $colorPrimaries -color_trc $colorTransfer -colorspace $colorSpace \
        -t $transitionDurationsSecs $tempPath/clip$n-transition.mp4 -y -loglevel error 2> $logsPath/.log-clip$n-transition.txt
      done
    else
      for (( n = 1; n <= $maxNumberOfClips-1; n++ )); do #xfade transition
        transition=( $(shuf -e 'slideleft' 'slideright' 'slideup' 'slidedown'  'smoothleft' 'smoothright' 'smoothup' 'smoothdown' \
                               'circlecrop' 'rectcrop' 'circleclose' 'circleopen'  'horzclose' 'horzopen' 'vertclose' 'vertopen' \
                               'diagbl' 'diagbr' 'diagtl' 'diagtr' 'hlslice' 'hrslice' 'vuslice' 'vdslice' \
                               'dissolve' 'pixelize' 'radial' 'hblur'  'fade ' 'squeezev' 'squeezeh' 'zoomin' ))
        echo_feedback_function 'TRAILERn' $n $maxNumberOfClips 'Composing xfade transition...'                                  
        atMoment="T $(fn_to_hhmm ${ts[$n*2-2]})"
        echo; echo "atMomentN="$atMoment; echo  
        ffmpeg \
        -i $tempPath/audio$n-tail.mp3 \
        -i $tempPath/audio$(($n+1))-head.mp3 \
        -loop 1 -t $(echo "$ratingDurationSecs" | bc) -i $tempPath/snap$n-tail.jpg -loop 1 -t $(echo "$ratingDurationSecs" | bc) \
        -i $tempPath/snap$(($n+1))-head.jpg \
        -filter_complex "[2:v][3:v]xfade=duration=1:offset=0.5:transition=$transition,\
                         $atMomentDrawbox,\
                         drawtext=text='''$atMoment''':x=(w*0.02):y=10:fontfile='MouseMemoirs':fontcolor=yellow:fontsize=(h*0.05):bordercolor=000000:borderw=2[v]; \
                         [0:a][1:a]acrossfade=d=0.5[a]" \
        -map "[v]" -map "[a]" \
        -r $frameRate -b:v $bitRate -c:v libx264 -pix_fmt $pixFmt -color_primaries $colorPrimaries -color_trc $colorTransfer -colorspace $colorSpace \
        -t $transitionDurationsSecs $tempPath/clip$n-transition.mp4 -y -loglevel error 2> $logsPath/.log-clip$n-transition.txt
    done
    fi
    echo_feedback_function 'TRAILER' 'Creating last transition...'
    n=$maxNumberOfClips    #frozen transition (always for clip maxNumber)
    atMoment="T $(fn_to_hhmm ${ts[$n*2-2]})"  <--#bash script replace character in string
    echo; echo "atMomentT="$atMoment; echo
    ffmpeg -ss ${ts[$n*2-1]} -i "$film" \
           -filter_complex "scale=-1:-1" -vframes 1 -q:v 2 \
           $tempPath/snap$n-tail.jpg -y -loglevel error 2> $logsPath/.log-snap$n-tail.txt
    ffmpeg -i $tempPath/audio-clip$n-tail.mp3 -i $tempPath/clip$n.mp4 -i $tempPath/snap$n-tail.jpg \
           -filter_complex "[1:v][2:v]overlay=0:0, \
                            drawbox=x=0:y=50:w=(iw*0.24):h=(ih*0.052):color=yellow@0.3:thickness=fill,\
                            drawtext=text='''$atMoment''':x=(w*0.02):y=68:fontfile='MouseMemoirs':fontcolor=ffffff:fontsize=(h*0.03):bordercolor=000000:borderw=2[v]; \
                            [0:a]volume=1[a]" \
           -map "[v]" -map "[a]" \
           -r $frameRate -b:v $bitRate -c:v libx264 -pix_fmt $pixFmt -color_primaries $colorPrimaries -color_trc $colorTransfer -colorspace $colorSpace \
           -t $transitionDurationsSecs $tempPath/clip$n-transition.mp4 -y -loglevel error 2> $logsPath/.log-clip$n-transition.txt
    #for ((i=0; i<${#param[@]}-1; i++)); do refLogger+=("  generate_trailer_inner_clips() param[$i]=${param[$i]}"); done; 
    return 0    
    #(1) Capture the first and last timestamps for use in ambient-sound
    #(2) Requirement: Rating screen with half of the ambient-sound at the end
    #Credits: @trac.ffmpeg.org/wiki/Xfade  (xfade)
    #         @www.bannerbear.com/blog/how-to-do-a-ken-burns-style-effect-with-ffmpeg (zoompan)
    #         @superuser.com/questions/727379/how-to-make-left-right-transition-of-overlay-image-ffmpeg
    #         @stackoverflow.com/questions/9913032/how-can-i-extract-audio-from-video-with-ffmpeg  
}

#Procedure to create the begining image of a trailer based on a random selected classification letter (i.e.: PG-13)
function pr_generate_trailer_rating_clip() {
    local -n arg1="$1"
    local durationSecs=${arg1[durationSecs]};   local rateTitle=${arg1[rateTitle]};                local classificationLetter=${arg1[classificationLetter]}
    local dsReason=${arg1[dsReason]};           local dsClassification=${arg1[dsClassification]};  local classificationFontName=${arg1[classificationFontName]}
    local ratingScreenFontname=${arg1[ratingScreenFontname]}
    local -n arg2="$2"
    local width=${arg2[width]};                   local height=${arg2[height]};          local bitRate=${arg2[bit_rate]}
    local frameRate=${arg2[frame_rate]};          local pixFmt=${arg2[pix_fmt]};         local colorPrimaries=${arg2[color_primaries]}
    local colorTransfer=${arg2[color_transfer]};  local colorSpace=${arg2[color_space]}  
    local -n arg3="$3"
    local tempPath=${arg3[temp_path]};          local logsPath=${arg3[logs_path]};     local cachePath=${arg3[cache_path]}
    local -n refLogger="$4"
    if [ ! -f $tempPath/clip1.mp4 ]; then return 1;	fi
    if [ ! -f $cachePath/RATING-logo.png ]; then
      output_file=$cachePath/RATING-logo.png
      source_url='https://raw.githubusercontent.com/dragonmarsx/VirtualServerSeries/afa30684c30dc779366b71ab931b2a6b412d0d00/_resources/RATING-logo.png'
      curl -o "$output_file" $source_url -s
    fi
    IFS="|" read -r screenColor letterX letterY letterFontSize letterBgColor letterTextColor classificationLineText classificationLineTextColor <<< "$dsClassification"      
    IFS="|" read -r rateLine1 rateLine2 rateLine3 <<< "$dsReason"
    local rateTextBorder='bordercolor=black:borderw=1:shadowx=3:shadowy=3'

    refLogger+=("  generate_trailer_rating_clip():");for key in "${!arg1[@]}"; do refLogger+=("    arg1: "$key'='"${arg1[$key]}"); done

    if [ $(echo "$height <= 1080" | bc ) ]; then logoScale=0.8; else logoScale=3.1; fi
    ffmpeg -f lavfi -i color=c=$screenColor@1:size=$width"x"$height -i $cachePath/RATING-logo.png \
    -filter_complex "[1:v]scale=-1:(ih*$logoScale)[ratelogo], \
            [0:v][ratelogo]overlay=x=(main_w-overlay_w)/2:y=(main_h*0.66), \
            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.208):h=(ih*0.210):color=$letterBgColor@1:thickness=fill, \
            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.32):color=white@1, \
            drawbox=x=(iw*0.208):y=(ih*0.160):w=(iw*0.6):h=(ih*0.210):color=white@1, \
            drawtext=text='$rateTitle':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w-text_w)/2:y=(h*0.10):fontsize=(w*0.030):$rateTextBorder, \
            drawtext=text='$classification_letter':fontcolor=$letterTextColor:fontfile='$classificationFontName':x=$letterX:y=$letterY:fontsize=(w*$letterFontSize):$rateTextBorder, \
            drawtext=text='$(echo -e $rateLine1"\n"$rateLine2"\n"$rateLine3)':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w*0.438):y=(h*0.210+8):fontsize=(w*0.022):$rateTextBorder, \
            drawtext=text='General Audiences Admitted':fontcolor=white:fontfile='Sigmar One':x=(w-text_w)/2:y=(h*0.40):fontsize=(w*0.03):bordercolor=black:borderw=1:shadowx=3:shadowy=3, \
            drawtext=text='BY SOME':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w-text_w)/2:y=(h*0.55):fontsize=(w*0.025):$rateTextBorder, \
            drawtext=text='MOTION FILM CLASSIFICATION SYSTEM ON EARTH':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w-text_w)/2:y=(h*0.60):fontsize=(w*0.025):$rateTextBorder, \
            drawtext=text='www.popcornratings.corn':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w*0.07):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
            drawtext=text='www.freefamily.films':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w*0.76):y=(h*0.907):fontsize=(w*0.015):$rateTextBorder, \
            drawtext=text='®':fontcolor=f2f2f2@0.9:fontfile='$ratingScreenFontname':x=(w*0.83):y=(h*0.45):fontsize=(w*0.035):$rateTextBorder" \
            -frames:v 1 \
            $tempPath/snap-rating.png -y -loglevel error #2> $logsPath/.log-snap-rating.txt

    delayms=$(echo "$durationSecs*1000 - $durationSecs*1000/2" | bc)
    ffmpeg -i $tempPath/audio-rating.mp3 -i $tempPath/clip1.mp4 -i $tempPath/snap-rating.png \
           -filter_complex "[1:v][2:v]overlay=0:0; \
                            [0:a]adelay=$delayms|$delayms" \
          -r $frameRate -b:v $bitRate -c:v libx264 -pix_fmt $pixFmt -color_primaries $colorPrimaries -color_trc $colorTransfer -colorspace $colorSpace \
          -t $durationSecs $tempPath/clip-rating.mp4 -y -loglevel error 2> $logPath/.log-clip-rating.txt
    return 0
    #(1)
}

#Procedure to create the ending trailer clip
function pr_generate_trailer_logo_clip() {
    local -n arg1="$1"
    local maxNumberOfClips=${arg1[maxNumberOfClips]};    local melodyAttr=${arg1[melodyAttr]}
    local logoDurationSecs=${arg1[logoDurationSecs]};    local ratingScreenFontname=${arg1[ratingScreenFontname]}
    local dsColors=${arg1[dsColors]}
    local -n arg2="$2"
    local width=${arg2[width]};                   local height=${arg2[height]};          local bitRate=${arg2[bit_rate]}
    local frameRate=${arg2[frame_rate]};          local pixFmt=${arg2[pix_fmt]};         local colorPrimaries=${arg2[color_primaries]}
    local colorTransfer=${arg2[color_transfer]};  local colorSpace=${arg2[color_space]}; local dynamicRange=${arg2[dynamic_range]}  
    local -n arg3="$3"
    local tempPath=${arg3[temp_path]};            local logsPath=${arg3[logs_path]};     local workPath=${arg3[work_path]}
    local -n refLogger="$4"
    local logoScale=2;                            local overlayXY='x=0:y=0'

    IFS="|" read -r color1 color2 color3 color4 consistency bgGammaRGB paletteDescription https_colorhunt_co_palette <<< $dsColors
    refLogger+=("  generate_trailer_logo_clip():");for key in "${!arg1[@]}"; do refLogger+=("    arg1: "$key'='"${arg1[$key]}"); done

    if [ $width -lt 1080 ]; then logoScale=2; else logoScale=( $(shuf -e 2 4 4 4 2) ); fi
    overlayXY=( $(shuf -e "x=(main_w-310*$logoScale):y='if(lte(t,2),main_h-(main_h*t/2),main_h-(main_h*2/2))'" \
                          "x=0:y='if(lte(t,1),main_h-((main_h+overlay_h)*t/2),main_h-((main_h+overlay_h)*1/2))'" \
                          "x='if(lte(t,2),main_w-((main_w+overlay_w)*t/4)-100,main_w-((main_w+overlay_w)*2/4)-100)':y=160" \
                          "x='if(lte(t,1),main_w-((main_w+overlay_w)*t/2)-100,main_w-((main_w+overlay_w)*1/2)-100)':y=main_h-(202*$logoScale)-60") );            #(1)
    refLogger+=("    overlayXY=$overlayXY" "    logoScale=$logoScale")

    melodyAttr=${melodyAttr/:/\\:}; melodyAttr=${melodyAttr/,/\\,}                                                                                               #(2)
    ffmpeg -i $tempPath/clip$maxNumberOfClips-transition.mp4 \
           -i $tempPath/snap$maxNumberOfClips-tail.jpg \
           -i "$workPath/Clearlogo.png" \
           -i $tempPath/audio-logo.mp3 \
           -filter_complex "[3:a]volume=1; \
                            [2:v]scale=(iw*$logoScale):-1[clearlogo];  \
                            [1:v]scale=-1:-1[snaptail]; \
                            [0:v][snaptail]overlay=x=0:y=0,\
                            drawbox=x=0:y=50:w=(iw*0.11):h=(ih*0.052):color=white@0.3:thickness=fill, \
                            drawtext=text='$dynamicRange':x=(w*0.02):y=68:fontfile='$ratingScreenFontname':fontcolor=$color1:fontsize=(h*0.03):bordercolor=$color3:borderw=2, \
                            drawbox=x=0:y=(ih-60):w=$width:h=60:color=$color1@0.3:thickness=fill, \
                            drawtext=text='$melodyAttr':x=(w-text_w)/2:y=(h-50):fontcolor=$color3:fontfile='$ratingScreenFontname':bordercolor=$color4:borderw=1:fontsize=30[cliptransition]; \
                            [cliptransition][clearlogo]overlay=$overlayXY" \
           -r $frameRate -b:v $bitRate -c:v libx264 -pix_fmt $pixFmt -color_primaries $colorPrimaries -color_trc $colorTransfer -colorspace $colorSpace \
           -t $logoDurationSecs $tempPath/clip-logo-tmp-a01.mp4 -y -loglevel error 2> $logsPath/.log-clip-logo-tmp-a01.txt
    ffmpeg -i  $tempPath/clip-logo-tmp-a01.mp4 \
           -map 0:1 -map 0:0 -c copy \
           $tempPath/clip-logo.mp4 -y -loglevel error 2> $logsPath/.log-clip-logo.txt   #(3)
    return 0
    #(1) #Entries # 1&2:Logo moves from bottom going up, 2 and 1sec respectively. 
    #     Entries # 3&4:Logo left to right 2secs and 1sec respectively.
    #(2) Escaped colon and commas for filtercomplex
    #(3) Swaps audio layer: "Stream #0:1" is a wrong index.  Needs to be "Stream #0:0", same as all other clips
    #Credits: @superuser.com/questions/727379/how-to-make-left-right-transition-of-overlay-image-ffmpeg
}

function fn_get_clips_stream_information() {
    local streamType=$1;  local maxNumberOfClips=$2;  local tempPath=$3

    echo "   "$(ffmpeg -hide_banner -i $tempPath/clip-rating.mp4 2>&1 | grep "$streamType")" [clip-rating.mp4]" >> $tempPath/stream.txt
    for (( n = 1; n <= $maxNumberOfClips; n++ )); do
      echo "   "$(ffmpeg -hide_banner -i $tempPath/clip$n.mp4 2>&1 | grep "$streamType")" [clip$n.mp4]" >> $tempPath/stream.txt
      echo "   "$(ffmpeg -hide_banner -i $tempPath/clip$n-transition.mp4 2>&1 | grep "$streamType")" [clip$n-transition.mp4]" >> $tempPath/stream.txt
    done
    echo "   "$(ffmpeg -hide_banner -i $tempPath/clip-logo.mp4 2>&1 | grep "$streamType")" [clip-logo.mp4]" >> $tempPath/stream.txt
    echo "   "$(ffmpeg -hide_banner -i $tempPath/trailer-with-ambient-sound.mp4 2>&1 | grep "$streamType")" [trailer-with-ambient-sound.mp4]" >> $tempPath/stream.txt
    return 0
}

#Procedure to concatenate previously generated clips into the final trailer.
function pr_generate_trailer_final() {
    local -n arg1="$1"
    local maxNumberOfClips=${arg1[maxNumberOfClips]};   local melodyIndex=${arg1[melodyIndex]}
    local -n arg2="$2"
    local codecName=${arg2[codec_name]}
    local -n arg3="$3"
    local tempPath=${arg3[temp_path]};          local logsPath=${arg3[logs_path]}
    local cachePath=${arg3[cache_path]};        local fullBasename=${arg3[full_basename]}
    local -n refLogger="$4"
    local filterGraph="";                       local innerClips="";                 local -a concatDemux=()

    refLogger+=("  generate_trailer_final():");for key in "${!arg1[@]}"; do refLogger+=("    arg1: "$key"="${arg1[$key]}); done
    refLogger+=("    arg2: codecName="$codecName)

    if [[ ! $codecName == *"h264"* ]] || 
      ((lspci | grep -i nvidia > /dev/null) && (lsmod | grep -q nvidia)) || 
      (lspci | grep -i amd > /dev/null); then  #(1)
      echo_feedback_function 'TRAILER' 'Merging to re-encode all these clips. Process take minutes! Be Patient...patient.'
      for (( n = 1; n <= $maxNumberOfClips; n++ )); do
        innerClips+="-i $tempPath/clip$n.mp4 -i $tempPath/clip$n-transition.mp4 "
      done 
      for (( i = 1; i <= $maxNumberOfClips*2 + 1; i++ )); do filterGraph+="[$i:v][$i:a] "; done
      ffmpeg -i $tempPath/clip-rating.mp4 $innerClips -i $tempPath/clip-logo.mp4 \
            -filter_complex "[0:v][0:a] $filterGraph concat=n="$(($maxNumberOfClips*2 + 2))":v=1:a=1 [outv] [outa]" \
            -map "[outv]" -map "[outa]" -vsync vfr \
            $tempPath/trailer-with-ambient-sound.mp4 -y -loglevel error 2> $logsPath/.log-trailer-with-ambient-sound.txt
      refLogger+=("  innerClips=$innerClips" "    filterGraph=$filterGraph")
    else                                        #(2)
      echo_feedback_function 'TRAILER' 'Concatenating all clips into one is pretty fast.  Almost there.'     
      rm -f $tempPath/clips-concat-demux.txt
      concatDemux=("file 'clip-rating.mp4'")
      for (( n = 1; n <= $maxNumberOfClips; n++ )); do
        concatDemux+=("file 'clip$n.mp4'" "file 'clip$n-transition.mp4'")
      done
      concatDemux+=("file 'clip-logo.mp4'")
      printf '%s\n' "${concatDemux[@]}" > $tempPath/clips-concat-demux.txt
      ffmpeg -f concat -safe 0 -i $tempPath/clips-concat-demux.txt -c copy $tempPath/trailer-with-ambient-sound.mp4 -y -loglevel error 2> $logsPath/.log-trailer-with-ambient-sound.txt        
    fi

    echo_feedback_function 'TRAILER' 'Okey. Verifying the final trailer is fast.  Almost complete.'
    ffmpeg -i $cachePath/melodies/_melody$melodyIndex.mp3 \
           -filter:a "volume=0.3" \
           $tempPath/_melody$melodyIndex-low-volumen.mp3 -y -loglevel error  2> $logsPath/.log-trailer-melody-low-volumen.txt
    trailerLength=$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration $tempPath/trailer-with-ambient-sound.mp4 )
    ffmpeg -i $tempPath/trailer-with-ambient-sound.mp4 -stream_loop -1 -i $tempPath/_melody$melodyIndex-low-volumen.mp3  \
           -filter_complex "[0:a]apad[music]; [1:a][music]amerge[out]" \
           -c:v copy -map 0:v -map "[out]" \
           -t $(echo "scale=2; $trailerLength + 6.00" | bc) "$fullBasename-trailer.mp4" -y -loglevel error 2> $logsPath/.log-film-trailer.txt
    if ls $tempPath/clip*.mp4 1> /dev/null 2>&1; then 
      refLogger+=("    Clip video and audio stream information:")
      fn_get_clips_stream_information "Stream #0:0" $maxNumberOfClips "$tempPath"
      fn_get_clips_stream_information "Stream #0:1" $maxNumberOfClips "$tempPath"
      readarray -d $'\n' dsStreams < "$tempPath/stream.txt"
      refLogger+=("${dsStreams[@]//[$'\r\n']/$''}")
    else
      refLogger+=("    Video and audio stream information: NOT AVAILABLE/NOT FOUND")
    fi
    return 0
}

#Procedure to read each ffmpeg loglevel error generated by ffmpeg operations into the local event logger
function pr_find_ffmpeg_loglevel_error {
    local -n arg1="$1"
    local logsPath=${arg1[logs_path]}
    local -n refLogger="$2"
    local errorFiles=()

    if [[ ! -d "$logsPath" ]]; then 
      refLogger+=("  No log directory found to record loglevel error(s)."); return 0
    fi
    while IFS= read -r -d $'\0' file; do
        if [[ -f "$file" && -s "$file" ]]; then
          errorFiles+=("$file")
        fi
    done < <(find "$logsPath" -type f -name "*.txt" -print0)    

    if [[ ${#errorFiles[@]} -gt 0 ]]; then
      local content
      for file in "${errorFiles[@]}"; do
        content=$(< "$file") 
        refLogger+=("Error noted on ${file//$logsPath'/'/$''}:"  "$content"   " ")
      done
    else
      refLogger+=("  Great!  No ffmpeg loglevel error(s) reported.")
    fi
    return 0
}

#Procedure to create a rating screen (i.e. PG-13).  Requirement/nice-to-have on paid versions of movie-collection software.
function pr_generate_movie_rating_screen() {
    local -n param="$1"
    local tempPath=${param[0]};             local logsPath=${param[1]};         local film=${param[2]}

    if ! test -f $tempPath/clip-rating.mp4 ; then return 1;	fi
    ffmpeg -i $tempPath/clip-rating.mp4  -c copy -an "$tempPath/$film-rating.mp4" -y -loglevel error 2> $logsPath/.log-movie-rating.txt

    for ((i=0; i<${#param[@]}-1; i++)); do refLogger+=("  generate_movie_rating_screen() param[$i]=${param[$i]}"); done; return 0
}

function fn_get_random_rating_system_values() {
  local -A rating=()
  local classificationLetter="";   local screenTitle=""
  local -a dsReason=();            local titles=();         local index

  classificationLetter=( $(shuf -e 'G' 'PG' 'PG-13' 'R' 'G' 'NR' 'PG-13' 'PG'))	
  case $classificationLetter in
    'G'    ) dsClassification=('green|w*0.251|h*0.194|0.12|black|white|General Audiences Admitted|white|') ;;
    'PG'   ) dsClassification=('maroon|w*0.236|h*0.213|0.10|red|yellow|Family Guidance Suggested|yellow|') ;;
    'PG-13') dsClassification=('purple|w*0.218|h*0.241|0.06|11235A|F6ECA9|Unrestricted Under 13|F6ECA9|') ;;
    'R'    ) dsClassification=('darkblue|w*0.251|h*0.194|0.12|black|white|Restricted Audiences|white|') ;;
    'NR'   ) dsClassification=('black|w*0.236|h*0.213|0.10|white|maroon|Content Has Not Been Rated|white|') ;;
  esac
  index=( $(shuf -e 1 2 3 4 5 ))
  case $index in
    1 ) dsReason=('Because Some Material|May Be Insanely Memorable|For Unprepared Viewers|') ;;
    2 ) dsReason=('Due to Over-emotional,|Intense, Undisturbing|Graphic Material|') ;;
    3 ) dsReason=('For Fool Scences,|Mild Appropiate Dialogs,|and Goofy Language|') ;;
    4 ) dsReason=('For Inoffensive Scenes|Fool and Goofy|Mild Expressions|') ;;
    5 ) dsReason=('Due to Implicit Content|Showing Scences Full Of|Memory and Evocations|') ;;
  esac
  local titles=('THE FOLLOWING FEATURE HAS NOT BEEN RATED' 'THIS PREVIEW HAS NOT BEEN RATED' 'THIS MOTION FILM NAS NOT BEEN RATED')
  index=( $(shuf -e $(seq 0 $(bc <<<"${#titles[@]}-1") ) ) )
  screenTitle=${titles[$index]}

  rating[classification_letter]="$classificationLetter"
  rating[ds_lassification]="${dsClassification[@]}"
  rating[ds_reason]="${dsReason[@]}"
  rating[screen_title]="${screenTitle[@]}"
  echo "${rating[@]@K}"  #(1)
  return 0
  #(1) Expand as key-value form, so global associative array can capture this local return value.  
}
#End Functions

#Main Script Begin
GUI_ACCENTCOLOR1='9cf896'  #9cf896=LightGreen@Emby, A25FC4=Purle@Jellyfin, LightYellow@Plex
GUI_ACCENTCOLOR2='000000'  #1FAF55=DarkGreen@Emby , 007EA8=Blue@Jellyfin, DarkYellow@Plex
SUPPORTED_EXT=("mkv" "mp4" "avi")
VALID_ARGUMENTS=( -noposter -noback -nologo -nometa -nomusic -notrailer -dorgb -docopy -dochapter)
YELLOW='\033[1;33m'
RED='\033[0;33m'
NC='\033[0m' 
POSTER_RADIUS=40

declare folder_entry="$1"
declare -a input_values=()
declare -A chronometer_array
declare -a teasers=('Famby Original Collection' 'Streaming Now' 'Streaming Everywhere' 'Only at Famby' 'Instantly Available Here!' 'On A SmartTV Near You!' 'Famby Exclusive!' 'Now Playing Everywhere')
declare -a logger=()
declare -a lines_array=()

declare COUNTER=0; declare TOTAL_COUNTER=0
declare drawbox_logodeco_height=110
declare resource_base_url="https://"; resource_base_url+="drive.google.com/uc?export=download&id={PLACEHOLDER-ID}"

declare -a melody_fileIDs=()
declare -a melody_attributions=()
declare -a melody_indexes=()
declare max_melody_index=0
declare melody_counter=0

declare -a byreference=()
declare -A bykeyvalue=()
declare -A keyvalues1=()

declare -A resources=()
cache_path="cache"
#temp_path="/dev/shm/.temp"
#logs_path="/dev/shm/.logs"
temp_path="_temp"
logs_path=$temp_path"/_logs"
declare -A work_resources=([cache_path]="$cache_path"  [temp_path]="$temp_path" [logs_path]="$logs_path" )
if [ ! -d "$logs_path" ]; then mkdir -p "$logs_path"; fi
if [ ! -d "$temp_path" ]; then mkdir -p "$temp_path"; fi

#Script argument Validation Begin
if [[ $(whoami) -ne "root" ]]; then 
  echo -e "Execute script with root account privileges (superuser do) such as: ${YELLOW}su - ${NC}"
  exit 0
fi
if [[ -z ${@:1} ]] || [[ ${@:1} == -* ]]; then
  echo_feedback_function 'WARNING' "Missing argument. Requires 'folder name' in the command line."
  echo_feedback_function 'WARNING' 'Example 1) ./richerize.sh ${YELLOW}FolderNameWithMovies${NC}'
  echo_feedback_function 'WARNING' 'Example 2) ./richerize.sh ${YELLOW}'Enclose In Quotations This Folder With Spaces In Its Name'${NC}\n'
  exit 0
fi
for f in "$1"/*; do
    [ -d "$f" ] && continue; 
    if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi     
    old_f=$f; new_f=${f%.*}/$(basename -- "$f")
    let COUNTER++
done
if [ $COUNTER -eq 0 ]; then 
  echo_feedback_function 'ERROR' 'Folder does not exist, or folder has no movie content.' "$1"; exit 0; 
fi
typed_arguments=${@:2}
for i in ${typed_arguments[@]}; do
  if [[ " ${VALID_ARGUMENTS[*]} " =~ [[:space:]]${i,,}[[:space:]] ]]; then recognized_args+=("${i,,} "); fi
done
#End Script Argument Validation

# Pending -dochapter option
  # if fn_is_excluded_from_script_options recognized_args -dochapter]; then
  #   echo_feedback_function 'CHAPTERS' 'Working on Chapters...'
  #   declare -A film_resources="($(fn_get_film_resources_location "$1"))" 
  #   eval resources+=(${film_resources[*]@K})
  #   eval resources+=(${work_resources[*]@K})
  #   if fn_is_chapter_film_created  resources  metadata;  then
  #     echo_feedback_function 'CHAPTERS' 'Video with chapter information sucessfully created!'
  #   else
  #     echo_feedback_function 'CHAPTERS' 'Problems with chapter information when executing with -dochapter argument.'
  #   fi
  #   echo "Pending complete!"
  #   exit 0    
  # fi
#Dochapter ends

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

#Cache-Folder Groundwork Begin
echo_feedback_function 'Working' 'Lets enrich these movie assets...' ''

if [ ! -d "$cache_path" ]; then 
  CACHE_MESSAGE="NOTE: This directory can be safely deleted."$'\n'
  CACHE_MESSAGE+="The purpose is to store files locally, so future executions of this script can access them faster."$'\n\n\n'
  mkdir -p "$cache_path"; 
  touch "$cache_path/README.txt"; 
  echo $cache_path' folder '"$CACHE_MESSAGE" >> "$cache_path/README.txt"; 
fi

if fn_is_excluded_from_script_options recognized_args -notrailer; then
  if [ ! -d "$cache_path/melodies" ]; then mkdir -p "$cache_path/melodies"; fi  
  bykeyvalue=([cachePath]=$cache_path
              [resourceBaseURL]="$resource_base_url"
			        [downloadFileID]=$MELODY_LIST_DOWNLOAD_FILEID)
  byreference=(max_melody_index
               melody_fileIDs
               melody_attributions
               melody_attr)
  fn_initialize_melodies  bykeyvalue  byreference  logger
fi

if fn_is_excluded_from_script_options recognized_args -nometa; then
  if [ ! -d "$cache_path/metainfo" ]; then mkdir -p "$cache_path/metainfo"; fi
  if [ ! -f "$cache_path/metainfo-list.txt" ]; then fn_initialize_metainfo "$cache_path" $METAINFO_LIST_DOWNLOAD_FILEID; fi
fi
#End Cache-Folder Groundwork

#Richerize Process Begin
COUNTER=1
fn_chronometer "CHRON-RICHERIZE" 'START'
for f in "$1"/*; do
  declare melody_index=0
  declare melody_attr="n/a"
  declare -A film_resources="($(fn_get_film_resources_location "$f"))" 
  eval resources+=(${film_resources[*]@K})
  eval resources+=(${work_resources[*]@K})
  declare root_path=${resources[root_path]}
  declare work_path=${resources[work_path]}
  declare film=${resources[full_path]}
  declare full_basename=${resources[full_basename]}
  declare film_basename=${resources[film_basename]}
  declare film_name=${resources[film_name]}  
  declare film_extension=${resources[film_extension]}

  declare -A rating="($(fn_get_random_rating_system_values))"
  classification_letter=${rating[classification_letter]}
  ds_classification=${rating[ds_lassification]}
  ds_reason=${rating[ds_reason]}
  screen_title=${rating[screen_title]}

#Begin Move File, Chapterize (if necessary)
  [ -d "$f" ] && continue; 
  if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi

  new_f=${f%.*}/"$(basename -- "$f")"   #the new movie file absolute path
  ffmpeg_i=("$new_f")                   #file names in array deals w/white spaces.
  new_f_array=("$new_f"); x1=${new_f_array[@]}; x2=${x1%.*}
  base_name=${x2##*/}

  echo_feedback_function 'WORKING_ONn' $COUNTER $TOTAL_COUNTER "$film_name"
  declare one_line_args="${recognized_args[@]//[$'  ']/$''}"
  logger+=("NOTE:  This _log file is for diagnostic purposes.  It can be deleted without affecting functionality."  'DATE:  Created on '"$(date +"%Y-%m-%d, %H:%M:%S")")
  logger+=("SCRIPT EXECUTION:" "./richerize.sh '$1' $one_line_args" "MAX_POSTERS=$MAX_POSTERS,  MAX_BACKDROPS=$MAX_BACKDROPS" )
  logger+=("WORKING ON FILM: ""$film"" ("$COUNTER" OF "$TOTAL_COUNTER")"  $(fn_repeat_char '_' 105))

  mkdir -p "$work_path"

#Begin Move File
  if fn_is_excluded_from_script_options recognized_args -docopy; then	
      echo_feedback_function 'COPY_MOVE' 'MOVED!'
      mv "$f" "$work_path/"
      mv "$work_path".*.txt "$work_path/"
  else
      echo_feedback_function 'COPY_MOVE' 'COPIED!'$(fn_repeat_char ' ' 1)
      cp -a "$f" "$work_path/"
      declare user_chapters_file="CHAPTERS"
      if [ -d "$work_path".${user_chapters_file^^}.txt ]; then 
        cp -a "$work_path".${user_chapters_file^^}.txt "$work_path/"
      fi      
  fi
#Move File(s) End

#Begin File Metadata Profile
  declare profile=""
  declare -A metadata="($(fn_get_film_metadata "$film"))" 
  profile="${metadata[width]}w×${metadata[height]}h, ${metadata[aspect_ratio]}, ${metadata[frame_rate]}fps/${metadata[bit_rate]}bps, range:${metadata[dynamic_range]}, codec:${metadata[codec_name]}, length:${metadata[duration_sexagesimal]}(h:mm:ss.f)"
  echo -e "${RED}METADATA    :${NC} "${profile[@]}"."
  logger+=('METADATA: '"${profile[@]}")
#File Metadata Profile End

#Begin Chapterize (if necessary)
  if [ -f "$full_basename.chapters.txt" ] || ! fn_is_excluded_from_script_options recognized_args -dochapter ; then          #chapter file exist, we need to work on it
    echo_feedback_function 'CHAPTERS' 'Working on Chapters...'
		if fn_is_chapter_film_created resources metadata; then
			echo_feedback_function 'CHAPTERS' 'Video with chapter information sucessfully created!'
		else
			echo_feedback_function 'CHAPTERS' 'Problems with chapter information.  Errors details on log file.'
		fi
  fi
#Chapterize End

#Begin Coordinating Color Palette for use in Logo and Poster(s)
  logger+=("COLOR_PALETTE_(START)")
  declare color_set=$(get_color_palette_fn )
  IFS="|" read -r color1 color2 color3 color4 consistency bgGammaRGB paletteDescription https_colorhunt_co_paletteID <<< "$color_set"
  logger+=("  get_color_palette()")
  logger+=("    color1-2-3-4  : $color1-$color2-$color3-$color4" "    consistency   : $consistency")
  logger+=("    bgGammaRGB    : $bgGammaRGB" "    paletteDescrip: $paletteDescription" "    paletteID     : colorhunt.co/palette/$https_colorhunt_co_paletteID")  
  logger+=("COLOR_PALETTE_(DONE)")
#Coordinating Color Palette End

#Logo Image Begin
  if fn_is_excluded_from_script_options recognized_args -nologo; then
    echo_feedback_function 'LOGO_WORK' "Designing a unique logo with a color palette $paletteDescription..."
    logger+=("LOGO_(START)")
    IFS=$'|' read -a lines_array <<< "$(get_title_from_film_basename_fn "$film_basename" )"
    input_values=("$work_path/clearlogo" lines_array logger)
    generate_clearlogo_image_function input_values out_value
    if [ $? -eq 1 ]; then
      IFS=$'|' read -a lines_array <<< "$(get_title_from_film_basename_fn "Generic Movie Title" )"
      input_values=("$work_path/clearlogo" lines_array logger)
      generate_clearlogo_image_function input_values out_value
    fi
    echo_feedback_function 'LOGO_DONE'
    logger+=("LOGO_(DONE)")
  fi
#End Logo Image


#Poster Images Begin
  if fn_is_excluded_from_script_options recognized_args -noposter; then	
    echo_feedback_function 'POSTER_START' 'Working on posters'
    logger+=("POSTER_(START)")
    # if [ ! -d "${f%.*}/.temp" ]; then mkdir -p "${f%.*}/.temp"; fi
    # _temp="${f%.*}/.temp"
    
    if [ ! -f "$work_path/Clearlogo.png" ] && [ ! -f "$work_path/ClearlogoRotated.png" ]; then
      IFS=$'|' read -a lines_array <<< "$(get_title_from_film_basename_fn "$film_basename" )"
      input_values=("$work_path/clearlogo" lines_array logger)
      generate_clearlogo_image_function input_values drawbox_logodeco_height
    fi

    indx=( $(shuf -e $(seq 0 $(bc <<<"${#teasers[@]} - 1") ) ) ); 

    #teaser=${teasers[$indx]}; fontNameInHDR='Sigmar One'; fontNameTeaser='Oswald'; colorPosterBg=$color1;
    #input_values=("$work_path/posters" "$drawbox_logodeco_height" "$ffprobe_duration" "$ffprobe_height" "$fontNameInHDR" "$dynamicRange" \
    #              "$POSTER_RADIUS" "$GUI_ACCENTCOLOR1" "$GUI_ACCENTCOLOR2" "$color4" "$colorPosterBg" "$teaser" logger)
    #generate_poster_images_function input_values

    bykeyvalue=([fontNameInHDR]='Sigmar One' 
                [fontNameTeaser]='Oswald'
                [posterCornerRadius]=$POSTER_RADIUS 
                [guiAccentColor1]=$GUI_ACCENTCOLOR1
                [guiAccentColor2]=$GUI_ACCENTCOLOR2
                [teaser]=${teasers[$indx]}
                [maxPosters]=$MAX_POSTERS
                [dsColors]="$color_set")
    byreference=(drawbox_logodeco_height)                      
    generate_poster_images_function  bykeyvalue  byreference  metadata   resources  logger
    echo_feedback_function 'POSTER_DONE' $n    
    logger+=("POSTER_(DONE)")
  fi
#End Poster Images


#Background/Backdrop Images Begin
  if fn_is_excluded_from_script_options recognized_args -noback; then
    if fn_is_excluded_from_script_options recognized_args "-dorgb"; then
      eqR="eq=gamma_r=4:gamma_g=1:gamma_b=0,hue=s=10"; eqG="eq=gamma_r=0.2:gamma_g=1.1:gamma_b=0";
      eqB="eq=gamma_r=0:gamma_g=0.7:gamma_b=10";       eqC="eq=gamma_r=0.2:gamma_g=2:gamma_b=6";
      eqM="eq=gamma_r=9:gamma_g=1:gamma_b=3";          eqV="eq=gamma_r=3:gamma_g=1:gamma_b=9" ; 
      eqY="eq=gamma_r=4:gamma_g=4:gamma_b=0";          eqT="eq=gamma_r=0:gamma_g=1:gamma_b=2"  
      eqS="eq=gamma_r=7:gamma_g=2:gamma_b=0";          eqP="eq=gamma_r=6:gamma_g=2:gamma_b=2"
      eqG2="eq=gamma_r=0:gamma_g=1:gamma_b=0";         eqK="format=gray"
    else
      hue="hue=s=2" 
      eqR=$hue;eqG=$hue;eqB=$hue;eqC=$hue;eqM=$hue;eqV=$hue;eqY=$hue;eqT=$hue;eqS=$hue;eqP=$hue;eqK=$hue;eqG2=$hue;
    fi
    ffmpeg_eqRandom=( $(shuf -e $eqR $eqG $eqB $eqC $eqM $eqV $eqY $eqT $eqS $eqP $eqG2 $eqK) );  
    logger+=("BACKDROPS_(START)");
    for ((n=1; n<=$MAX_BACKDROPS; n++)); do
      echo_feedback_function 'BACKGROUND_WORK' 'Working on background image' $n $MAX_BACKDROPS
      ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_BACKDROPS*$n)-0.1" | bc)";  
      if [ $(bc <<< "$ffmpeg_ssAt < 1.00") -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
      ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 2 "${f%.*}/backdrop$n.jpg" -y -loglevel error
    done
    echo_feedback_function 'BACKGROUND_DONE' $n
    logger+=("  ffmpeg_eqRandom--> $ffmpeg_eqRandom")    
    logger+=("BACKDROPS_(DONE)")    
  fi
#End Background Images

#Begin Film meta-info file
  if fn_is_excluded_from_script_options recognized_args -nometa; then
    echo_feedback_function 'METAINFO_WORK' 'Now the editable movie meta-info file...'; logger+=("METAINFO_(START)")
    plots_array=('Enjoy this great remembrance.' 'May your memories be greatly enriched with this experience' 'Get your pop-corn ready for this mystical place called Memory')
    actors_array=('Generic Name A' 'Generic Name B' 'Generic Name C')
    roles_array=('as the generic role X' 'as the generic role Y' 'as the generic role Z')
    directors_array=('Generic Director A' 'Generic Director B' 'Generic Director C')
    genres_array=('Generic genre 1' 'Generic genre 2' 'Generic genre 3')
    studios_array=('Generic Studio X' 'Generic Studio Y' 'Generic Studio Z')
    search_tags_array=('SearchTagA' 'SearchTagB' 'SearchTagC')
    trailer_IDs_array=('kkrGBlvGK4I' 'HLw7pSXJe64' 'HlNRVZ871os')
    keyvalues1=([classificationLetter]="$classification_letter" 
                [dsPlots]=$plots_array 
                [dsActors]=$actors_array 
                [dsRoles]=$roles_array 
                [dsDirectors]=$directors_array 
                [dsGenres]=$genres_array 
                [dsStudios]=$studios_array 
                [dsSearchTags]=$search_tags_array 
                [dsTrailerIDs]=$trailer_IDs_array)
    fn_generate_film_metainfo  keyvalues1  recognized_args  resources   logger
    echo_feedback_function 'METAINFO_DONE'
    logger+=("METAINFO_(DONE)")
  fi
#End Movie meta-info file


#Movie Trailer Begin
  if fn_is_excluded_from_script_options recognized_args -notrailer; then  
    logger+=("TRAILER_(START)")
    fn_chronometer "CHRON-TRAILER" 'START'
    MAX_NUMBER_OF_CLIPS=4
    CLIP_APROX_DURATION_SECS=8
    CLIP_EFFECT_DURATION_SECS=2
    CLIP_RATING_DURATION_SECS=10
    CLIP_LOGO_DURATION_SECS=10

    keyvalues1=([maxNumberOfClips]=$MAX_NUMBER_OF_CLIPS 
                [aproxDurationSecs]=$CLIP_APROX_DURATION_SECS 
                [transitionDurationsSecs]=$CLIP_EFFECT_DURATION_SECS 
                [ratingDurationSecs]=$CLIP_RATING_DURATION_SECS 
                [logoDurationSecs]=$CLIP_LOGO_DURATION_SECS 
                [dsColors]="$color_set")
    pr_generate_trailer_inner_clips keyvalues1  metadata  resources  logger

    echo_feedback_function 'TRAILER' 'Generating a random rating system clip for this film...'
    keyvalues1=([durationSecs]=$CLIP_RATING_DURATION_SECS 
                [rateTitle]="$screen_title"
                [classificationLetter]="$classification_letter" 
                [dsReason]="$ds_reason"
                [dsClassification]="$ds_classification"
                [dsColors]="$color_set"
                [classificationFontName]="Archivo Black"
                [ratingScreenFontname]="Sigmar One")
    pr_generate_trailer_rating_clip  keyvalues1  metadata   resources  logger

    if [ ! -f "${f%.*}/Clearlogo.png" ]; then
      IFS=$'|' read -a lines_array <<< "$(get_title_from_film_basename_fn "$film_basename" )"
      #get_title_from_film_basename_fn "${base_name[@]}"
      input_values=("${f%.*}/clearlogo" lines_array logger)
      generate_clearlogo_image_function input_values drawbox_logodeco_height
    fi

    echo_feedback_function 'TRAILER' 'Generating a soundtrack melody for this video trailer...'
    bykeyvalue=([cachePath]=$cache_path
                [resourceBaseURL]="$resource_base_url"
                [downloadFileID]=$MELODY_LIST_DOWNLOAD_FILEID)
    byreference=(max_melody_index                         
                 melody_index
                 melody_counter 
                 melody_fileIDs
                 melody_attributions
                 melody_attr
                 melody_indexes)				
    fn_generate_melodies  bykeyvalue  byreference  logger
    
    echo_feedback_function 'TRAILER' 'Creating ending clip with film-logo.'
    keyvalues1=([maxNumberOfClips]=$MAX_NUMBER_OF_CLIPS 
                [melodyAttr]="$melody_attr" 
                [logoDurationSecs]=$CLIP_LOGO_DURATION_SECS 
                [ratingScreenFontname]="Archivo Black"
                [dsColors]="$color_set")
    pr_generate_trailer_logo_clip  keyvalues1   metadata   resources  logger

    echo_feedback_function 'TRAILER' "Merging all individual clips..."
    keyvalues1=([maxNumberOfClips]=$MAX_NUMBER_OF_CLIPS 
                [melodyIndex]=$melody_index)
    pr_generate_trailer_final  keyvalues1   metadata   resources  logger

    echo_feedback_function "TRAILER_DONE"
    logger+=("TRAILER_(DONE)")
  fi
#End Movie Trailer

#Background Audio Begin
  if fn_is_excluded_from_script_options recognized_args -nomusic  && [ $COUNTER -lt 6 ]; then
    echo_feedback_function 'THEME_WORK' ' Creating theme song (limited to 5)...';  logger+=("THEME_(START)")
    output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/theme.mp3"  
    source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'
    curl -o "$output_file" $source_url -s      
    echo_feedback_function 'THEME_DONE';   logger+=("THEME_(DONE)")
  fi
#End Background Audio

#Log event Begin
  logger+=("FFMPEG_LOGLEVEL_ERROR(START)")
  pr_find_ffmpeg_loglevel_error  resources   logger
  logger+=("FFMPEG_LOGLEVEL_ERROR(DONE)")
  printf '%s\n' "${logger[@]}" > "${f%.*}/_log.txt" 
  unset logger[@]
#End log events

#Clean-up Begin
  #if [ -d "$logs_path" ]; then rm -rf "$logs_path"/*; rmdir "$logs_path"; fi 
  #if [ -d "$temp_path" ]; then rm -rf "$temp_path"/*; rmdir "$temp_path"; fi  
  #if [ -d "${f%.*}/_temp" ] && [ -z "$( ls -A "${f%.*}/_temp" )" ]; then rm -Rd "${f%.*}/_temp"; fi  #_temp folder does exists && is empty
  if [[ "${typed_arguments,,}" == *"-nologo"* ]] && [ -f "${f%.*}/Clearlogo.png" ]; then rm "${f%.*}/Clearlogo.png"; fi #-nologo requested && file was created
  if [[ "${typed_arguments,,}" == *"-noposter"* ]] && [ -f "${f%.*}/ClearlogoRotated.png" ]; then rm "${f%.*}/ClearlogoRotated.png"; fi #-nologo requested && file was created 
  echo
#End Clean-up

  let COUNTER++
done
#End Richerize Process


#Summary End

count=$(find "$1" -type f -name "*.jpg" | wc -l)
count=$(echo "$count + $(find "$1" -type f -name "*.png" | wc -l)" | bc)
if [[ $count -gt 0 ]]; then 
  echo -e "SUMMARY: $(fn_chronometer "CHRON-RICHERIZE" 'STOP') A minimun of ${count} images were created to enhance the user experience of this movie collection.\n\n"; 
else
  echo -e "DONE. \n\n"; 
fi


#End Summary

#EOF
