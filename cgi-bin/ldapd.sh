#!/bin/bash

#echo "Set-Cookie: name=F"
echo "Content-type: text/html"
echo 


echo "<script src=\"../js/getsetcookie.js\"></script>"       


if [ "$REQUEST_METHOD" = POST ]; then
    query=$( head --bytes="$CONTENT_LENGTH" )
fi

normalized=$(printf ${query//%/\\x})
username=$(echo ${normalized}| awk -v FS='username=' '{print $2}'| awk -v FS='&' '{print $1}')
password=$(echo ${normalized}| awk -v FS='password=' '{print $2}')

sleep 1s

ldapsearch -x -D "uid=$username,ou=Staff,ou=Users,dc=ops,dc=incuda,dc=com" -h 192.168.1.85 -w  $password  > /dev/null
EXITCODE=$?

if [[ ${EXITCODE} -eq 0 ]]; then
	echo "$(date +%Y%m%d%H%M)|$username" > /tmp/$username.login
    echo "<script>setCookie(\"username\", \"$username\", 30);</script>"
	echo "<META HTTP-EQUIV=Refresh CONTENT=\"1; URL=http://192.168.1.195:8000/cgi-bin/list.sh\">"
	#env
	#echo ${HTTP_COOKIE[@]}
else
    echo "Auth failed"
    exit ${EXITCODE}
fi
