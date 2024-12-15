#!/bin/bash

mkdir -p parsed_headers
mkdir -p parsed_bodies

parse_headers(){
	find . -type f -name "*.headers" -exec grep -n "$1" {} + >> parsed_headers/${2}.txt
}



find . -type f -name "*.body" | html-tool tags title >> parsed_bodies/titles.txt



parse_headers "X-Powered-By" "poweredby"
parse_headers "Server" "Server"
parse_headers "Location" "location-redirect"
parse_headers "Access-Cntrol-Allow-Origin" "ACAO"


