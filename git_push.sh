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


# Prompt for a commit message
#read -p "Enter a commit message: " commit_message

# Add all changes to the staging area
git add .

# Commit the changes with the provided message
#git commit -m "$commit_message"
COMMIT_TIMESTAMP=`date +'%Y-%m-%d %H:%M:%S %Z'`
git commit -m "Automated commit on ${COMMIT_TIMESTAMP}"

# Push the changes to the remote repository
git push -uf


# Push the changes to kingsir.eu.org
#bash /c/Users/tkk/Documents/kingsir.eu.org/git_push.sh


# Push the changes to kingtam.eu.org
#bash /c/Users/tkk/Documents/kingtam.eu.org/git_push.sh

echo "Changes have been pushed successfully."
