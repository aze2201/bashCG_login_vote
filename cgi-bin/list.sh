#!/bin/bash
 
echo "Content-type: text/html"
echo ""

echo " <!DOCTYPE html> "
echo " <html>          "
echo " <head>          "
# custom JS functions for Cookie
echo "<script src=\"../js/getsetcookie.js\"></script>"       
echo " </head>         "
echo " <body>          "

# extract Username (if more cookie set it could fail. Need to check parsing properly)
cookieUsername=$(echo ${HTTP_COOKIE} | awk -v FS='username=' '{print $2}')

# if cookie is set.
if [ ! -z "$cookieUsername"  ]; then
    echo "<center><H2>Hi $cookieUsername <br><br>
            Welcome to VOTE
            </H2><br>
            <h3>
    	      Please select the RADIO BUTTON on the image below and click on the SUBMIT button at the bottom of the page
           </h3>"
    echo  "<h1>Picture list: </h1><br>"
    
    # put all processing part into FORM
    echo "<FORM ACTION=/cgi-bin/voted.sh METHOD=POST >"
    for i in $(ls /home/muradovf/f/images/*.jpg); do
      echo "
        <div class=gallery>
          <img src=/images/$(basename ${i}) alt=Cinque Terre width=600 height=400>
          </a>
        </div>
        <div class=desc>$(basename ${i})</div>
        <INPUT TYPE=radio NAME=imagevoted VALUE=$(basename ${i})><BR>
        <hr>
      "
    done
    echo "<br>"
    echo "<input type=submit value=Submit>"
else
    echo "<h2>Please LOGIN</h2>"
	echo "<a href=\"http://192.168.1.x:8000/login.html\">Login page</a>"
fi


echo "</center>"
echo " </body>"
echo " </html>"
