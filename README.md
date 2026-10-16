Midterm-Eva-Makeda

Purpose: The purpose of this project is to identify ideal candidate colonies of pH-resistant methanogenic Archaea for growth. experimentation using McrA (highly conserved in methanogens) and HSP70 (correlated with pH resistance). Multiple-sequence alignment and profile Hidden Markov Models (HMMs) to determine whether the proteomes contained McrA and HSP70. We then counted significant hits to identify proteomes that had evidence for both genes.

Required software/modules: The pipeline uses: MUSCLE (multiple-sequence alignment), HMMER (hmm build and hmm search), and Bash and standard Unix commands (including cat, grep, awk, head, cp, etc.)

Commands: (*Note: steps 1-3 are automated in run_pipeline.sh)

Exercise 1:
1. combine reference sequences using: 
cd ref_sequences
cat mcrAgene_* > mcrA_ref_seqs.fasta
cat hsp70gene_* > hsp70_ref_seqs.fasta
2. align with muscle:
muscle -align mcrA_ref_seqs.fasta -output aligned_mcrA.afa
muscle -align hsp70_ref_seqs.fasta -output aligned_hsp70.afa
3. build hmm profile for each gene:
hmmbuild mcrA.hmm aligned_mcrA.afa
hmmbuild hsp70.hmm aligned_hsp70.afa

Exercise 2:
4. search a proteome with a profile:
cd ../proteomes
hmmsearch --tblout ../mcrA_results.txt ../ref_sequences/mcrA.hmm proteome_07.fasta
5. count hits
grep -v "^#" mcrA_results.txt | awk '$5 < 0.001' | wc -l

Exercise 3: (created run_pipeline.sh script in nano to automate prior steps)

Exercise 4:
6. Run pipeline on all 50 proteomes using: bash run_pipeline.sh ~/bioinformatics_project_canvas/ref_sequences ~/bioinformatics_project_canvas/proteomes candidate_proteomes.csv - The script aligns the reference sequences, builds profile HMMs for McrA and HSP70, searches each proteome, and counts the number of significant hits with E-values below 0.001. 
7. Save the complete results using: cp tmp/pipeline_results.csv all_proteome_results.csv
8. Look at McrA hit counts using: awk -F, 'NR > 1 {print $1, $2}' all_proteome_results.csv - This prints each proteome filename and its McrA hit count without including the header row.
9. Look at at HSP70 hit counts and then sort them using: awk -F, 'NR > 1 {print $1, $3}' all_proteome_results.csv | sort -k2,2n - This prints each proteome filename and its HSP70 hit count and sorts it from lowest to highest.
10. Filter out the proteomes that are good candidates using: head -1 tmp/pipeline_results.csv > candidate_proteomes.csv
awk -F, 'NR > 1 && $2 > 0 && $3 > 0' tmp/pipeline_results.csv >> candidate_proteomes.csv - This copies the header into the candidate file and appends proteomes with at least one significant hit for both McrA and HSP70.
11. Rename the candidate-results file using: mv candidate_proteomes.csv pipeline_results.csv - This renames the filtered candidate list to pipeline_results.csv.
12. Check the number of results using:
wc -l all_proteome_results.csv
wc -l pipeline_results.csv
- There were 51 lines, including the line with the header, in the complete results file.
- There were 16 lines, including the header, in the filtered candidate file. 

Results:

Exercise 1: 
1. aligned FASTA files with - marking gaps for insertions or deletions in the genes. Each sequence is denoted with a > header.
2. mcrA.hmm and hsp70.hmm created.

Exercise 2:
1. for proteome 7: 2513 sequences were searched, 1 hit (WP_012106121.1, coenzyme-B sulfoethylthiotransferase subunit alpha), e-value = 0, and score = 1020.1
2. 1 significant mrcA hit was found for proteome 7

Exercise 3: 
1. run_pipeline.sh was created and tested for a set of 5 proteomes, and results were displayed in pipeline_results.csv.
2. Viewing the output files showed only the headers, which indicates that none of the test proteomes (proteomes 1-5) had hits for both mcrA and hsp70.

Exercise 4: 
1. Ran the pipeline on all 50 proteomes using: bash run_pipeline.sh ~/bioinformatics_project_canvas/ref_sequences ~/bioinformatics_project_canvas/proteomes candidate_proteomes.csv
2. Examined the complete results using: awk -F, 'NR > 1 {print $1, $2}' all_proteome_results.csv - This showed each proteome and its McrA hit count.
3.  To examine HSP70 hit counts, organized from lowest to highest, used: awk -F, 'NR > 1 {print $1, $3}' all_proteome_results.csv | sort -k2,2n

Overall results: 
- McrA: The maximum was 2 hits in proteome_19.fasta and proteome_23.fasta. The minimum was 0 hits in 35 proteomes.
- HSP70: The maximum was 7 hits in proteome_18.fasta and proteome_22.fasta. The minimum was 0 hits in 8 proteomes: proteome_02.fasta, proteome_06.fasta, proteome_17.fasta, proteome_28.fasta, proteome_29.fasta, proteome_33.fasta, proteome_40.fasta, and proteome_46.fasta.

In the filtering step, 15 candidate proteomes with at least one significant hit for both McrA and HSP70 were identified. These candidates can be found in pipeline_results.csv. 


