#!/bin/bash

# Script-Name	: genScript.sh
# Author		: Daniel Weise

set -x
# Author of the new script
author="Daniel Weise"
company="Concepts and Training"
email="daniel.weise@conceptsandtrainings.de"

# directory of the script
script_dir=`pwd`

# editor to use
editor=subl

# first argument has to the scriptname
[ -z "$1" ] && exit 1

# file allready exists
[ -f $script_dir/$1 ] && exit 1

# create file
touch $script_dir/$1

# write basics to file
echo "#!/bin/bash" >> $script_dir/$1
echo "" >> $script_dir/$1
echo "# Script-Name	: $1" >> $script_dir/$1
echo "# Author		: $author" >> $script_dir/$1
echo "# Company		: $company " >> $script_dir/$1
echo "# Email			: $email" >> $script_dir/$1

# set executable permissions for the user
chmod u+x $script_dir/$1

# start editor and load script
$editor $script_dir/$1
