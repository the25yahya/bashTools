#!/bin/bash


redirect_regex="[\?&](redirect|redirecturl|returnurl|url|next|continue)=[^&]*"
idor_regex="[\?&]([a-zA-Z]*user[a-zA-Z]*|id|account|profile|member|uid)=[^&]*|[\?&][^=]+=[0-9]+"
traversal_regex='[?&]([a-zA-Z0-9_-]*(path|dir|file|folder|doc|location|url)[a-zA-Z0-9_-]*?)='
tokens_regex='[?&]([a-zA-Z0-9_-]*(token|auth|apikey|key|session|access|id|secret|jwt|bearer|cred|password|pw)[a-zA-Z0-9_-]*?)=[^&]+'
ports_regex='https?://[a-zA-Z0-9.-]+(:[0-9]{1,5})'
path_params_regex='/[a-zA-Z0-9_-]+/[0-9]+'
url_fragements_regex='https?://[^\s#]+#[^\s]*'
sqli_regex='(\?|&)(id|user|username|password|email|search|query|page|limit|offset|sort|order|category|product|type|amount|status|action|date|time|url|token|auth|session|cart|comment|item)=([^&\s]*)("|\%27|--|;|select|union|insert|drop|update|delete|exec|or|and|like|having|limit|database|column|tables|information_schema|mysql|group|order|into|from|where|join|show|count|char|benchmark)'
debug_regex='(\?|&)(debug|test|show|trace|verbose|debugging|dev|status|info|error|log)=\d*'
file_handling_regex='(\?|&)(file|action|upload|process|path|target|filename|fileurl|image|document|data|resource|attachment|fileupload)=\S*'

mkdir parsedurls
# Loop through the file and process each line
while read line || [ -n "$line" ]; do
    # Check for matches and append to corresponding files
    if [[ "$line" =~ $redirect_regex ]]; then
        echo "$line" >> parsedurls/redirect.txt
    fi
    if [[ "$line" =~ $idor_regex ]]; then
        echo "$line" >> parsedurls/idor.txt
    fi
    if [[ "$line" =~ $traversal_regex ]]; then
        echo "$line" >> parsedurls/traversal.txt
    fi
    if [[ "$line" =~ $tokens_regex ]]; then
        echo "$line" >> parsedurls/tokens.txt
    fi
    if [[ "$line" =~ $ports_regex ]]; then
        echo "$line" >> parsedurls/ports.txt
    fi
    if [[ "$line" =~ $path_params_regex ]]; then
        echo "$line" >> parsedurls/path_params.txt
    fi
    if [[ "$line" =~ $url_fragements_regex ]]; then
        echo "$line" >> parsedurls/url_fragments.txt
    fi
    if [[ "$line" =~ $sqli_regex ]]; then
        echo "$line" >> parsedurls/sqli.txt
    fi
    if [[ "$line" =~ $debug_regex ]]; then
        echo "$line" >> parsedurls/debug.txt
    fi
    if [[ "$line" =~ $file_handling_regex ]]; then
        echo "$line" >> parsedurls/file_handling.txt
    fi
done < ${1:-/dev/stdin}
