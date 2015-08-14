## Dockerfile for gitit.
## Note that I have opted to install gitit from the Debian package rather than 
##   from Hackage. The Debian package is an older version of gitit but includes 
##   some preinstalled plugins.
FROM debian:jessie
MAINTAINER Paul LaMar <pal3@outlook.com>

## NOTE: Set LANG to C.UTF-8 which is the recommended
##       setting for Docker containers (not en_US.utf8).
ENV LANG C.UTF-8

# Some of the TeX Live packages configure front end dialogs and need $TERM set.
ENV TERM xterm

# Get the packages needed for gitit.
RUN apt-get update \
    && apt-get install -y --no-install-recommends mime-support git libjs-jquery tree \
    libjs-jquery-ui libghc-filestore-data graphviz texlive texlive-latex-extra gitit \
    && rm -rf /var/lib/apt/lists/*

# Add a user for running the gitit service.
RUN adduser --disabled-password  --gecos "Gitit,,," gitit

# Let gitit run on port 5001 of this container.
EXPOSE 5001

# Switch to gitit and set up the initialized wiki.
WORKDIR /home/gitit/

# Create the 'data' folder from a tar archive
ADD data.tar /home/gitit/
RUN chown -R gitit data

# Create the volume so that the wiki will persist.
VOLUME ["/home/gitit/data"]

# Use a shell script to start gitit. Parameters to the script will change 
#    the Git global user configuration.
COPY entrypoint.sh /home/gitit/entrypoint.sh

# Switch to the gitit user
USER gitit

# Specify values for the first Git commits that gitit may perform. These can be overridden
#    when the container is started.
RUN git config --global user.name "Gitit" && git config --global user.email "gitit@dummy.aaa"

ENTRYPOINT ["/home/gitit/entrypoint.sh"]

