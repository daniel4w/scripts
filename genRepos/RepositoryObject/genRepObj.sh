#!/bin/bash

# Script-Name	: genRepObj.sh
# Author		: Daniel Weise
# Company		: Concepts and Training 
# Email			: daniel.weise@conceptsandtrainings.de
set -x
lang=de

# check for arguments
if [ $# -lt 2 ]
	then
	echo "Usage: $0 <ilias_root> <plugin_name>"
	exit 1
fi

ilias_path="$1"
plugin_name="$2"
path="$1/Customizing/global/plugins/Services/Repository/RepositoryObject/$2"

# check if path allready exists
if [ -d ${path} ]
	then
	echo "Directory ${path} allready exists."
	exit 1
fi

# create directories
mkdir -p ${path}/classes/Settings
mkdir ${path}/lang
mkdir ${path}/sql
mkdir ${path}/tests
mkdir -p ${path}/templates/default

# create files in main folder
touch ${path}/composer.json
touch ${path}/plugin.php
touch ${path}/run_tests.sh

# create files in classes folder
touch ${path}/classes/Obj${plugin_name}.php
touch ${path}/classes/class.il${plugin_name}Plugin.php
touch ${path}/classes/class.ilObj${plugin_name}.php
touch ${path}/classes/class.ilObj${plugin_name}Access.php
touch ${path}/classes/class.ilObj${plugin_name}GUI.php
touch ${path}/classes/class.ilObj${plugin_name}ListGUI.php
touch ${path}/classes/ilActions.php

# create files in classes/Settings
touch ${path}/classes/Settings/${plugin_name}.php
touch ${path}/classes/Settings/DB.php
touch ${path}/classes/Settings/ilFormHelper.php

# create file in lang folder
touch ${path}/lang/ilias_${lang}.lang

# create file in sql folder
touch ${path}/sql/dbupdate.php

# create file in tests folder
touch ${path}/tests/BogusTest.php


# fill file composer.json
cat << EOF > ${path}/composer.json
{
	"autoload": {
		"psr-4": {
			"CaT\\Plugins\\${plugin_name}\\": "./classes"
		}
	}
}
EOF

# fill file run_tests.sh
cat << EOF > ${path}/run_tests.sh
#!/bin/bash

#plugin path from ilias-root:
PLUGINPATH='${path}';
SCRIPT_PATH=\$(dirname "\$0");
cd \$SCRIPT_PATH;

# note: no more parameters
phpunit --bootstrap ./classes/autoload.php tests;

#first param is path to ilias installation
if [ \$1 ] ; then
	cd \$1;
	echo;
	echo 'now running ILIAS tests in ' \$1;
	phpunit --bootstrap ./\$PLUGINPATH/classes/autoload.php \$PLUGINPATH/tests_ilias
fi
EOF

# fill file plugin.php
cat << EOF > ${path}/plugin.php
<?php
// alphanumerical ID of the plugin; never change this
// up to 4 letters
\$id = "";
// code version; must be changed for all code changes
\$version = "0.0.1";
// ilias min and max version; must always reflect the versions that should
// run with the plugin
\$ilias_min_version = "";
\$ilias_max_version = "";
// optional, but useful: Add one or more responsible persons and a contact email
\$responsible = "";
\$responsible_mail = "";
EOF

