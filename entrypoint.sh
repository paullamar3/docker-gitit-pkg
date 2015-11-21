#!/bin/bash
## From this entrypoint we can either initialize a brand new
## Gitit wiki, copy in an existing wiki or clone an existing wiki.

# If no parameters then just run Gitit
if [[ -z "$1" ]] ; then
  cd /home/gitit/data
  echo "     --------------------------"
  echo "Documentation for this container is contained in the Gitit wiki."
  echo "A copy of the documentation is at https://github.com/paullamar3/docker-gitit-pkg."
  echo "     --------------------------"
  echo " "
  exec gitit -f gitit.conf
  exit
# If "copy" then copy the working directory, add and commit
elif [[ "${1,,}" = "copy" ]]; then
  cd /home/gitit/
  # Note that by specifying "init/*" we avoid copying hidden files
  # and folders. This is important; we don't want to copy over the 
  # ".git" folder.
  cp -rf init/* data/wikidata/
  cd /home/gitit/data/wikidata
  git add .
  git commit -m "Initializing wiki from copy."
  exit
# If "clone" then remove any existing repo and clone a new repo
elif [[ "${1,,}" = "clone" ]]; then
  cd /home/gitit/data/wikidata
  rm -rf *
  rm -rf ./.git
  git clone /home/gitit/init ./
  # Gitit repos need to be able to accept pushes on the currently
  # checked out branch.
  git config receive.denyCurrentBranch ignore
  exit
elif [[ "${1,,}" = "utils" ]]; then
  cp -r /home/gitit/utils /home/gitit/host/
# If "expcopy" then export a copy of the wiki
elif [[ "${1,,}" = "expcopy" ]]; then
  cp -rf /home/gitit/data/wikidata/* /home/gitit/export/
# If "expclone" then export a clone of the wiki repo
elif [[ "${1,,}" = "expclone" ]]; then
  cd /home/gitit/export/
  git clone /home/gitit/data/wikidata  "./$(date +"%j%H%M")"
fi

