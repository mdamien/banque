#!/bin/bash

cd $(dirname $0)/..

. config/config.inc

boobank -f csv list | sed 's/^[0-9]*EUR@//' | sed 's/,/./g' | sed 's/;/,/g' > data/list.csv
boobank history -f csv $BANKID | sed 's/^[0-9]*@//' | sed 's/,/./g' | sed 's/;/,/g' > data/.history.csv
cat data/history.csv data/.history.csv | sort -ur > data/history.csv

git add data/list.csv data/history.csv
if ! test "$1" = "nocommit" && git commit -m "update bank situation" > /dev/null ; then
	git pull origin master
	git push origin master
fi
