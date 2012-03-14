#!/bin/bash

# Solr support replication. But the download time from the be0 and be1 can take rather long time and thus fail.
# This script is therefor a workaround. It is run from the store0 node

# If no parameter was given, we replicate the master index
if [ "$1" == "" ];
then
	index0=/data/solr-mappings.index0/solr/
else
	index0=$1
fi


for i in {0..1}
	do
		be=/data/solr-mappings.be"$i"/solr/
		rsync --delete -avv $index0 $be
		chown -R tomcat6:tomcat6 $be
		url=http://api.be"$i".socialhistoryservices.org:8080/solr/admin/multicore?action="RELOAD&core=all"
		wget -O /tmp/reload.txt "$url"
done
