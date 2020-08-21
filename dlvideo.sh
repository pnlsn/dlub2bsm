DIR=$1
FILENAME=$2
HTML=`pbpaste`
#HTML=`cat source.html`
WVIDEOID=`echo $HTML | sed -e 's/^.*?wvideo=//' | sed -e 's/\".*//'`
echo $WVIDEOID
EMBEDURL="https://fast.wistia.net/embed/iframe/"${WVIDEOID}"?videoFoam=true"
echo $EMBEDURL
JSON=`curl $EMBEDURL | grep -e 'iframeInit.' | sed -e 's/W.iframeInit(//' | sed -e 's/);//'`
echo 'JSON'
DLURL=`echo $JSON | jq -r '.assets[] | select(.display_name=="250p").url'`
echo $DLURL
curl -O $DLURL
OUTPATH="./${DIR}/$FILENAME.mp4"
mv *.bin $OUTPATH
echo "Successfully created file ${OUTPATH}"