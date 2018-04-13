#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..

curl -X DELETE "https://api.cloudflare.com/client/v4/zones/a6329df49960fb45b6999fd2450d5d53/purge_cache" \
     -H "X-Auth-Email: william.hng@outlook.com" \
     -H "X-Auth-Key: 23bd88336beaee810d6c9871919e28e5a5f11" \
     -H "Content-Type: application/json" \
     --data '{"purge_everything":true}'
