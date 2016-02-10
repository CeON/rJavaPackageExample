#!/bin/bash
# To be executed from the root project directory.
# Obtains R package from artifactory and executes local.sh script with package downloaded to temporary directory.
# Input arguments:
# -s [required] shiny webapp location where all shiny resources will be deployed
# -a [optional] artifactory root location where R packages are stored along with latest.txt file pointing to the most recent one
# -u [optional] user name to be authenticated against artifactory, set to currently logged in user if not provided
# -p [optional] R package bundle full name which should be retrieved from artifactory. To be provided when one don't want to deploy most recent package version.

#default artifactory root location, to be picket when location was not provided as input parameter
artifactory_root_default='http://maven.ceon.pl/artifactory/reachmeter-snapshots/pl/edu/icm/reachmeter/rJavaPackageExample/'

while getopts ":s:a:u:p:x:" opt; do
  case $opt in
    s) shiny_webapp_location="$OPTARG"
    ;;
    a) artifactory_root="$OPTARG"
    ;;
    u) user_name="$OPTARG"
    ;;
    p) package_location="$OPTARG"
    ;;
    x) password="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

#quitting on error
set -e

if [ -z "${artifactory_root}" ]; then
    artifactory_root=${artifactory_root_default}
    echo setting artifactory root to default value: ${artifactory_root}
fi

if [ -z "${user_name}" ]; then
    user_name=`whoami`
    echo setting artifactory user to current user: ${user_name}
fi

if [ -z "${password}" ]; then
    password_chunk='--ask-password'
else
    password_chunk='--password '$password
fi

if [ -z "${package_name}" ]; then
    if [ -z "${password}" ]; then
        echo enter artifactory password:
    fi
    package_name=`wget -O- --user=${user_name} ${password_chunk} ${artifactory_root}/latest.txt`
fi

working_dir=/tmp/${package_name}/$(date +%s)

if [ ! -d "${working_dir}" ]; then
    mkdir -p ${working_dir}
fi

echo downloading package: ${package_name} into tmp directory ${working_dir}

if [ -z "${password}" ]; then
    echo enter artifactory password:
fi
wget --user=${user_name} ${password_chunk} ${artifactory_root}/${package_name} -O ${working_dir}/${package_name}

#performing common local activities
#test this piece of code:
#obtained from: http://stackoverflow.com/questions/192292/bash-how-best-to-include-other-scripts

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. ${DIR}/local.sh -s ${shiny_webapp_location} -p ${working_dir}/${package_name}

#cleanup phase
rm -r ${working_dir}