
#!/bin/bash
clear
if [ -z "$1" ]
then
    echo "Git commit details for $PWD"
    git remote show origin -n | grep "Fetch URL"
    git log --pretty=oneline
    exit 0
fi
# show file details
git log --follow $1
if [ $? -ne 0 ]; then
    echo "There was an error getting GIT data"
    exit 1
fi
exit 0 # all good
