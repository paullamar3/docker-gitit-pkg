
## Dockerfile for gitit.
## Note that I have opted to install gitit from the Debian package rather than 
##   from Hackage. The Debian package is an older version of gitit but includes 
##   some preinstalled plugins.
FROM debian:jessie
MAINTAINER Paul LaMar <pal3@outlook.com>

## NOTE: The haskell image sets LANG to C.UTF-8 which is the recommended
##       setting for Docker containers (not en_US.utf8).

# Some of the TeX Live packages configure front end dialogs and need $TERM set.
ENV TERM xterm

# Get the packages needed for gitit.
RUN apt-get update \
    && apt-get install -y --no-install-recommends mime-support git libjs-jquery \
    libjs-jquery-ui libghc-filestore-data graphviz texlive texlive-latex-extra gitit \
    && rm -rf /var/lib/apt/lists/*

##VOLUME ["/data"]

EXPOSE 5001

CMD /bin/bash

