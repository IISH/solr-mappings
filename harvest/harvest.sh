#!/bin/bash

# Harvest
dataset=$1
if [ "$dataset" == "" ];
then
    echo "A dataset is needed to harvest.";
    exit 1
fi

cd /data/solr-mappings.index0/harvest
d=/data/datasets/$dataset/

if [ -d $d ];
then
  # Write the desired harvest from parameter
  now=$(date +"%Y-%m-%d")
  php LastHarvestFile.php "$now" "-10 day" "$d"last_harvest.txt
else
    echo "Not a valid folder: " . $d
    exit 1
fi

f=/data/datasets/"$dataset".xml
if [ -f $f ];
then
	echo "Already processing... ${f}"
	exit 1
else
	touch $f
fi

if [ ! -z "$d" ] ; then
	rm -rf "$d*" # carefull.... make sure this value is not empty.
fi
php harvest_oai.php $dataset > /data/log/$dataset.$now.harvest.log

#Setting permissions
chmod -R 744 $d

  # We import all records.
  # To speed the import up, we collate all to a single file.
  app=/data/solr-mappings.index0/solr/lib/import-1.0.jar
  java -cp $app org.socialhistory.solr.importer.Collate $d $f

  # Then upload
  # For this we need stylesheets to normalize the marc documents into our model
  java -cp $app org.socialhistory.solr.importer.BatchImport $f "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

	rm $f

wget -O /tmp/commit.txt http://localhost:8080/solr/all/update?commit=true