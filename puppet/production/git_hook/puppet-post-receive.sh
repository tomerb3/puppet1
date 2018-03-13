#!/bin/bash
#This need to be on the git server where the on /opt/stash-hooks
usage () {
    echo "This script convert the Git branches in puppet environment using SSH"
    echo "Usage:"
    echo "$0 -d <destination server> -f <environment folder> -r <the Git repo URL> -u <user> -i <path to ssh key>"
    exit 0
}

if [ "$#" -ne 10 ]; then
    echo "Error: Illegal number of parameters"
    usage
fi
while getopts "h:d:f:r:i:u:" opt; do
    case $opt in
        h)
            usage
            ;;
        d)
            DESTSERVER=$OPTARG
            ;;
        f)
            FOLDER=$OPTARG
            ;;
        r)
            REPO=$OPTARG
            ;;
        u)
            USER=$OPTARG
            ;;
        i)
            SSHKEY=$OPTARG
            ;;

        *)
            usage
            ;;
    esac
done
#debug:
#echo "destenation server: $DESTSERVER"
#echo "env folder: $FOLDER"
#echo "remote user: $USER"
#echo "ssh key:$SSHKEY"
#echo "Git repo: $REPO"

read oldrev newrev refname

REPOSITORY=$REPO
#REPOSITORY="/opt/git/puppet.git"
BRANCH=$( echo "${refname}" | sed -n 's!^refs/heads/!!p' )
#ENVIRONMENT_BASE="/tmp/puppet/environments"
ENVIRONMENT_BASE=$FOLDER

# master branch, as defined by git, is production
if [[ "${BRANCH}" == "production" ]]; then
    ACTUAL_BRANCH="production"
else
    ACTUAL_BRANCH=${BRANCH}
fi

# newrev is a bunch of 0s
echo "${newrev}" | grep -qs '^0*$'
if [ "$?" -eq "0" ]; then
    # branch is marked for deletion
    if [ "${ACTUAL_BRANCH}" = "production" ]; then
        echo "No way!"
        exit 1
    fi
    ssh -i $SSHKEY ${USER}@${DESTSERVER} "/usr/bin/pupdate.sh -d ${ENVIRONMENT_BASE} -r ${REPO} -b ${ACTUAL_BRANCH} -a delete"
else
    ssh -i $SSHKEY ${USER}@${DESTSERVER} "/usr/bin/pupdate.sh -d ${ENVIRONMENT_BASE} -r ${REPO} -b ${ACTUAL_BRANCH} -a update"
fi
exit 0
