#!/bin/bash

the_name_of_the_author=""
the_title_of_the_page=""
the_title_of_the_website=""
the_url=""
the_date_that_the_url_was_accessed=""

initialize_the_attribute_of_the_url()
{
    attribute=$(echo $@ | cut -d' ' -f2-)
    if [ $1 = "--the_name_of_the_author" ]
    then
        the_name_of_the_author=$attribute
    elif [ $1 = "--the_title_of_the_page" ]
    then
        the_title_of_the_page=$attribute
    elif [ $1 = "--the_title_of_the_website" ]
    then
        the_title_of_the_website=$attribute
    elif [ $1 = "--the_url" ]
    then
        the_url=$attribute
    elif [ $1 = "--the_date_that_the_url_was_accessed" ]
    then
        the_date_that_the_url_was_accessed=$attribute
    fi
}

obtain_the_attributes_of_the_url()
{
    the_name_of_the_attribute=""
    attribute=""
    the_start_of_the_attribute=0
    the_end_of_the_attribute=0

    for var in $@
    do
	key=$(echo $var | cut -d'=' -f1)
	value=$(echo $var | cut -d'=' -f2)

	if [ $key = "--the_name_of_the_author" ]
	then
	    the_name_of_the_attribute=$key
	elif [ $key = "--the_title_of_the_page" ]
	then
	    the_name_of_the_attribute=$key
	elif [ $key = "--the_title_of_the_website" ]
	then
	    the_name_of_the_attribute=$key
	elif [ $key = "--the_url" ]
	then
	    the_name_of_the_attribute=$key
	elif [ $key = "--the_date_that_the_url_was_accessed" ]
	then
	    the_name_of_the_attribute=$key
	fi

	echo $value
	attribute="$attribute $value"

	if [[ $value == *"\""* ]]
	then
	    if [ $the_start_of_the_attribute -eq 0 ]
	    then
		the_start_of_the_attribute=1
		the_end_of_the_attribute=0
	    elif [ $the_start_of_the_attribute -eq 1 ]
	    then
		the_start_of_the_attribute=0
		the_end_of_the_attribute=1
	    fi 

	    if [ $the_end_of_the_attribute -eq 1 ]
	    then
	        initialize_the_attribute_of_the_url $the_name_of_the_attribute $attribute
	        attribute=""
	    fi
	elif [[ $the_name_of_the_attribute == "--the_url" ]]
	then
	    initialize_the_attribute_of_the_url $the_name_of_the_attribute $attribute
	    attribute=""
	fi
    done
}

create_the_IEEE_reference_of_the_url()
{
    echo "$the_name_of_the_author. \
	  \"$(echo $the_title_of_the_page | sed "s/ *$//g").\" \
	  $the_title_of_the_website. \
	  $the_url \
	  ($(echo $the_date_that_the_url_was_accessed | sed "s/ *$//g"))"
}

INPUT=$@
obtain_the_attributes_of_the_url $INPUT
the_IEEE_reference_of_the_url=$(create_the_IEEE_reference_of_the_url)
echo $the_IEEE_reference_of_the_url
