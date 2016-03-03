#!/bin/bash
# To be executed from the root project directory.
# Obtains R package from remote repostitory and executes local.sh script with package downloaded to temporary directory.
# Input arguments:
# -s [required] shiny webapp location where all shiny resources will be deployed
# -a [required] repository root location where R packages are stored along with latest.txt file pointing to the most recent package version
# -u [optional] user name to be authenticated against repository, set to currently logged in system user if not provided
# -p [optional] R package bundle full file name which should be retrieved from repository. To be provided when one does't want to deploy most recent package version.
# -x [optional] repository password, to be provided when script is executed in an automated way   

#quitting on error
set -e

while getopts ":s:a:u:p:x:" opt; do
  case $opt in
    s) shiny_webapp_location="$OPTARG"
    ;;
    a) repository_root="$OPTARG"
    ;;
    u) user_name="$OPTARG"
    ;;
    p) package_file_name="$OPTARG"
    ;;
    x) password="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ -z "${shiny_webapp_location}" ]; then
    echo -s required input parameter value with shiny webapp location was not provided!
    exit 1
fi

if [ -z "${repository_root}" ]; then
    echo -a required input parameter value with repository root location was not provided!
    exit 1
fi

if [ -z "${user_name}" ]; then
    user_name=`whoami`
    echo setting repository user to current user: ${user_name}
fi

if [ -z "${password}" ]; then
    password_chunk='--ask-password'
else
    password_chunk='--password '$password
fi

if [ -z "${package_file_name}" ]; then
    if [ -z "${password}" ]; then
        echo enter repository password:
    fi
    package_file_name=`wget -O- --user=${user_name} ${password_chunk} ${repository_root}/latest.txt`
fi

working_dir=`mktemp -d /tmp/${package_file_name}.XXXXXX`

echo downloading package: ${package_file_name} into tmp directory ${working_dir}

if [ -z "${password}" ]; then
    echo enter repository password:
fi
wget --user=${user_name} ${password_chunk} ${repository_root}/${package_file_name} -O ${working_dir}/${package_file_name}

#Deploy package locally using another script from the same directory
#(the same directory is determined following advice from http://stackoverflow.com/a/12694189/817499 )

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
${DIR}/local.sh -s ${shiny_webapp_location} -p ${working_dir}/${package_file_name}

#cleanup phase
rm -r ${working_dir}