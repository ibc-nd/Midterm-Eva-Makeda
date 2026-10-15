#!/bin/bash
#Exercise 1: concatenating mcrA and hsp70 references, aligning with muscle, and building hmm 
#profiles for each
cd Midterm-Eva-Makeda/ref_sequences
module load bio
cat mcrAgene_* > mcrA_ref_seqs.fasta
muscle -align mcrA_ref_seqs.fasta -output mcrA.afa
hmmbuild mcrA.hmm mcrA.afa
cat hsp70_* > hsp70_ref_seqs.fasta
muscle -align hsp70_ref_seqs.fasta -output hsp70.afa
hmmbuild hsp70.hmm hsp70.afa

