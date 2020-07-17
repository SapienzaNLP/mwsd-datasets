# Disclaimer
- The **English datasets** for WSD have been previously collected by Raganato et al. EACL 2017 and **can be found at [http://lcl.uniroma1.it/wsdeval/](http://lcl.uniroma1.it/wsdeval/)**. **This repository contains** only for the **datasets in SemEval-2013 task 12 and SemEval-2015 task 13 for French, German, Italian and Spanish**
- In order to correctly clone this repository **you need [git-lfs](https://git-lfs.github.com/) installed** and it is highly encouraged to use git-clone command rather than download the repo as a zip as the large files won't be automatically included in zip folder. Read this [issue](https://github.com/git-lfs/git-lfs/issues/903#issuecomment-632841480) for more informaion on this regard

# Multilingual Datasets for Word Sense Disambiguation


In this repository we release an updated version of [SemEval-2013 task 12](https://www.aclweb.org/anthology/S13-2040/) 
and [SemEval-2015 task 13](https://www.aclweb.org/anthology/S13-2040/) **multilingual** gold standards.
The original data used old versions of BabelNet, i.e., 1.1.1 and 2.5, respectively, which are no longer available. 
To ease their use and allow a fair comparison among systems, we mapped all the possible gold keys in the original
datasets to the latest available version of [BabelNet](https://babelnet.org) (indices version 4.0 and API version 4.0.1),
normalized the Part-of-Speech tags to the Universal POS tags and handled the multiword instances so that they are now
associated with a single id and contained within a single XML tag. 
Furthermore, we provide two standard splits: 
1. all: comprising all the instances that we managed to map (data/multilingual_wsd_all_v1.0.tar.gz),
2. wn: comprising only the instances tagged with a BabelNet synset which contains a sense in WordNet (data/multilingual_wsd_wn_v1.0.tar.gz). This second split is a subset of all.


## Datasets and Inventories Creation
To create the new datasets, whenever possible, we used the WordNet sense keys provided with the original data.
Thanks to WordNet keys (version 3.0) we could easily map the old BabelNet synset id with the new synset id associated to that sense key
in BabelNet 4.0. 
As for those instances that were not associated with a WordNet sense key, instead, we used the original BabelNet indices to retrieve the Wikipedia page title 
and the gloss associated with the target BabelNet synset (both in English and in the specific language) and searched them in the new indices. 
Whenever a match was found (prioritising titles over glosses and English over language-specific information ) we mapped the instance to the found BabelNet id. If no match was found we discarded the instance.

### Build the Inventory
To correctly build the inventory, i.e., the association between a lexeme (lemma#pos) and its possible meanings, you shall follow this procedure.
- Login or sign up to [babelnet.org](https://babelnet.org/download)
- Request and download BabelNet indices.
- Download BabelNet API.
- `cd inventory_building`
- `cp /path/to/BabelNet-API-[VERSION]/resources/* .`
- `cp /path/to/BabelNet-API-[VERSION]/config .`
- Setup the properties files properly **this step is essential, if not properly setup, you may end up having wrong inventories** (More on this will follow).
- `bash create_inventories_sem13_15.sh -i /path/to/output_inventories/ -d /path/to/multilingual_datasets -s [wn|all]`
- Check out the inventories in `/path/to/output_inventories/[lang]` where lang may be one among \[de, es, fr, it\]

The `multilingual_datasets` can be extracted by running `tar xvzf data/multilingual_wsd_*_v1.0.tar.gz`

Example:
```bash
$ pwd
> /home/user/downloads/
$ cd inventory_building
$ cp -r /home/user/data/BabelNet-API-4.0.1/resources . 
$ cp -r /home/user/data/BabelNet-API-4.0.1/config . 
$ # setting up paths in configs
$ bash create_inventories_sem13_15.sh -i /home/user/downloads/inventory_building/data/multilingual_wsd_wn_v1.0/inventories/ -d /home/user/downloads/inventory_building/data/multilingual_wsd_wn_v1.0/ -s wn
$ ls /home/user/downloads/inventory_building/data/multilingual_wsd_wn_v1.0/inventories/
> de/ es/ fr/ it/
$ ls /home/user/downloads/inventory_building/data/multilingual_wsd_wn_v1.0/inventories/it
> inventory.it.withgold.sorted.txt  inventory.it.withgold.txt
```
#### Config Setup
In order to properly setup BabelNet config `cd` into `config` parent folder and verify that each path in `babelnet.properties`, `babelnet.var.properties`, `jlt.properties` and `jlt.var.properties` is reachable, as it is written in the files, from the directory you are in.

For example, if I am in `/home/user/multilingual_wsd_wn_v1.0` which has  `config/` as subfolder. I need to be sure that any path written in the aforementioned files is reachable from `/home/user/multilingual_wsd_wn_v1.0`.

#### BabelNet To WordNet mapping
In case you need to have a mapping between BabelNet offsets and WordNet offsets you can compute it by running
```bash
java -jar babelnet_mapping_4.0.jar -build_bn2wn_map /path/to/output/file.txt
```
This wil generate a tab-separated file having in the first column a BabelNet offset ID and in the subsequent columns the corresponding WordNet (version 3.0) offsets. 

## Data
Each package is structured as follows:
```bash
.
├── semeval2013-{lang}
│   ├── semeval2013-{lang}.data.xml
│   ├── semeval2013-{lang}.gold.key.txt
│   └── semeval2013-{lang}.wnids.gold.key.txt
└── semeval2015-{lang}
    ├── semeval2015-{lang}.data.xml
    ├── semeval2015-{lang}.gold.key.txt
    └── semeval2015-{lang}.wnids.gold.key.txt
```
Where, `lang` can be replaced by `it|es|fr|de` in `semeval2013` and `inventories` folders, and by `it|es` in the `semeval2015` folder.

### SemEvals
The `semeval` folders contains the text to tag in form of xml (.data.xml files) and the gold synsets associated to the instances (.gold.keys.txt files). We note that, not all instances within the XML have a gold synset associated with within the gold.key.txt this is because the same XML can be used for both splits (all and wn) which may have different instances.


## Statistics
### WordNet Split
| Dataset | Number of Instances | Word Types | Unique BN Synsets | Unique WN Synsets | Word Average Polysemy | Instance Average Polysemy | Polysemous Words |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
SemEval2013-it | 1490 | 604 | 702 | 702 | 3.80 | 5.51 | 458 |
SemEval2013-es | 1260 | 541 | 597 | 597 | 4.20 | 5.52 | 421 |
SemEval2013-fr | 1449 | 612 | 655 | 655 | 2.36 | 3.03 | 370 |
SemEval2013-de | 1076 | 484 | 481 | 481 | 1.60 | 2.17 | 184 |
SemEval2015-it | 1007 | 531 | 688 | 688 | 4.38 | 5.27 | 420 |
SemEval2015-es | 1043 | 507 | 733 | 733 | 6.17 | 6.99 | 446 |


### ALL Split
| Dataset | Number of Instances | Word Types | Unique BN Synsets | Word Average Polysemy | Instance Average Polysemy | Polysemous Words |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
SemEval2013-it | 1665 | 731 | 825 | 4.63 | 6.46 | 541 |
SemEval2013-es | 1463 | 678 | 730 | 4.85 | 6.36 | 484 |
SemEval2013-fr | 1618 | 730 | 779 | 3.69 | 4.53 | 531 |
SemEval2013-de | 1389 | 692 | 690 | 2.52 | 3.30 | 362 |
SemEval2015-it | 1063 | 557 | 730 | 5.02 | 5.87 | 456 | 
SemEval2015-es | 1101 | 541 | 774 | 6.62 | 7.39 | 475 |

# Contacts
For any question either open an issue on github or contact
pasini\[at\]di\[dot\]uniroma1\[dot\]it
# License
All data and codes provided in this repository are subject to the  Attribution-Non Commercial-ShareAlike 4.0 International license (CC BY-NC 4.0).

[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

# Troubleshotting 
- If you get the following exception:
```java
2020-07-17 19:27:52,042 [main] [ INFO  ] BabelNet - BabelNet online RESTful API v4.0 written by Francesco Cecconi, Roberto Navigli and Daniele Vannella
Exception in thread "main" java.lang.UnsupportedOperationException: getSynsetIterator: Unsupported online operation
```
Your `babelnet.var.properties` in the config/ folder is not properly set and you are attempting to use the online API rather then the indices you should have downloaded.

**Solution**: edit babelnet.var.properties file and set `babelnet.dir` to the local path to your BabelNet indeices. 
