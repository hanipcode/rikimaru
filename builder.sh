#!/usr/bin/env bash
source ./trycatch.sh

export HOST_NAME="127.0.0.1";
export CUR_ENV="local";
export PM2_NAME
LOG_DESTINATION=log
COMMIT_MESSAGE="Default commit message from tool"
PUSH_TO="origin master"
SUCCESS_PREPARE=false


USAGE_MESSAGE=$(cat <<-EOF
Usage:
    $0 Options
Options:
    [-e <local|server>]
    [-h <string>]
    [-l log destinatinon <string>]
    [-p pm2 name <string>]
    [-m commit message <string>]
    [-t push to <string> example: "origin master"]
EOF
);

function usage() { echo "$USAGE_MESSAGE" 1>&2; exit 1; }

while getopts ":e:h:l:m:t:" opt; do
    case ${opt} in
        e)
            CUR_ENV=$OPTARG
        ;;
        h)
            HOST_NAME=$OPTARG
        ;;
        l)
            LOG_DESTINATION=$OPTARG
        ;;
        m)
            COMMIT_MESSAGE=$OPTARG
        ;;
        t)
            PUSH_TO=$OPTARG
        ;;
        *)
            usage
        ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${HOST_NAME}" ] || [ -z "${CUR_ENV}" ]; then
    usage
fi

function init_build_node_project_local() {
    yarn install;
    yarn  test;
    yarn  build;
}

function init_build_node_project_server() {
    npm install;
    npm run test;
    npm run build;
}

function prepare_local() {
    git status;
    git add '.';
    git commit -am "$COMMIT_MESSAGE";
    git push $PUSH_TO;
}

function build_node_project() {
    local CUR_ENV_NODE=$1;
    if [[ $CUR_ENV_NODE == "local" ]]; then
        init_build_node_project_local
        elif [[ $CUR_ENV_NODE == "server" ]]; then
        init_build_node_project_server
    else
        echo "INVALID ENVIRONMENT";
        usage;
        return 1;
    fi
}

function clean_log() {
    rm "$LOG_DESTINATION";
    touch "$LOG_DESTINATION";
}

clean_log;

# Script start from here
SUCCESS_PREPARE=true;
try
(
    prepare_local 2>&1 | tee -a $LOG_DESTINATION;
)
catch || (
    echo "GIT IS FAILED";
    SUCCESS_PREPARE=false;
)

if [[ $SUCCESS_PREPARE == "true" ]]; then
ssh $HOST_NAME  << EOF
    $(typeset -f);
    cd /var/www/collection-backend;
    build_node_project server;
EOF  2>&1>> $LOG_DESTINATION
fi