#!/usr/bin/bash

function helper {
  echo "usage: ./create_inventories_sem13_15.sh -i /path/to/output/dir -d /path/to/datasets/root -s [wn|all]" 
}
function maybe_exit {
    if [ "$?" -gt "0" ];then
        echo "Error found. Exiting. C ya."
        exit $?
    fi
}
ls resources &> /dev/null
if [ "$?" -gt "0" ];then
  echo "Read the instruction on the repo, create and populate the folder *resources*!!!!"
  exit 1 
fi
ls config &> /dev/null
if [ "$?" -gt "0" ];then
  echo "Read the instruction on the repo, create and populate the folder *config*!!!!"
  exit 1 
fi
ROOT=`pwd`
if [ "$#" -lt "6" ]; then
  helper
  exit 1
fi

while getopts ":i:d:s:" opt; do
    case ${opt} in
        i )
            INVENTORY_FOLDER=$OPTARG
            ;;
        d )
            DATASET_ROOT=$OPTARG
            ;;
        s )
            SPLIT=$OPTARG
            ;;
        \? )
            helper; exit 1
            ;;
    esac 
done


java -jar babelnet_mapping_4.0.jar \
  -build_inventories \
  -split $SPLIT \
  -inventory_folder $INVENTORY_FOLDER \
  -dataset_root $DATASET_ROOT
maybe_exit

python clean_inventory.py \
 --langs de es fr it \
 --inventory_folder $INVENTORY_FOLDER
maybe_exit
java -jar babelnet_mapping_4.0.jar \
  -sort \
  -inventory_folder $INVENTORY_FOLDER \
