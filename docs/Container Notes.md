# The Gitit-pkg Container

This default wiki is packaged with the *Docker* image `paullamar3/gitit-pkg`.
This wiki was created by adding this page (and the pages referenced on this
page) to the standard default wiki created by the *Debian* *Gitit* package.

The `paullamar3/gitit-pkg` image comes with a set of utility scripts designed
to facilitate migrating wikis to and from their containers. These scripts also
provide useful examples of the various ways the container can be utilized. What
follows are instructions for installing these scripts and a description of
their uses. This necessarily includes information about the underlying image,
its design and the reasoning behind those design choices.

This page (and the pages it references) can be treated as a reference rather
than a linear text. You can jump to the section you are interested in; you
don't have to read from beginning to end. Some readers might find value in all
of the sections but most readers will likely only read two or three sections.

## Container Usage

This container was designed so that someone with a rudimentary knowledge of
*Docker Engine* could easily instantiate a running *Gitit* wiki without having
to reference any documentation specific to this image. Thus it is perfectly
acceptable to use the following command to instantiate a new container:

`docker run -p 80:5001 paullamar3/gitit-pkg:v0.10`

This will print the following text in the console:

```

          --------------------------
     Documentation for this container is contained in the Gitit wiki.
     A copy of the documentation is at
     https://github.com/paullamar3/docker-gitit-pkg.
          --------------------------

```

This message reminds the user that documentation for the container is available
here (inside the *Gitit* wiki) or via the public `paullamar3/docker-gitit-pkg`
at *GitHub*. The new container's wiki would be viewable from any web browser by
simply typing `localhost` into the address bar.

Note that this person must use a `docker stop` command (from another shell
prompt) to stop the *Gitit* container.

If your only goal is to "spin up" new *Gitit* wikis then you need read no
further. (However I recommend installing the utility scripts and making use of
at least `dgititrun`. It provides a slightly easier way to generate new
containers with empty wikis.) The following sections describe how the container
tries to make itself amenable to performing certain maintenance related tasks
like initializing a container with a pre-existing wiki or exporting the wiki in
the container to a host folder.

## Installing the utility scripts

> NOTE: This section describes how to install the utility scripts inside the
*Docker* image. These scripts should also be available via *GitHub* in the
`paullamar3/docker-gitit-pkg` project.

To install the utility scripts for this container into the current working
directory run the following:

` docker run --rm -v "$PWD:/home/gitit/host" paullamar3/gitit-pkg:v0.10 utils`

*Docker* will spin up a new container and copy the utility scripts into a
`utils` subdirectory in the current working directory.

Of course you can alter the `$PWD:` part of the `-v` string so that the `utils` folder can be
created in any folder of your choice. However there is no way to change the
name of the `utils` folder itself. (Do *not* confuse the `utils` at the end of
the command for the name of the subdirectory. The last word in the command
above is interpreted by the container's `entrypoint.sh` as the *action to
perform*.)

Inside `utils` will be the following files:

* `dgexportclone`
* `dgexportcopy`
* `dgfromclone`
* `dgfromcopy`
* `dgititrun`
* `dgtest`
* `dgtestwiki.tar`
* `testresults_v0.10.tar`

Five of these are utility scripts. It is worth noting that all of these utility
scripts support a `-h` parameter that provides limited usage information. One
is a very crude "testing script" that I use to perform a very limited and crude
regression test when I make changes.  One is an archive containing a "test
wiki" that is used by the test script. The last file is an archive containing
the successful test results generated for this version.


## dgititrun: The script beneath them all

While the `dgititrun` script is the foundation on which the other
scripts are built, it is not normally used. Instead the other four utility
scripts provide easier to use "wrappers" for `dgititrun`. In fact the only
normal use for `dgititrun` is for spinning up a new *Gitit* wiki with nothing
but these default pages in it. Below are two examples of how `dgititrun` would
normally be used.

To create and start a new *Gitit* container using a default name and
attaching to the host's port 80:

`./dgititrun`

To create and start a new *Gitit* container using a specific name ("henry") and
a specific port (8080) use:

`./dgititrun -n henry -p 8080`

All other tasks (like exporting a wiki from a container or creating and
initializing the wiki for a new container) would normally be performed by one
of the other utility scripts. This means that you can skip the remaining
description of the `dgititrun` script unless you are interested in the
"plumbing" inside the script.

### On-line help

The `dgititrun` script is a quick and relatively easy way to interact with the
`paullamar3/gitit-pkg` image. Its on-line help reads as follows:

```

dgititrun [-h] [-n NAME] [-p PORT] [-i INIT] [-d PATH] [-x ACTION]

This script provides a convenience wrapper for the 'docker run' command when
using the paullamar3/gitit-pkg image.

    -h                 Displays this help message.
    -n NAME            The name to assign to the container.
    -p PORT            The host port that Gitit will connect to.
    -i INIT            The name of the container to initialize.
    -d PATH            The folder containing the initialization wiki.
    -x ACTION          The action to perform. 

For detailed documentation execute the following to start a Gitit container:
  ./dgititrun 

Attach to the Gitit instance by using a browser to connect to 'localhost'. The 
default Gitit wiki contains pages describing this container image and these
utility shell scripts.

Documentation can also be found at https://github.com/paullamar3/docker-gitit-pkg.


```

### Actions

The `-x ACTION` parameter tells the container what you expect it to do.
Supported actions are:

* No action - When no `-x` switch is provided the container will start an
    instance of *Gitit* in a detached (i.e. `-d`) container.
* `copy` - When `-x copy` is specified the container will attach to another
    `gitit-pkg` container and copy markdown from the host into the attached
    container's wiki. Think of this as *wiki initialization by copy*.
* `clone` - When `-x clone` is specified the container will attach to another
    `gitit-pkg` container and clone a repository from the host into the
    attached container's wiki. Think of this as *wiki initialization by
    cloning*.
* `expcopy` - When `-x expcopy` is specified the container will attach to
    another `gitit-pkg` container and copy the wiki in the attached container
    into a directory on the host. Think of this as *wiki export by copy*.
* `expclone` - When`-x expclone` is specified the container will attach to
    another `gitit-pkg` container and clone the wiki repository in the attached
    container into a directory on the host. Think of this as *wiki export by
    cloning*.
* `utils` - When `-x utils` is specified the container will merely dump the
    contents of its `/home/gitit/utils/` directory to a directory named `utils`
    on the host. See the section above called *Installing the utility scripts*.


The actions `copy`, `clone`, `expcopy` and `expclone` are described in more
detail in the documentation for the scripts `dgfromcopy`, `dgfromclone`,
`dgexportcopy` and `dgexportclone` respectively. See the
`/home/gitit/entrypoint.sh` for the actual commands each of these actions will
trigger. In general these actions depend on a host volume being bound to a
particular folder in the container being created to perform the action (which
is *not* the container hosting the *Gitit* wiki). By using the utility scripts
(as opposed to running `dgititrun` manually with the associated action) we let
the script handle these specific volume bindings. All we have to do is specify
the host directory to import from or export to and the name of the container
that will host the wiki.

### `NAME` and `PORT`

The `-n NAME` parameter lets us specify a specific name for the container being
created. Simply replace `NAME` with the name you want. If a `-n` is not
specified the default name will be `gitit_DDDHHMM` where `DDD` is the Julian
day, `HH` is the hour and `MM` is the minute in which the container started.

The `-p PORT` parameter lets us specify the port *on the host* we want the
container to connect to. The default port is 80. Note that the container's
internal port is always 5001.

> ASIDE: This behavior is a consequence of the way I use my *Gitit* wiki
containers.  Basically I keep all my wiki containers "in house" behind my
firewall. I use them for development and for internal information (e.g.
journaling) but I never expose the containers to the public. Instead I would
migrate a wiki developed on a container to a hosting service. 

> If your intent is to use this container for a public facing wiki you may well
want to review the overall architecture of the container including the way
ports are handled.

### `INIT`

When specifying an action of `copy` or `clone` this is the name of the
existing container to be initialized.  When specifying an action of `expcopy`
or `expclone` this is the name of the container from which we want to export
the wiki. See the scripts `dgfromcopy`, `dgfromclone`, `dgexportcopy` and
`dgexportclone` for examples of how this parameter might be utilized.

### `PATH`

When specifying an action of `copy` or `clone` this is the path to the
directory on the host containing the wiki we want to copy into the container
(in the case of `copy`) or the path to the repository we want to clone into the
container (in the case of `clone`). When specifying an action of `expcopy` or
`expclone` this is the path to the directory on the host to which we want to
copy the wiki (in the case of `expcopy`) or to which we want to clone the
wiki's repository (in the case of `expclone`).

Note that it may be the case that these paths must be absolute; I have not
tested them with relative paths.

## dgfromcopy

The `dgfromcopy` script creates a new *Gitit* container and then immediately
initializes the wiki by recursively copying files in a host directory into the
container's `/home/gitit/data/wikidata/` directory. When the script completes
you are left with one running instance of a `gitit-pkg` container.

For example, suppose you have a directory called
`/home/paul/Documents/wikis/myFirstWiki/` containing markdown documents and
other subdirectories containing their own markdown documents. You can
initialize a new *Gitit* container with said wiki by running: 

`./dgfromcopy -d /home/paul/Documents/wikis/myFirstWiki/`

This command will leave you with a running *Gitit* container accessible through
the host's port 80 (the default port). The container will be named
`gitit_DDDHHMM` where `DDD` is the Julian day, `HH` is the hours the container
was created and `MM` is the minute the container was created.

The `dgfromcopy` script also supports optional parameters for specifying a
specific container name or a specific host port.

### On-line help

You can view the online help for `dgfromcopy` by executing `./dgfromcopy -h`.
The help reads:

```

dgfromcopy [-h] [-n NAME] [-p PORT] [-d PATH]

This script provides a convenience wrapper for the 'docker run' command when
using the paullamar3/gitit-pkg image. This script creates a new Gitit
container and then initializes the wiki by copying a folder of markdown 
documents into the container's wiki.

    -h                 Displays this help message.
    -n NAME            The name to assign to the container.
    -p PORT            The host port that Gitit will connect to.
    -d PATH            The folder containing the initialization wiki.

For detailed documentation execute the following to start a Gitit container:
  ./dgititrun 

Attach to the Gitit instance by using a browser to connect to 'localhost'. The 
default Gitit wiki contains pages describing this container image and these
utility shell scripts.

Documentation can also be found at https://github.com/paullamar3/docker-gitit-pkg.


```

### Optional arguments

The optional arguments for `dgfromcopy` (i.e. `-d PATH`, `-n NAME` and `-p
PORT`) carry the same meanings as they do when using `dgititrun`. They allow
you to specify the path on the host where the wiki to copy resides; the name of
the final *Gitit* container; and the host port the container will connect to.
Note that`dgfromcopy` also creates a temporary *initialization container* to
perform the actual copy. (If you inspect the script you will see that the
second container does not need a port and its temporary name will be inferred
from the name of the main container.)

### Copied not Cloned

Note that by using `dgfromcopy` instead of `dgfromclone` you will forcefully
copy the markdown files from the host directory into the *Gitit* container's
wiki. The copy will overwrite any files with the same name but it will not
change any existing *Gitit* wiki files otherwise. Unless your host directory
contains a file named `Front Page.page`, for example, the default `Front
Page.page` will remain in the final wiki.

Note that once the copy is completed all new files (or files that were changed
because they were overwritten) are added and committed to the *Git* repository.

## dgfromclone

The `dgfromclone` script creates a new *Gitit* container and then immediately
initializes the wiki by cloning a repository from a host directory into the
container's `/home/gitit/data/wikidata/` directory. When the script completes
you are left with one running instance of a `gitit-pkg` container.

For example, suppose you have a repositroy in
`/home/paul/Documents/wikis/myFirstWiki/` containing markdown documents. You
can initialize a new *Gitit* container with said wiki by running: 

`./dgfromclone -d /home/paul/Documents/wikis/myFirstWiki/`

This command will leave you with a running *Gitit* container accessible through
the host's port 80 (the default port). The container will be named
`gitit_DDDHHMM` where `DDD` is the Julian day, `HH` is the hours the container
was created and `MM` is the minute the container was created.

The `dgfromclone` script also supports optional parameters for specifying a
specific container name or a specific host port.

### On-line help

You can view the online help for `dgfromclone` by executing `./dgfromclone -h`.
The help reads:

```

dgfromclone [-h] [-n NAME] [-p PORT] [-d PATH]

This script provides a convenience wrapper for the 'docker run' command when
using the paullamar3/gitit-pkg image. This script creates a new Gitit
container and then initializes the wiki by copying a folder of markdown 
documents into the container's wiki.

    -h                 Displays this help message.
    -n NAME            The name to assign to the container.
    -p PORT            The host port that Gitit will connect to.
    -d PATH            The folder containing the initialization wiki.
		
For detailed documentation execute the following to start a Gitit container:
  ./dgititrun 
		  
Attach to the Gitit instance by using a browser to connect to 'localhost'. The 
default Gitit wiki contains pages describing this container image and these
utility shell scripts.
		  
Documentation can also be found at https://github.com/paullamar3/docker-gitit-pkg.
		  

```

### Optional arguments

The optional arguments for `dgfromclone` (i.e. `-d PATH`, `-n NAME` and `-p
PORT`) carry the same meanings as they do when using `dgititrun`. They allow
you to specify the path on the host where the repository to clone resides; the name of
the final *Gitit* container; and the host port the container will connect to.
Note that`dgfromclone` also creates a temporary *initialization container* to
perform the actual clone. (If you inspect the script you will see that the
second container does not need a port and its temporary name will be inferred
from the name of the main container.)

### Cloned not Copied

Note that by using `dgfromclone` instead of `dgfromcopy` you will completely
delete the original repository used for the wiki. This is necessary since we
cannot `git clone` into `/home/gitit/data/wikidata/` until we have completely
deleted the files and folders in that directory. This means that the pages
normally found in a new *Gitit* wiki (like *Front Page*, *Help* and *Gitit
User's Guide*) will not be in the final wiki unless these pages also exist in
the repository being cloned.

## dgexportcopy

The `dgexportcopy` script copies the contents of the
`/home/gitit/data/wikidata/` directory in the container to a directory on the
host which you specify. This is the inverse of the `dgfromcopy` script in that
instead of copying markdown files from host to container this script copies
files from container into the host. Note that the directory in the host needs
to exist; if you rely on the *Docker Engine* to create the directory you will
run into permissions issues (because the *Docker Engine* creates the directory
with `root` as the owner).

### On-line help

You can view the online help for `dgexportcopy` by executing `./dgexportcopy
-h`. The help reads:

```

dgexportcopy [-h] [-d PATH] CONTAINER

This script exports the Gitit wiki in a container based on paullamar3/gitit-pkg. 

    -h          Display this help message.
    -d PATH     The host folder we are exporting the wiki into.
    CONTAINER   The name of the container that has the wiki.

For detailed documentation execute the following to start a Gitit container:
  ./dgititrun 

Attach to the Gitit instance by using a browser to connect to 'localhost'. The 
default Gitit wiki contains pages describing this container image and these
utility shell scripts.

Documentation can also be found at https://github.com/paullamar3/docker-gitit-pkg.


```

### Miscellaneous notes

The optional arguments for this command are fairly straightforward. Use `-d
PATH` to specify the directory on the host where the files will be copied. This
directory should exist and be empty. If no directory is explicitly specified
the current directory is assumed.

Note that this script simply copies the "visible" files. Hidden files and
directories (like `.git`) are not copied.


## dgexportclone

The `dgexportclone` script clones the repository in the
`/home/gitit/data/wikidata/` directory in the container to a directory on the
host which you specify. This is the inverse of the `dgfromclone` script in that
instead of cloning the repository from host to container this script clones
the repository from container into host. Note that the directory in the host needs
to exist; if you rely on the *Docker Engine* to create the directory you will
run into permissions issues (because the *Docker Engine* creates the directory
with `root` as the owner).

### On-line help

You can view the online help for `dgexportclone` by executing `./dgexportclone
-h`. The help reads:

```

dgexportclone [-h] [-d PATH] CONTAINER

This script clones the Gitit wiki in a container based on paullamar3/gitit-pkg. 

    -h          Display this help message.
    -d PATH     The host folder we are exporting the wiki into.
    CONTAINER   The name of the container that has the wiki.

For detailed documentation execute the following to start a Gitit container:
  ./dgititrun 

Attach to the Gitit instance by using a browser to connect to 'localhost'. The 
default Gitit wiki contains pages describing this container image and these
utility shell scripts.

Documentation can also be found at https://github.com/paullamar3/docker-gitit-pkg.


```

### Miscellaneous notes

The optional arguments for this command are fairly straightforward. Use `-d
PATH` to specify the directory on the host where the files will be cloned. This
directory should exist and be empty. If no directory is explicitly specified
the current directory is assumed.

Note that the script will clone "into" a subdirectory in the directory
specified. This subdirectory will be named `DDDHHMM` where `DDD` is the Julian
date; `HH` is the hour; and `MM` is the minute. Because the container uses UTC
time the directory will be created accordingly.

