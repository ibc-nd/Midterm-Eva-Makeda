#!/bin/bash
#
#script must do the following:
#Take a reference FASTA file and a directory of proteome files as arguments
#Build the alignment and HMM profile
#Search every proteome in the directory
#Output a CSV file pipeline_results.csv with columns: proteome,num_hits
#
#Also, must include error checking (i.e. verifying files exist)
#
#load the software (on Notre Dame's CRC)
module load bio
set -e
#
#error checking --> 3 arguments needed (reference FASTA file, directory of proteome files, and
#output
if [ $# -ne 3 ]; then
	echo "Error, please use: bash run_pipeline.sh <ref_FASTA> <proteome_directory> <output_csv>"
	exit 1
fi
#ls gives an error if something is incorrect
ls "$1" "$2" > /dev/null
ls "$1"/mcrAgene_*.fasta > /dev/null
ls "$1"/hsp70gene_*.fasta > /dev/null
ls "$2"/*.fasta > /dev/null
#
mkdir -p tmp
#mcrA alignment and profile building
cat "$1"/mcrAgene_*.fasta > tmp/mcrA_ref_seqs.fasta
muscle -align tmp/mcrA_ref_seqs.fasta -output tmp/mcrA_aligned.afa
hmmbuild tmp/mcrA_profile.hmm tmp/mcrA_aligned.afa > tmp/mcrA_hmmbuild.log
#
#hsp70 alignment and profile building
cat "$1"/hsp70gene_*.fasta > tmp/hsp70_ref_seqs.fasta
muscle -align tmp/hsp70_ref_seqs.fasta -output tmp/hsp70_aligned.afa
hmmbuild tmp/hsp70_profile.hmm tmp/hsp70_aligned.afa > tmp/hsp70_hmmbuild.log
#
#searching every proteome in a directory
echo "proteome,mcrA_hits,hsp70_hits" > tmp/pipeline_results.csv
for proteome in proteomes/*.fasta; do
	name=$(basename "proteome")
#
	hmmsearch --tblout tmp/mcrA_hits.txt tmp/mcrA_profile.hmm "$proteome" > tmp/search.log
	mrcA_hits=$(grep -v "^#" tmp/mcrA_hits.txt | awk '$5<0.001' | wc -l)
#
	hmmsearch --tblout tmp/hsp70_hits.txt tmp/hsp70_profile.hmm "$proteome" > tmp/search.log
        hsp70_hits=$(grep -v "^#" tmp/hsp70_hits.txt | awk '$5<0.001' | wc -l)
	echo "$name,$mcrA_hits,$hsp70_hits" >> tmp/pipeline_results.csv
done
#keep proteomes with hits for mcrA and hsp70
head -1 tmp/pipeline_results.csv > $3
awk -F, 'NR > 1 && $2 > 0 && $3 > 0' tmp/pipeline_results.csv >> "$3"
echo "Results can be found in $3"
