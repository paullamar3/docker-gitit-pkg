#!/bin/bash

## The first argument is the name to use for git commits;
## the second is the email associated with that name;
## the third argument, if provided, is an existing git
## repository we want to use to initialize the container.

if [ -n "$1" ]
then 
  git config --global user.name "$1"
fi

if [ -n "$2" ]
then 
  git config --global user.email "$2"
fi

if [ -n "$3" ]
then 
  rm -rf /home/gitit/data/wikidata/*
  cd /home/gitit/data
  git clone "$3" wikidata
fi

cd data
gitit -f gitit.conf
exit

