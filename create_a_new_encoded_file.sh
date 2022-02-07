#!/bin/bash

echo "create_a_new_encoded_file.sh"

if [ "$#" -ne 1 ]
then
    echo "string absent"
    exit
fi

STRING=$1
encoded_string=$(echo "$STRING" | base64)
decoded_string=$(echo "$encoded_string" | base64 --decode)
vim "${encoded_string:0:55}".txt
echo "${encoded_string:0:55}"
echo $decoded_string
