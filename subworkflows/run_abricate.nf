#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Step 1: Fetch FASTQ files from S3
process FETCH_FASTQ {
    input:
    climb_id
    path output
    
    output:
    path "${output}/fastq_files/*"

    script:
    """
    mkdir -p ${output}/fastq_files
    s3cmd get s3://mscape-published-read-fractions/${climb_id}/${climb_id}.human_filtered.fastq.gz ${output}/fastq_files/
    """
}

// // Step 2: Run Abricate on each FASTQ file
// process RUN_ABRICATE {
//     input:
//     path fastq_file from FETCH_FASTQ.out

//     output:
//     path "${params.output}/abricate_results.txt"

//     script:
//     """
//     abricate --db resfinder --mincov 50 --threads 4 ${fastq_file} > ${params.output}/abricate_results.txt
//     """
// }

workflow run_abricate {
    take:
        climb_id
        output
    main:
        FETCH_FASTQ(climb_id, output)
    //     RUN_ABRICATE(FETCH_FASTQ.out)
    
    // emit:
        
}