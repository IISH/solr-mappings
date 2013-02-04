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
  php $VUFIND_HOME/harvest/LastHarvestFile.php "$now" "-30 day" "$d"last_harvest.txt
else
    echo "Not a valid folder: " . $d
    exit 1
fi

rm -r "$d"20*
cd $VUFIND_HOME/harvest
php harvest_oai.php $dataset

#Setting permissions
chmod -R 744 $d

  # Now collate our material
  fnew=/data/datasets/"$dataset".xml
  rm $fnew
  fdel=/data/datasets/"$dataset".deleted.xml
  rm $fdel

  # We import all records.
  # To limit this, we collate all to a single file.
  app=/usr/bin/vufind/import-1.0.jar
  java -Dxsl=marc -cp $app org.socialhistoryservices.solr.importer.Collate $d $fnew *.xml
  java -Dxsl=marc -cp $app org.socialhistoryservices.solr.importer.Collate $d $fdel *.deleted

  # Then upload
  # For this we need stylesheets to normalize the marc documents into our model
  java -cp $app org.socialhistoryservices.solr/importer.DirtyImporter $fnew "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

  java -cp $app org.socialhistoryservices.solr/importer.DirtyImporter $fdel "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.deleted.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

