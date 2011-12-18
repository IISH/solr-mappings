
# Harvest
export VUFIND_HOME=/data/search.socialhistory.org/vufind-1.1
dataset=$1
if [ "$dataset" == "" ];
then
    echo "A dataset is needed to harvest.";
    exit 1
fi

d=/data/datasets/$dataset/
if [ -d $d ];
then
  // ok
else
    echo "Not a valid folder: " . $d
    exit 1
fi

rm -r "$d"*20
cd $VUFIND_HOME/harvest
#php last_harvest.php "$d"last_harvest.txt
php harvest_oai.php $dataset

#Setting permissions
chmod -R 744 $d

  # Now collate our material
  f=/data/datasets/"$dataset".xml
  rm $f

  # We import all records.
  # To limit this, we collate all to a single file.
  app=/home/maven/repo/org/socialhistory/solr/import/1.0/import-1.0.jar
  java -cp $app org.socialhistoryservices.solr.importer.Collate $d $f

  # Then upload
  # For this we need stylesheets to normalize the marc documents into our model
  java -cp $app org.socialhistoryservices.solr/importer.DirtyImporter $f "http://localhost:8080/solr/all/update" "/data/solr-mappings.index0/solr/all/conf/normalize/$dataset.xsl,/data/solr-mappings.index0/solr/all/conf/import/add.xsl,/data/solr-mappings.index0/solr/all/conf/import/addSolrDocument.xsl" "collectionName:$dataset"

