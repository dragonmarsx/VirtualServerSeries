#!/bin/bash
MAX_POSTERS=3
MAX_BACKDROPS=4
ACTORS=('Sara Hayek' 'Liza Taylor' 'Gina Close' 'Jimmy Chan' 'Lucho DiCaprio' 'Ant Banderas' 'Penelope Reyes')
ROLES=('the driver' 'the visitor' 'the stunt' 'the clown' 'the firefighter' 'the hero' 'secondary paper' 'the extra' 'ice cream seller' 'the who knows who')
STUDIOS=('Metro Golden Meyer' 'Univero Latino Studios' 'Paramount Entertainment')
DIRECTOR=('Dhina Marca' 'Elmer Curio' 'Esteban Dido' 'Elba Lazo' 'Elma Montt' 'Mario Neta' 'Yola Prieto')
SEARCH_TAGS=('Birthday' 'Beach' 'Dancing' 'Streets')
###############
SUPPORTED_EXT=("mkv" "mp4" "avi")
YELLOW='\033[1;33m'
RED='\033[0;33m'
NC='\033[0m' 

COUNTER=0;TOTAL_COUNTER=0
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
if [ $COUNTER -eq 0 ]; then echo -e "${RED}Error:${NC} Missing directory ${YELLOW}$1${NC}.\n"; exit 0; fi

TOTAL_COUNTER=$COUNTER
echo -e "=========================================================================="
echo -e "A total of "${RED}$TOTAL_COUNTER${NC}" file(s) will be moved inside ${YELLOW}$1."
echo -e "${NC}Each media file(s) will be moved inside its new folder.  Example:"
echo -e "FROM: "$old_f
echo -e "  TO: "$new_f
echo -e "__________________________________________________________________________"
echo -e "Valid arguments     : -noposter -noback -nologo -nometa -nomusic -backrgb"
echo -e "__________________________________________________________________________"
echo -e "${YELLOW}Press Enter key to continue OR Ctrl/Option +C to abort.${NC}"
read
if [[ $(whoami) -ne "root" ]]; then echo -e "Execute with root account privileges: ${YELLOW}su - ${NC}"; exit 0; fi
COUNTER=1
for f in "$1"/*; do
    [ -d "$f" ] && continue; 
    if [[ ! ${SUPPORTED_EXT[@]} =~ ${f##*.} ]]; then continue; fi
    new_f=${f%.*}/"$(basename -- "$f")"  #the new file absolute path
    ffmpeg_i=("$new_f")   	             #array of file names deals w/white spaces.
    new_f_array=("$new_f"); x1=${new_f_array[@]}; x2=${x1%.*}
    base_name=${x2##*/} 
    
    echo -e -n "${RED}("$COUNTER"of"$TOTAL_COUNTER")${NC} Moving ${YELLOW}"$(basename -- "$f")${NC}" to new folder..."
    mkdir -p "${f%.*}"
    cp -a "$f" "${f%.*}/"  #should be mv instead of cp
    echo -e "${RED}MOVED!${NC}"

    aroundBegining=( $(shuf -e 1 2 3) ) #random digit for 1 tenth, 1 quart or 1 third of the total length
    ffmpeg_ssMidFrameORIGINAL=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "$new_f")*0.5")")
    ffmpeg_ssMidFrame=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "$new_f")*0.${aroundBegining[0]}")")
    if [[ ! "${@:2}" == *"-noposter"* ]]; then
      echo -e -n "${RED}POSTERS     : ${NC}Creating main image poster..."
      mkdir -p "${f%.*}/_temp" 
      ffmpeg_vfPoster="crop=in_w/2:in_h,select='not(mod(n\,300))',setpts=N/TB"
      ffmpeg_vfScaled="crop=in_w/2:in_h,select='not(mod(n\,300))',setpts=N/TB,scale=-1:1080'"
      radius=30
      ffmpeg_rounded=",format=yuva420p,geq=lum='p(X,Y)':a='if(gt(abs(W/2-X),W/2-${radius})*gt(abs(H/2-Y),H/2-${radius}),if(lte(hypot(${radius}-(W/2-abs(W/2-X)),${radius}-(H/2-abs(H/2-Y))),${radius}),255,0),255)'"
      eval $(ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=height,width,nb_frames,duration,codec_name -sexagesimal "$f")        
      height=${streams_stream_0_height}
     
      ffmpeg -ss "${ffmpeg_ssMidFrame[@]}" -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfPoster$ffmpeg_rounded -frames:v 1 -q:v 5 -loglevel error "${f%.*}/poster.png" -y      
      echo -e -n "${RED}DONE!${NC}.  Creating more alternatives in _temp folder..."
      MIN_HEIGHT=500            
      if [ $MIN_HEIGHT -gt $height ]
      then   #Un Cu         
         ffmpeg -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfScaled$ffmpeg_rounded -r 1 -vframes $MAX_POSTERS -q:v 5 -loglevel error "${f%.*}/_temp/poster%01d.png" -y
      else  #Kim Fi
         ffmpeg -i "${ffmpeg_i[@]}" -vf $ffmpeg_vfPoster$ffmpeg_rounded -r 1 -vframes $MAX_POSTERS -q:v 5 -loglevel error "${f%.*}/_temp/poster%01d.png" -y
      fi
      echo -e "${RED}DONE!${NC}"   
	fi
        
    if [[ ! "${@:2}*" == *"-noback"* ]]; then
      echo -e -n "${RED}BACKDROPS   :${NC} Creating main backdrop image..."
      ffmpeg -ss $(bc -l <<< 'scale=2;'${ffmpeg_ssMidFrame}/2) -i "${ffmpeg_i[@]}" -vf "hue=s=3,scale=2160:-1" -frames:v 1 -loglevel error "${f%.*}/backdrop.jpg" -y 
      echo -e -n "${RED}DONE!${NC}.  Creating additional backdrops..."   
      if [[ "$*" == *"-backrgb"* ]]
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
          ffmpeg_ssAtFrame=("$(bc -l <<< "$(ffprobe -loglevel error -of csv=p=0 -show_entries format=duration "$f")*0.$n")") 
          ffmpeg -ss "${ffmpeg_ssAtFrame[@]}" -i "${ffmpeg_i[@]}" -vf "${ffmpeg_eqRandom[$n]},scale=2160:-1" -vframes 1 -q:v 5 -loglevel error "${f%.*}/backdrop$n.jpg" -y
          let n++
      done
      echo -e "${RED}DONE!${NC}"
    fi
    
    if [[ ! "${@:2}" == *"-nologo"* ]]; then
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
    
    if [[ ! "${@:2}" == *"-nometa"* ]]; then 
      echo -e -n "${RED}METAFILE    :${NC} Creating '${base_name[@]}.nfo' --a template XML metadata file..."
      rating=( $(shuf -e 7 8 9 10) )
      decade=( $(shuf -e 1980 1990 2000 2010 2020) ) 
      digit=( $(shuf -e 0 1 2 3 4 5 6 7 8 9) )
      mpaa=( $(shuf -e "TV-Y" "APPROVED" "TV-G" "PG-13" "PG-13" "R" "TV-MA") ) 
      genres=( $(shuf -e "Drama" "Thriller" "Romance" "Comedy" "Adventure" "Fiction" "Suspense" "Documentary" "Anime") )
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
          readarray -t plot < "$1/plots.txt"
      else
          plot=($default_plot)
      fi
      random_plot_text_line=($(shuf -i0-$(expr ${#plot[@]})))
      actor=$(shuf -n 1 -i1-$(expr ${#ACTORS[@]}) )
      role=$(shuf -n 1 -i1-$(expr ${#ROLES[@]}) )
      director=$(shuf -n 1 -i1-$(expr ${#DIRECTOR[@]}) )
      studio=$(shuf -n 1 -i1-$(expr ${#STUDIOS[@]}) )
      search_tag=$(shuf -n 1 -i1-$(expr ${#SEARCH_TAGS[@]}) )
      printf "<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<movie>
  <title>${base_name[@]}</title>
  <originaltitle>${base_name[@]}</originaltitle>
  <rating>${rating[1]}</rating>
  <criticrating>${rating[2]}.${digit[2]}</criticrating> 
  <year>$((${decade[1]} + ${digit[1]}))</year>
  <mpaa>${mpaa[1]}</mpaa>
  <dateadded>2021</dateadded>
  <tagline>Overview</tagline>
  <plot>${plot[$random_plot_text_line]}</plot>
  <actor>
    <name>${ACTORS[actor-2]}</name>
    <role>${ROLES[role-2]}</role>
  </actor>
  <actor>
    <name>${ACTORS[actor-1]}</name>
    <role>${ROLES[role-1]}</role>
  </actor>
  <director>${DIRECTOR[director-1]}</director>
  <genre>${genres[1]}</genre>
  <genre>${genres[2]}</genre>
  <studio>${STUDIOS[studio-1]}</studio>
  <tag>${SEARCH_TAGS[search_tag-1]}</tag>
  <tag>${SEARCH_TAGS[search_tag-2]}</tag>
</movie>" > "${f%.*}/${base_name[@]}"'.nfo'  #Rich Demo/Cancun Family Trip/Cancun Family Trip.nfo
      echo -e "${RED}DONE!${NC}"
    fi

    if [[ ! "${@:2}" == *"-nomusic"* ]] && [ $COUNTER -lt 5 ]; then      
        echo -e -n "${RED}THEME MUSIC :${NC} Creating optional theme song (Due to copyright, ONLY the first 5 folders)..."  
        output_file="$1"/${base_name[@]}"/theme.mp3"   #"Rich Demo/Cancun Family Trip/"  
        source_url='https://filesamples.com/samples/audio/mp3/sample'$COUNTER'.mp3'
        curl -o "$output_file" $source_url -s      
        echo -e "${RED}DONE!${NC}\n"
    fi
    echo
  
    let COUNTER++
done
count=$(find "$1" -type f -name "*.jpg" | wc -l)
echo -e "SUMMARY: At least ${count} images plus other assets were created to enhance the user viewing experience.\n\n" 

