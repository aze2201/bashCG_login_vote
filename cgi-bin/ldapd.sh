#!/bin/bash

echo "Content-type: text/html"
echo 

# load custom JS for manage cookie
echo "<script src=\"../js/getsetcookie.js\"></script>"       

# currently processing POST only. 
if [ "$REQUEST_METHOD" = POST ]; then
    query=$( head --bytes="$CONTENT_LENGTH" )
fi

# this is decode html to UTF
normalized=$(printf ${query//%/\\x})
username=$(echo ${normalized}| awk -v FS='username=' '{print $2}'| awk -v FS='&' '{print $1}')
password=$(echo ${normalized}| awk -v FS='password=' '{print $2}')

# wait load DOM
sleep 1s

ldapsearch -x -D "uid=$username,ou=xxx,ou=xxx,dc=xxx,dc=xxx,dc=xxx" -h 192.168.1.x -w  $password  > /dev/null
EXITCODE=$?

if [[ ${EXITCODE} -eq 0 ]]; then
	echo "$(date +%Y%m%d%H%M)|$username" > /tmp/$username.login
        echo "<script>setCookie(\"username\", \"$username\", 30);</script>"
	echo "<META HTTP-EQUIV=Refresh CONTENT=\"1; URL=http://192.168.1.x:8000/cgi-bin/list.sh\">"
	#env
	#echo ${HTTP_COOKIE[@]}
else
    echo "Auth failed"
    exit ${EXITCODE}
fi
