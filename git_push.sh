#!/bin/bash

# Check if the working directory is a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "This script must be run inside a Git repository."
    exit 1
fi

# Check for untracked and modified files
if git diff-index --quiet HEAD --; then
    echo "No changes detected. Exiting."
    exit 0
fi

###=== Rsync to Other Domain Folders
# Rsync contents to kingsir.eu.org
cp -rp ./content/* ../kingsir.eu.org/content/

# Rsync static to kingsir.eu.org
cp -rp ./static/* ../kingsir.eu.org/static/

# Rsync contents to kingtam.eu.org
cp -rp ./content/* ../kingtam.eu.org/content/

# Rsync static to kingtam.eu.org
cp -rp ./static/* ../kingtam.eu.org/static/
###=== Rsync complete


# Prompt for a commit message
#read -p "Enter a commit message: " commit_message

# Add all changes to the staging area
git add .

# Commit the changes with the provided message
#git commit -m "$commit_message"
COMMIT_TIMESTAMP=`date +'%Y-%m-%d %H:%M:%S %Z'`
git commit -m "Automated commit on ${COMMIT_TIMESTAMP}"

# Push the changes to the remote repository
git push -f


# Push the changes to kingsir.eu.org
#bash /c/Users/tkk/Documents/kingsir.eu.org/git_push.sh


# Push the changes to kingtam.eu.org
#bash /c/Users/tkk/Documents/kingtam.eu.org/git_push.sh

echo "Changes have been pushed successfully."
