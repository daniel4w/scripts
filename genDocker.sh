#!/bin/bash

# Script-Name	: genDocker.sh
# Author		: Daniel Weise
# Company		: Concepts and Training 
# Email			: daniel.weise@conceptsandtrainings.de

# args?
if [ $# -lt 2 ]
	then
	echo "Usage: $0 <name> <target path>"
	exit 1
fi

# set variables
name=$1
target=$2
path=${target}/${name}

# dir exists?
[ -d ${path} ] && echo "Dir allready exists. Abort..." && exit 1

# create dirs
mkdir -p ${path}/build

# error while creating dir
[ $? -ne 0 ] && echo "Directory ${path}/build cant be created. Abort..." && exit 1

#create files
touch ${path}/docker-compose.yml
[ $? -ne 0 ] && echo "File ${path}/docker-compose.yml cant be created. Abort..." && exit 1
touch ${path}/build/Dockerfile
[ $? -ne 0 ] && echo "File ${path}/Dockerfile cant be created. Abort..." && exit 1
touch ${path}/build/startup.sh
[ $? -ne 0 ] && echo "File ${path}/startup.sh cant be created. Abort..." && exit 1

# fill the docker-compose.yml
cat << EOF > ${path}/docker-compose.yml
version: '2'

services:
  ilias-web:
    build: ./build
    # Define ports here <hostport>:<containerport>
#    ports:

    # Define volumes here <hostvolume>:<containervolume>
#    volumes:

    # Set container env vars
#    environment:
EOF

# fill the Dockerfile
cat << EOF > ${path}/build/Dockerfile
FROM debian:jessie

RUN apt-get update

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

CMD /startup.sh
EOF

# fill the file startup.sh
cat << EOF > ${path}/build/startup.sh
#!/bin/bash

echo "Hello World"
EOF