#!/bin/bash


echo "Content-type: text/html"
echo 
echo "<script src=\"../js/getsetcookie.js\"></script>"   
cookieUsername=$(echo ${HTTP_COOKIE} | awk -v FS='username=' '{print $2}')

if [ "$REQUEST_METHOD" = POST ]; then
    query=$( head --bytes="$CONTENT_LENGTH" )
fi


mkdir /tmp/votef
#echo $query
imageVoted=$(echo ${query}| awk -v FS='imagevoted=' '{print $2}')

echo "$imageVoted" > /tmp/votef/$cookieUsername.voted
echo "
      <center>
	     <H1>Thank you.<br>Democracy wins</H1>
		 Current result is: <br><br><br>
		 count  | NAME<br>
		 $(cat  /tmp/votef/*.voted | sort | uniq -c |tr '\n' '#' | sed 's/#/<br>/g'| tr ' ' '|' | sed 's/||||||//g')
		 <br><br>
		 NOTE: <a href=\"http://192.168.1.195:8000/cgi-bin/list.sh\">You can change your vote or back to see list again</a>
      </center>"

exit 0