#!/bin/bash
MAX_POSTERS=3
MAX_BACKDROPS=2
MPAAS=('TV-Y' 'APPROVED' 'TV-G' 'PG-13' 'PG-13' 'R' 'TV-MA')
ACTORS=('Sara Hayek' 'Liza Taylor' 'Gina Close' 'Jimmy Chan' 'Lucho DiCaprio' 'Ant Banderas' 'Penelope Reyes')
ROLES=('the guest star' 'the home princess' 'the queen been' 'the goofy' 'the bully' 'the car driver' 'the expert biker' 'the football coach' 'the neighbor' 'ice cream seller' 'the action hero' 'the aristocratic actor' 'the cat lady' 'the choosen one' 'the con arist' 'the damsel in distress' 'the latin lover' 'the bandido' 'the femme fatale' 'the figaro' 'the last standing' 'the folk hero' 'the jocker' 'the supernatural entity' 'the gypsy' 'the harlequin' 'the igor' 'the innocent' 'the knight-errant' 'the machiavelle' 'the eccentric' 'the dreamy' 'the attactive' 'the friendly villain' 'the diva' 'the legend' 'the noble prince' 'the mischievous' 'the preppy' 'the seductor' 'the schoolma`am' 'the impostor' 'the sidekick' 'the southern belle' 'the wise' 'the yuppie')
DIRECTORS=('Dhina Marca' 'Elmher Curio' 'Steban Dido' 'Elba Lazo' 'Elma Montt' 'Mario Neta' 'Yola Prieto')
GENRES=('Thriller' 'Action' 'Reality' 'Adventure' 'Fiction' 'Suspense' 'Comedy drama' 'Family drama' 'Romance' 'Drama' 'Comedy' 'Mystery' 'Soap opera' 'Documentary' 'Sports' )
STUDIOS=('Metro Golden Meyer' '20th Century Fox' 'Marvel Universe' 'Hanna-Barbera Studios' 'DreamWorks Animation' 'Paramount Pictures' 'Universal Pictures' 'Columbia Pictures' 'Warner Bros. Studios' 'Sony Picture Studios')
SEARCH_TAGS=('Birthday' 'Beach' 'Dancing' 'Streets' 'park' 'city' 'lake' 'snow' 'river')
TRAILER_IDS=('v-PjgYDrg70' 'iurbZwxKFUE' 'hu9bERy7XGY' 'G2gO5Br6r_4' 'un7a-i6pTS4' '-xjqxtt18Ys' 'LAr8SrBkDTI' 'vZnBR4SDIEs' 'mfw2JSDXUjE' 'CxwTLktovTU' 'eHcZlPpNt0Q' 'CwXOrWvPBPk' '-UaGUdNJdRQ' 'eTjHiQKJUDY' 'CZ1CATNbXg0' '1XHf94YqGyQ' 'xBgSfhp5Fxo' 'GUvk7NNmB64' 'HKH7_n425Ss' 'JFsGn_JwzCc' 'sJCjKQQOqT0' '9oQ628Seb9w' 'glPzcdMX5wI' 'CGbgaHoapFM' 'DFTIL0ciHik' 'xNWSGRD5CzU' 'mE35XQFxbeo' '5iB82S8rHyg' '_MoIr7811Bs' '_MoIr7811Bs' 'siLm9q4WIjI' '9OAC55UWAQs' 'G2z-xAZRFcQ' 'WYTE2_W2O00' 'ie53R2HEZ6g' 'orAqhC-Hp_o' 'Wlo-sYrADlw' 'TQhRqtt-Fpo' 'Su7g8JVY0xI' '1sD4qkCymtI' 'kkrGBlvGK4I' 'HLw7pSXJe64' 'HlNRVZ871os' 'GV5y4yTDtBI' 'RFeNB8IlPlc' 'eRNPQmk6wLU' '4ffrsBbrrQU' 'O6i3lyx1I_g' 'Njf8U5SnM4w' 'M0vnBeHeuzs' 'i4noiCRJRoE' 'pfESEXIZ_lw' 'JX6btxoFhI8' 'eTjDsENDZ6s' '-agq5R3b43U' 'Vngk9Wp9bGk' 'vZIY2-kH-wE' '8IBNZ6O2kMk' 'ZS_8btMjx2U' 'SPHfeNgogVs' 'qCKdkbsMUA8' 'sED6FRXIHJc' 'lFzVJEksoDY' '-qCPMP4mNcQ' 'usEkWtuNn-w' 'SyYESEvDNIg' 'hAGzq5jLCEk' '2BkVf2voCr0')
TEASERS=('Famby Originals' 'Streaming Now' 'Streaming Everywhere' 'Only at Famby' 'Available Now' 'On A SmartTV Near You!' 'Famby Exclusive!' 'Now Playing Everywhere')

#Do not modify below this line
SUPPORTED_EXT=("mkv" "mp4" "avi")
VALID_ARGUMENTS=( -noposter -noback -nologo -nometa -nomusic -notrailer -dorgb -docopy)
YELLOW='\033[1;33m'
RED='\033[0;33m'
NC='\033[0m' 
poster_radius=40
COUNTER=0;TOTAL_COUNTER=0

#Functions Begin
function Process_Pad () { [ "$#" -gt 1 ] && [ -n "$2" ] && printf "%$2.${2#-}s" "$1"; }
function Process_Message_Feedback () {
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
    'TRAILERDONE'    ) echo -ne "${RED}TRAILER     : ${NC}Trailer video clip.  ${RED}DONE!${NC}\n" ;;

    'TRAILERS'       ) echo -ne "${YELLOW}TRAILER     : ${NC}Now, preparing trailer clip ${YELLOW}$2${NC} of $3...\033[0K" ;;
    'BACKGROUNDS'    ) echo -ne "${YELLOW}BACKGROUNDS : ${NC}Now, preparing background images ${YELLOW}$2${NC} of $3...\033[0K" ;;
                    *) echo -ne "${YELLOW}$(Process_Pad $1 -12): ${NC}$2$3\033[0K" ;;
  esac
}

function Process_Chapter_File() {
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
#End Functions


#Argument Validation Begin
if [[ $(whoami) -ne "root" ]]; then echo -e "Execute script with root account privileges: ${YELLOW}su - ${NC}"; exit 0; fi
if [[ -z ${@:1} ]] || [[ ${@:1} == -* ]]; then
  Process_Message_Feedback 'ERROR' 'Missing argument. No directory name in the command line.'
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
if [ $COUNTER -eq 0 ]; then Process_Message_Feedback 'ERROR' 'Missing directory or directory has no content.' "$1"; exit 0; fi
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
  Process_Message_Feedback 'WORKING_ON' $COUNTER $TOTAL_COUNTER "$(basename -- "$f")"
  mkdir -p "${f%.*}"


  ffmpeg_f=("$f"); chapter_info=("${f%.*}.chapters.txt"); ffmpeg_i_with_chapters="${ffmpeg_i[@]}"
  if [[ "${typed_arguments,,}" == *"-docopy"* ]]; then 
    if [ -f "${chapter_info[@]}" ]; then          #chapter file exist, we need to work on it
      echo -e -n " Processing chapter..." 
      Process_Chapter_File "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      Process_Message_Feedback 'COPY_MOVE' 'COPIED!' 'Chapters created in the process.'
    else   
      cp -a "$f" "${f%.*}/"
      Process_Message_Feedback 'COPY_MOVE' 'COPIED!'
      #echo -e "${RED}COPIED!${NC}"
    fi
  else
    if [ -f "${chapter_info[@]}" ]; then
      echo -e -n " Processing chapter..."
      Process_Chapter_File "$ffmpeg_f" "$chapter_info" "$ffmpeg_i_with_chapters" "${ffmpeg_f[@]}"
      sleep 5;
      rm "$f"
      Process_Message_Feedback 'COPY_MOVE' 'MOVED!' 'With chapters created in the process.'
    else
      mv "$f" "${f%.*}/"
      Process_Message_Feedback 'COPY_MOVE' 'MOVED!'
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
  echo -e "${RED}METADATA    :${NC} $ffprobe_width"w×"$ffprobe_height"h" $ffprobe_aspect_ratio-$ffprobe_codec_name-$ffprobe_duration"secs w/$ffprobe_frames frames @$ffprobe_frame_rate"fps"
  echo -e "              Colors: $ffprobe_color_range-$ffprobe_pix_fmt-$ffprobe_color_primaries/$ffprobe_color_space/$ffprobe_color_transfer (primary/matrix coefficients/transfer characteristics)"
  #File Profile End

  #Logo Image Begin
  if [[ ! "${typed_arguments,,}" == *"-nologo"* ]]; then
    Process_Message_Feedback 'LOGO_WORK' 'Designing a unique logo..'
    #echo -e -n "${RED}LOGO        :${NC} Designing a unique logo...\033[0K\r"  
    font_color=( $(shuf -e "white" "yellow" "orange" "turquoise" "green") )
    border_color=( $(shuf -e "red" "black" "blue" "magenta") )
    font_family=( $(shuf -e "DejaVuSans-Bold.ttf" "DejaVuSans-Bold.ttf" "DejaVuSans-Bold.ttf" "DejaVuSerif-Bold.ttf" "DejaVuSansMono-Bold.ttf") )
    logo_text=${base_name[@]}
    chunks=$(( ${#logo_text} ))
    n=0
    while [ $n -lt $chunks ] && [ $n -lt 21 ]; do   
      echo -e ${logo_text:$n:4} >> "${f%.*}/title.txt";  let n=$(($n+4))       
    done
    ffmpeg -i "${ffmpeg_i[@]}" -filter_complex "[0:0]crop=2:2:0:0[img];color=c=0xffffff@0x00:s=310x202,format=rgba,drawtext=textfile='${f%.*}/title.txt':fontfile=$font_family:fontcolor=$font_color:fontsize=60:bordercolor=$border_color:borderw=4:x=(w-text_w)/2:y=(h-text_h)/2[bg];[bg][img]overlay=0:0:format=rgb,format=rgba[out]" -map [out] -c:v png -frames:v 1 -loglevel error "${f%.*}/Clearlogo.png" -y
    rm "${f%.*}/title.txt"
    Process_Message_Feedback 'LOGO_DONE'
    #echo -e "A logo image has been created. ${RED}DONE!${NC}           "
  fi
  #End Logo Image

  #Poster Images Begin
  if [[ ! "${typed_arguments,,}" == *"-noposter"* ]]; then
    Process_Message_Feedback 'POSTER_START' 'Working on posters'    
    _temp="${f%.*}/_temp"; mkdir -p "$_temp"

    idx=( $(shuf -e $(seq 0 $(bc <<<"${#TEASERS[@]} - 1") ) ) ); 
    teaser=${TEASERS[$idx]}
    theme_colors=( $(shuf -e '068130|ffff00' 'cceb19|000000' '7d0a14|c2ffff' '063b81|ffffff' '881798|ffe97f' '5e0053|ffffff' 'c50f1f|FFB6ED' '000000|ffffff'  ) )  #teaser colors: rectamgle-background|text-foreground 
    IFS="|" read -r themeBackColor themeTextColor  <<< "$theme_colors"    

    if [[ $ffprobe_color_primaries == *"2020"* ]] && [[ $ffprobe_color_space == *"2020"* ]] &&  \
      ( [[ $ffprobe_color_transfer != *"709"* ]] || [[ $ffprobe_color_transfer == *"601"* ]] ); then 
      inHDR_overlay=",drawbox=x=0:y=(ih/1.96):w=(iw*0.29):h=(ih*0.062):color=white@0.5:thickness=fill, \
                      drawtext=text='in HDR!':fontcolor=maroon:fontfile=SigmarOne-Regular':x=(w*0.02):y=(h/1.9):fontsize=(h*0.035):bordercolor=yellow:borderw=10"       
    fi
    ffmpeg_roundcorner="format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${poster_radius})*gt(abs(H/2-Y),H/2-${poster_radius}),if(lte(hypot(${poster_radius}-(W/2-abs(W/2-X)),${poster_radius}-(H/2-abs(H/2-Y))),${poster_radius}),255,0),255)'"

    if [ $(echo "$ffprobe_height <= 1080" | bc ) ]; then logo_design=( $(shuf -e '1080p' '1080p' '1079p') ); fi	#odds 1 of 3 to wind design 1080p

    case $logo_design in
    '1080p')
      dataset0=('x=20:y=25:w=680:h=50'   'SigmarOne-Regular' 'x=(w-text_w)/2:y=35:fontsize=h/28'   '55:680' )  #teasertop-logobottom (drawbox xy, fontname, font xysize, logo xy)
      dataset1=('x=20:y=970:w=680:h=50'  'SigmarOne-Regular' 'x=(w-text_w)/2:y=980:fontsize=h/28'  '55:0'   )  #teaserbottom-logotop
      dataset2=('x=20:y=1020:w=680:h=50' 'SigmarOne-Regular' 'x=(w-text_w)/2:y=1030:fontsize=h/28' '55:620' )  #logo,teaser-bottom
      datasetCollection=( $(shuf -e "dataset0" "dataset1" "dataset2" ) ) 
      declare -n data="$datasetCollection"
      teaser_overlay=",drawbox=${data[0]}:color='#$themeBackColor'@1:thickness=fill,drawtext=text='$teaser':fontcolor='#$themeTextColor':fontfile=${data[1]}:${data[2]}:bordercolor=yellow:borderw=2"
		
      for ((n=1; n<=$MAX_POSTERS; n++)); do
        Process_Message_Feedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
        ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.10" | bc)";  
        if [ $(echo "scale=2; $ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi #leading zero for _ssAt less than 1.00
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -filter_complex "crop=in_w/2:in_h,hue=s=2,$ffmpeg_roundcorner$teaser_overlay" \
               -frames:v 1 -q:v 2 \
               "$_temp/_temp$n.png" -y -loglevel error
        ffmpeg -i "$_temp/_temp$n.png" -i "${f%.*}/Clearlogo.png" \
               -filter_complex "[1]scale=-1:404[logo]; [0][logo]overlay=${data[3]}$inHDR_overlay" \
               -q:v 2 \
               "$_temp/poster$n.png" -y -loglevel error
        rm -f "$_temp/_temp$n.png"
      done ;;
    '1079p')
      dataset0=('55' 'SigmarOne-Regular' 'x=(w-text_w)/2:y=10:fontsize=h/28'   '55:680' )  #teasertop-logobottom ('n/a', fontname, font xysize, logo xy)
      dataset1=('40' 'SigmarOne-Regular' 'x=(w-text_w)/2:y=1035:fontsize=h/28' '55:0'   )  #teaserbottom-logotop
      dataset2=('40' 'SigmarOne-Regular' 'x=(w-text_w)/2:y=1035:fontsize=h/28' '55:620' )  #logo,teaser-bottom
      datasetCollection=( $(shuf -e "dataset0" "dataset1" "dataset2" ) ) 
      declare -n data="$datasetCollection"                                                 #for debug: data=("${dataset2[@]}")
      teaser_overlay=",drawtext=text='$teaser':fontcolor='#$themeTextColor':fontfile=${data[1]}:${data[2]}:bordercolor=yellow:borderw=2"

      ffmpeg -f lavfi -i color=c=0x$themeBackColor:duration=1:s=720x1080:r=1 \
             "$_temp/_tempbase.mp4" -y -loglevel error
      ffmpeg -ss 0 -i "$_temp/_tempbase.mp4" \
             -filter_complex "$ffmpeg_roundcorner$teaser_overlay" \
             -frames:v 1 -q:v 1 \
             "$_temp/_temproundteaser.png" -y -loglevel error; 

      rm -f "$_temp/_tempbase.mp4";

      for ((n=1; n<=$MAX_POSTERS; n++)); do
        Process_Message_Feedback 'POSTER_WORK' 'Working on poster image' $n $MAX_POSTERS
        ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_POSTERS*$n)-0.1" | bc)";  
		    if [ $(echo "scale=2;$ffmpeg_ssAt < 1.00" | bc ) -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
        ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" \
               -frames:v 1 -q:v 2 \
               "$_temp/_temp$n.png" -y -loglevel error
        ffmpeg -i "$_temp/_temproundteaser.png" -i "$_temp/_temp$n.png" -i "${f%.*}/Clearlogo.png" \
               -filter_complex "[1]scale=-1:970,crop=720:970:160:in_h,drawbox=x=0:y=0:w=720:h=990:color=$themeBackColor@1:t=20[still]; \
                                [2]scale=-1:404[logo]; \
                                [0][still]overlay=0:${data[0]}[partial]; \
                                [partial][logo]overlay=${data[3]}$inHDR_overlay" -q:v 1 \
               "$_temp/poster$n.png" -y -loglevel error
        rm -f "$_temp/_temp$n.png"
      done
      rm -f "$_temp/_temproundteaser.png" ;;
    esac
    pick_a_poster=$((2 % $MAX_POSTERS))
    mv "$_temp/poster$(echo "$pick_a_poster + 1" | bc).png" "${f%.*}/Poster.png"    
    Process_Message_Feedback 'POSTER_DONE' $n
	fi
  #End Poster Images


  #Background Images Begin
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
      Process_Message_Feedback 'BACKGROUND_WORK' 'Working on background image' $n $MAX_BACKDROPS
      #echo -ne "${RED}BACKDROPS   : ${NC}Now, working on backdrop ${YELLOW}$n${NC} of $MAX_BACKDROPS...\033[0K\r"
      ffmpeg_ssAt="$(echo "scale=2; ($ffprobe_duration/$MAX_BACKDROPS*$n)-0.1" | bc)";  if [ $(bc <<< "$ffmpeg_ssAt < 1.00") -eq 1 ]; then ffmpeg_ssAt='0'$ffmpeg_ssAt; fi
      ffmpeg -ss $ffmpeg_ssAt -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 2 -loglevel error "${f%.*}/backdrop$n.jpg" -y
    done
    Process_Message_Feedback 'BACKGROUND_DONE' $n
    #echo -e "${RED}BACKDROPS   : ${NC}$n images created. ${RED}DONE!${NC}           "
  fi
  #End Background Images

  #Begin Metadata
  if [[ ! "${typed_arguments,,}" == *"-nometa"* ]]; then 
    Process_Message_Feedback 'METAFILE_WORK' 'Now the editable metadata file...'
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
      trailer_element="<trailer>plugin://plugin.video.youtube/?action=play_video&amp;videoid=${TRAILER_IDS[${trailer[$COUNTER]}]}</trailer>"
    fi      
    printf "<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<movie>
  <title>${base_name[@]}</title>
  <originaltitle>${base_name[@]}</originaltitle>
  <rating>${rating[1]}</rating>
  <criticrating>${rating[2]}.${digit[2]}</criticrating> 
  <year>$((${decade[1]} + ${digit[1]}))</year>
  <mpaa>${MPAAS[${mpaa[$COUNTER]}]}</mpaa>
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
  $trailer_element
</movie>" > "${f%.*}/${base_name[@]}"'.nfo'
    Process_Message_Feedback 'METAFILE_DONE'
    #echo -e "${RED}DONE!${NC}"
  fi
  #End Metadata

  #Background Audio Begin
  if [[ ! "${typed_arguments,,}" == *"-nomusic"* ]] && [ $COUNTER -lt 6 ]; then
    Process_Message_Feedback 'THEME_WORK' ' Creating theme song (limited to 5)...'
    #echo -e -n "${RED}THEME AUDIO :${NC} Creating theme song (limited to 5)..."  
    output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/theme.mp3"  
    source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'  
    curl -o "$output_file" $source_url -s      
    Process_Message_Feedback 'THEME_DONE'
    #echo -e "${RED}DONE!${NC}\n"
  else
    echo -e "${RED}THEME AUDIO :${NC} ...${RED}SKIPPED!${NC}\n"  
  fi
  #End Background Audio

  echo  
  let COUNTER++
done
#End Richerize Process

#Summary
count=$(find "$1" -type f -name "*.jpg" | wc -l)
echo -e "SUMMARY: At least ${count} images aand other assets were created to enhance the user viewing experience.\n\n" 
#EOF
