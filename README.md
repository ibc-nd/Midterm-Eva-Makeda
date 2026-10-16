# Midterm-Eva-Makeda

#Purpose: The purpose of this project is to identify ideal candidate colonies of pH-resistant methanogenic Archea for growth. 
#experimentation using McrA (highly conserved in methanogens) and HSP70 (correlated with pH 
#resistance). Multiple-sequence alignment and profile Hidden Markov Models (HMMs) to determine whether the proteomes contained McrA and HSP70. We then counted significant hits to identify proteomes that had evidence for both genes.

#Required software/modules: The pipeline uses: MUSCLE (multiple-sequence alignment), HMMER (hmm build and hmm search), and Bash and standard Unix commands (including cat, grep, awk, head, cp, etc.)

Load the required software on CRC: 
module load bio 

#Commands: 

Exercise 4 Commands: 
1. Run pipeline on all 50 proteomes using: bash run_pipeline.sh ~/bioinformatics_project_canvas/ref_sequences ~/bioinformatics_project_canvas/proteomes candidate_proteomes.csv - The script aligns the reference sequences, builds profile HMMs for McrA and HSP70, searches each proteome, and counts the number of significant hits with E-values below 0.001. 
2. Save the complete results using: cp tmp/pipeline_results.csv all_proteome_results.csv
3. Look at McrA hit counts using: awk -F, 'NR > 1 {print $1, $2}' all_proteome_results.csv - This prints each proteome filename and its McrA hit count without including the header row.
4. Look at at HSP70 hit counts and then sort them using: awk -F, 'NR > 1 {print $1, $3}' all_proteome_results.csv | sort -k2,2n - This prints each proteome filename and its HSP70 hit count and sorts it from lowest to highest.
5. Filter out the proteomes that are good candidates using: head -1 tmp/pipeline_results.csv > candidate_proteomes.csv
awk -F, 'NR > 1 && $2 > 0 && $3 > 0' tmp/pipeline_results.csv >> candidate_proteomes.csv - This copies the header into the candidate file and appends proteomes with at least one significant hit for both McrA and HSP70.
6. Rename the candidate-results file using: mv candidate_proteomes.csv pipeline_results.csv - This renames the filtered candidate list to pipeline_results.csv.
7. Check the number of results using:
wc -l all_proteome_results.csv
wc -l pipeline_results.csv
- There were 51 lines, including the line with the header, in the complete results file. There were 16 lines, including the header, in the filtered candidate file. 

#Results:

Exercise 4: 
1. Ran the pipeline on all 50 proteomes using 
