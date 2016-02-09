#!/bin/bash

#installing package locally and copying shiny resources to web application

package_location=$1		#[required] app package location
shiny_webapp_location=$2	#[required] shiny webapp location

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
