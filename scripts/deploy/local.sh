#!/bin/bash
# To be executed from the root project directory.
# Installs R package locally and copies shiny resources from package 'shiny' directory to web application.
# Input parameters:
# -s [required] shiny webapp location where all shiny resources will be deployed
# -p [optional] app package location, not required when build script was executed and both 'latest.txt' and package itself are available in 'target' directory

#quitting on error
set -e

while getopts ":s:p:" opt; do
  case $opt in
    s) shiny_webapp_location="$OPTARG"
    ;;
    p) package_location="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "${shiny_webapp_location}" ]; then
    echo -s input parameter value with shiny webapp location was not provided!
    exit 1
fi

if [ -z "${package_location}" ]; then
    latest_txt_file_location='target/latest.txt'
    if [ -f "${latest_txt_file_location}" ]; then
	package_location=`pwd`/target/`cat ${latest_txt_file_location}`
    else
	echo ${latest_txt_file_location} file not found!
	exit 1
    fi
fi

echo got package_location parameter: ${package_location}
echo got shiny_webapp_location parameter: ${shiny_webapp_location}

#installing module in local system
R CMD INSTALL ${package_location}

#extracting shiny files to be copied to webapp
#first we should exract it to tmp dir, then remove current contents of webapp dir and copy new version
package_name=`tar -ztf ${package_location} | grep -o '^[^/]\+' | sort -u`
tmp_for_shiny=`mktemp -d /tmp/${package_name}.XXXXXX`
current_dir=`pwd`
cd ${tmp_for_shiny}

tar -zxvf ${package_location} ${package_name}/shiny
#removing previously deployed files
if [ -d "${shiny_webapp_location}" ]; then
    rm -r ${shiny_webapp_location}
fi
mkdir ${shiny_webapp_location}

#introducing new shiny files
cp -r ${tmp_for_shiny}/${package_name}/shiny/* ${shiny_webapp_location}
#cleanup
cd ${current_dir}
rm -r ${tmp_for_shiny}