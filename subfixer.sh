#!/bin/bash

#foreach argument as var do these
for var in "$@"
do
	#this variable contains address of dir before filename
	address=""
	
	#this variable contains just filename
	filename=""
	
	#taking address and filename apart
	for (( i=0; i<"${#var}"; i++ )); do
		if [ "${var:$i:1}" != '/' ]; then
			filename+="${var:$i:1}"
		else
			address+="$filename"
			address+='/'
			filename=""
		fi
	done
	
	#make a directory for fixed subtitles
	mkdir -p "${address}FixedSubtitles"
	
	#finding out current file encoding
	encode="$(file --mime-encoding -b "$var")"
	if [ "$encode" == "unknown-8bit" ]; then
		encode="WINDOWS-1256"
	fi
	
	#do conversion with iconv
	iconv -f "$encode" -t UTF-8 "$var" --output "${address}FixedSubtitles/$filename"

	#removing some bad chars and tags
	sed s/ي/ی/g -i "${address}FixedSubtitles/$filename"
	sed s/ك/ک/g -i "${address}FixedSubtitles/$filename"
	sed s/\<i\>/""/g -i "${address}FixedSubtitles/$filename"
 	sed s/\<\\/i\>/""/g -i "${address}FixedSubtitles/$filename"
done