#!/bin/bash
# To be executed from the root project directory.
# Installs R package locally and copies shiny resources to web application.
# Input parameters:
# -s [required] shiny webapp location where all shiny resources will be deployed
# -p [optional] app package location, not required when both target/latest.txt and package itself are available

while getopts ":s:p:" opt; do
  case $opt in
    s) shiny_webapp_location="$OPTARG"
    ;;
    p) package_location=="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

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

#quitting on error
set -e

package_name=`tar -ztf ${package_location} | grep -o '^[^/]\+' | sort -u`

tmp_for_shiny=/tmp/${package_name}_shiny_extr

#installing module in local system
sudo su - -c "R -e \"install.packages('${package_location}', repos=NULL, type = 'source')\""

#extracting version.txt and shiny files to be copied to  webapp
#first we should exract it to tmp dir, then remove current contents of webapp dir and copy new version
if [ -d "${tmp_for_shiny}" ]; then
    rm -r ${tmp_for_shiny}
fi
mkdir -p ${tmp_for_shiny}
cd ${tmp_for_shiny}

tar -zxvf ${package_location} ${package_name}/version.txt ${package_name}/shiny
#removing previously deployed files
if [ -d "${shiny_webapp_location}" ]; then
    rm -r ${shiny_webapp_location}
fi
mkdir ${shiny_webapp_location}

#introducing new shiny files and version.txt
cp -r ${tmp_for_shiny}/${package_name}/shiny/* ${shiny_webapp_location}
cp ${package_name}/version.txt ${shiny_webapp_location}
