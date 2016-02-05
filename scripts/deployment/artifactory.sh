#!/bin/bash

#obtaining package from artifactory and performing local.sh with obtained package

working_dir=$1			#[required] working directory location
shiny_webapp_location=$2	#[required] shiny webapp location
artifactory_root=$3		#[required] artifactory root location
user_name=$4			#[optional] user name to be authenticated against artifactory, set to current user if not provided
package_name=$5			#[optional] artifact package name

if [ -z "${user_name}" ]; then
    user_name=`whoami`
    echo setting artifactory user to current user: ${user_name}
fi

if [ -z "${package_name}" ]; then
    echo enter artifactory password:
    package_name=`wget -O- --user=${user_name} --ask-password ${artifactory_root}/latest.txt`
fi

if [ ! -d "${working_dir}" ]; then
    mkdir -p ${working_dir}
fi

echo downloading package: ${package_name}
echo enter artifactory password:
wget --user=${user_name} --ask-password ${artifactory_root}/${package_name} -O ${working_dir}

#performing common local activities
#test this piece of code:
#obtained from: http://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. ${DIR}/local.sh ${working_dir}/${package_name} ${shiny_webapp_location}