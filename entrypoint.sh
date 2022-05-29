#!/bin/bash
set -e
# debugging 
echo "Debugging..."
echo $GITHUB_EVENT_PATH
echo "Github repository"
echo $GITHUB_REPOSITORY
echo "Execute first if statement ..."
if [ -n "$GITHUB_EVENT_PATH" ];
then
    echo "Executing the event_path variable below "
    EVENT_PATH=$GITHUB_EVENT_PATH
elif [ -f ./sample_push_event.json ];
echo "Executing elif "
then
    EVENT_PATH='./sample_push_event.json'
    LOCAL_TEST=true
else
    echo "No JSON data to process! :("
    exit 1
fi

env
jq . < $EVENT_PATH

# if keyword is found
if jq '.commits[].message, .head_commit.message' < $EVENT_PATH | grep -i -q "$*";
then
    # do something
    VERSION=$(date +%F.%s)

    DATA="$(printf '{"tag_name":"v%s",' $VERSION)"
    DATA="${DATA} $(printf '"target_commitish":"master",')"
    DATA="${DATA} $(printf '"name":"v%s",' $VERSION)"
    DATA="${DATA} $(printf '"body":"Automated release based on keyword: %s",' "$*")"
    DATA="${DATA} $(printf '"draft":false, "prerelease":false}')"

    URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases?access_token=${GITHUB_TOKEN}"

    if [[ "${LOCAL_TEST}" == *"true"* ]];
    then
        echo "## [TESTING] Keyword was found but no release was created."
    else
        echo "Using curl now"
        curl -X POST https://api/github.com/repos/$GITHUB_REPOSITORY/releases \
        -H 'Authorization: $GITHUB_TOKEN' \
        -H 'Content-Type: application/json'\
        -d $DATA
        echo $DATA | http POST $URL | jq .
    fi
# otherwise
else
    # exit gracefully
    echo "Nothing to process."
#     curl -X POST https://reqbin.com/echo/post/json
#    -H 'Content-Type: application/json'
#    -H 'Authorization: token my_access_token'
#    -d '{"login":"my_login","password":"my_password"}'
fi
