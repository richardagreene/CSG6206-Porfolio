
#!/bin/bash
clear
if [ -z "$1" ]  # there is no parameter
then
    echo "Git commit details for $PWD"
    git remote show origin -n | grep "Fetch URL"
    git log --pretty=oneline
    count=$(git rev-list --all --count -- $1)
    printf "Total Commits: $count \n"
    exit 0
fi
# show file details Author and Comment
echo "Checking Git commit details for $1"
if [ ! -f "$1" ]  # file check
then
    echo "Error: File $1 does not exists"
    exit 1
fi
git log -1 --format='Author: %aN - %s' --follow $1
count=$(git rev-list --all --count -- $1)
printf "Total Commits: $count \n"
exit 0 # all good so exit