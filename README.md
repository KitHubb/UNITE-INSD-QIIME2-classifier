# UNITE-INSD-QIIME2-classifier
This repository provides a step-by-step guide for creating a QIIME2-compatible classifier using the UNITE+INSD dataset for fungal ITS taxonomy.

## Resource
- datasets: `UNiTE+INSD` 
- version: `10.0`
- release: `2024-04-21`
- Citation:
  - When using this resource, please cite it as follows: Abarenkov, Kessy; Zirk, Allan; Piirmann, Timo; Pöhönen, Raivo; Ivanov, Filipp; Nilsson, R. Henrik; Kõljalg, Urmas (2024): Full UNITE+INSD dataset for Fungi. Version 21.04.2024. UNITE Community. https://doi.org/10.15156/BIO/2959330


## Preprocessing 
### Step 1. Extract headers from the UNITE fasta file
Extract all the taxonomy headers from the dataset using the following command:
```
grep ">" UNITE_public_21.04.2024.fasta > \
UNITE_public_taxonomy_21.04.2024.txt

```

### Step 2. Reformat to QIIME-compatible format
Extract `kingdom, phylum, class, order, family, genus, species` taxonomy levels and reformat the file:
Use this command to convert the taxonomy data into QIIME-compatible format:
```
cat UNITE_public_21.04.2024.fasta | grep '^>' | \
  sed 's/>//; s/|.*=/\t/; s/:/__/g; s/,/; /g; s/;$//' | \
  sed 's/\(.__\).__[^;]*/\1/g' > \
  UNITE_public_taxonomy_modi_21.04.2024.txt
```
### Step 3. Split taxonomy into Feature ID and Taxon columns
1. Create a shell script (process_taxonomy.sh) with the following content:
 ```
   #!/bin/bash

# Input file (raw taxonomy file)
input_file="UNITE_public_taxonomy_modi_21.04.2024.txt"

# Output file
output_file="UNITE_public_taxonomy_modi2_21.04.2024.txt"

# Add header and process data
{
  echo -e "Feature ID\tTaxon" # Add header
  awk -F'\|' '{taxon=$2; sub("\\|.*", "", taxon); print $0 "\t" taxon}' "$input_file"
} > "$output_file"

echo "File successfully created: $output_file"
```
2. Save and execute the script:
```
chmod +x process_taxonomy.sh
./process_taxonomy.sh
```
### Step 4. Import data into QIIME2
1. Import the taxonomy file:
```
qiime tools import --type 'FeatureData[Taxonomy]'   \
--input-path UNITE_public_taxonomy_modi2_21.04.2024.txt  \
--output-path UNITE_public_taxonomy_modi2_21.04.2024.qza
```

2. Import the FASTA file:
```
qiime tools import --type 'FeatureData[Sequence]' \
--input-path UNITE_public_21.04.2024.fasta \
--output-path UNITE_public_21.04.2024.qza
```

### Step 5. Train the QIIME2 classifier (6h>)
Train the classifier using the imported data:

```
qiime feature-classifier fit-classifier-naive-bayes  \
--i-reference-reads UNITE_public_21.04.2024.qza  \
--i-reference-taxonomy UNITE_public_taxonomy_modi2_21.04.2024.qza \
--o-classifier UNITE_public_21.04.2024_classifier.qza

```
## Output
- Processed Taxonomy File:
  - UNITE_public_taxonomy_modi2_21.04.2024.txt
  - This file contains two columns: Feature ID and Taxon.
- QIIME2 Artifacts:
  - Taxonomy artifact: UNITE_public_taxonomy_modi2_21.04.2024.qza
  - Sequence artifact: UNITE_public_21.04.2024.qza
  - Classifier artifact: UNITE_public_21.04.2024_classifier.qza
 
