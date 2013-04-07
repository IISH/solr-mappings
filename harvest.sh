#!/bin/bash

# Harvest
dataset=$1
if [ "$dataset" == "" ];
then
    echo "A dataset is needed to harvest.";
    exit 1
fi

d=/data/datasets/$dataset/
if [ -d $d ];
then
  # Write the desired harvest from parameter
  now=$(date +"%Y-%m-%d")
  php $VUFIND_HOME/harvest/LastHarvestFile.php "$now" "-31 day" "$d"last_harvest.txt
else
    echo "Not a valid folder: " . $d
    exit 1
fi

rm -r "$d"20*
cd $VUFIND_HOME/harvest
php harvest_oai.php $dataset > /data/log/$dataset.$now.harvest.log

#Setting permissions
chmod -R 744 $d

  # Now collate our material
  f=/data/datasets/"$dataset".xml
  rm $f

  # We import all records.
  # To speed the import up, we collate all to a single file.
  app=/usr/bin/vufind/import-1.0.jar
  xsl=$2
  java -Dxsl=$xsl -cp $app org.socialhistoryservices.solr.importer.Collate $d $f

  # Then upload
  # For this we need stylesheets to normalize the marc documents into our model
  java -cp $app org.socialhistoryservices.solr/importer.DirtyImporter $f "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

wget -O /tmp/commit.txt http://localhost:8080/solr/all/update?commit=true
