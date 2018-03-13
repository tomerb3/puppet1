#!/bin/bash
#This script need to be located on the puppet master server at /usr/bin
usage () {
    echo "This script convert the Git branches in puppet environment"
    echo "Usage:"
    echo "$0 -d <destination folder> -b <brnach> -r <the Git repo URL> - a <action:delet/update/create>"
    exit 0
}

if [ "$#" -ne 8 ]; then
    echo "Error: Illegal number of parameters"
    usage
fi
while getopts "h:d:b:r:a:" opt; do
    case $opt in
        h)
            usage
            ;;
        d)
            FOLDER=$OPTARG
            ;;
        r)
            REPO=$OPTARG
            ;;
        b)
            BRANCH=$OPTARG
            ;;
        a)
            ACTION=$OPTARG
            ;;
        *)
            usage
            ;;
    esac
done

#debug:
echo "env folder: $FOLDER"
echo "Git repo: $REPO"
echo "Git branch: $BRANCH"
echo "Action is : $ACTION"


read oldrev newrev refname

REPOSITORY=$REPO
ENVIRONMENT_BASE=$FOLDER

if [ ${ACTION} == 'delete' ];
    then
        # branch is marked for deletion
        if [ "${BRANCH}" = "production" ]; then
            echo "No way!"
            exit 1
        fi
    echo "Deleting puppet env ${BRANCH}"
    cd ${ENVIRONMENT_BASE}
    rm -rf ${BRANCH}
else
    if [ -d "${ENVIRONMENT_BASE}/${BRANCH}" ];
    then 
	echo "Updating pupet env ${BRANCH}"
        cd ${ENVIRONMENT_BASE}/${BRANCH}
	/usr/bin/git fetch --all
	/usr/bin/git reset --hard origin/${BRANCH}
    else 
	echo "Creating pupet env ${BRANCH}"
        cd ${ENVIRONMENT_BASE}
	/usr/bin/git clone ${REPOSITORY} ${BRANCH} --branch ${BRANCH}
    fi
fi

exit 0
