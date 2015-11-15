#!/bin/bash
## A wrapper for the `docker run` command for a new Gitit container.

# First we set up our default values
cname="gitit_$(date +"%j%H%M")"           # Container Name
port='80'                                 # Host port
action=""                                 # Default action
cinit=""                                  # Container to initialize
dir="./"                                  # Default host folder for init

# Now we parse our options
while getopts ":n:p:x:i:d:" opt; do
  case $opt in
    n) 
      cname="$OPTARG"
      ;;
    p) 
      port="$OPTARG"
      ;;
    x) 
      action="$OPTARG"
      ;;
    i)
      cinit="$OPTARG"
      ;;
    d)
      dir="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >$2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

echo "cname = $cname, port = $port, action = $action, cinit = $cinit, dir = $dir"

if [[ "$action" = "" ]]; then
  # echo "docker run -it --name "$cname" -p "$port:5001" -v /home/gitit/data/  paullamar3/gitit-pkg:v0.9"
  set -x
  docker run -d --name "$cname" -p "$port:5001" -v /home/gitit/data/  paullamar3/gitit-pkg:v0.9
  set +x
else
  # echo "docker run -it --name "$cname" --volumes-from "$cinit" -v "$dir:/home/gitit/init" paullamar3/gitit-pkg:v0.9 "$action" "
  set -x
  docker run -it --name "$cname" --volumes-from "$cinit" -v "$dir:/home/gitit/init" paullamar3/gitit-pkg:v0.9 "$action"
  docker rm -v "$cname"
  set +x
fi


