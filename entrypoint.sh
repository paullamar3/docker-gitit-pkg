
#!/bin/bash
if [ -n "$1" ]
then 
  git config --global user.name "$1"
fi

if [ -n "$2" ]
then 
  git config --global user.email "$2"
fi

cd data
exec gitit

