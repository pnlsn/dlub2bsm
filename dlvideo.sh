FILENAME=$1
HTML=`pbpaste`
#HTML=`cat source.html`
WVIDEOID=`echo $HTML | sed -e 's/^.*?wvideo=//' | sed -e 's/\".*//'`
echo $WVIDEOID
EMBEDURL="https://fast.wistia.net/embed/iframe/"${WVIDEOID}"?videoFoam=true"
echo $EMBEDURL
JSON=`curl $EMBEDURL | grep -e 'iframeInit.' | sed -e 's/W.iframeInit(//' | sed -e 's/);//'`
#echo $JSON
ORIGINALDLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="Original file").url'`
A360PDLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="360p").url'`
A250PDLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="250p").url'`
A540PDLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="540p").url'`
A720PDLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="720p").url'`
echo "Original File link: ${ORIGINALDLURL}" | sed 's/\.bin/\.mp4/' >> ${FILENAME}_dl_urls.txt
echo "360p link: ${A360PDLURL}" | sed 's/\.bin/\.mp4/' >> ${FILENAME}_dl_urls.txt
echo "250p link: ${A250PDLURL}" | sed 's/\.bin/\.mp4/' >> ${FILENAME}_dl_urls.txt
echo "540p link: ${A540PDLURL}" | sed 's/\.bin/\.mp4/' >> ${FILENAME}_dl_urls.txt
echo "720p link: ${A720PDLURL}" | sed 's/\.bin/\.mp4/' >> ${FILENAME}_dl_urls.txt
curl -O $A720PDLURL
OUTPATH="./${FILENAME}.mp4"
mv *.bin $OUTPATH
echo "Successfully created file ${OUTPATH}"
