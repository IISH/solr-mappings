#!/bin/sh

PRG=$0

# Get the full name of the directory where the Solr is installed
# We assume this script is relative to that of 'import.sh'
IMPORT=`dirname "$PRG"`
echo "IMPORT is $IMPORT"

# Load all of the .jar files in the lib directory into the classpath
for file in ${IMPORT}/*.xml ; do
    handler=$(basename $file .xml)
    wget "http://localhost:8080/solr/all/dih/${handler}?command=full-import&clean=false&commit=true&optimize=true" > /var/log/solr/import.xml
done
