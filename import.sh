#!/bin/sh

core=$1
DIR="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
d=$DIR/solr/${core}/conf/import

if [ ! -d $d ];
then
  echo "The folder ${d} does not exist."
  echo "Start this script with a single argument, namely the Solr core you want to import into."
  exit 1
fi

if [ -n "$2" ];
then
  filter=$2
else
  filter="*.xml"
fi

# Load all of the .xml import files and call the import handler.
for file in ${d}/$filter ; do
    handler=$(basename $file .xml)
    echo wget "http://localhost:8080/solr/${core}/dih/${handler}?command=full-import&clean=false&commit=true&optimize=true" -q
done
