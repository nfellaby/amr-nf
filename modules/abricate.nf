#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process ABRICATE{
    tag "${climb_id}"
    container 'community.wave.seqera.io/library/abricate:1.0.1--0fd3388e9b365eeb'
    
    input:
    tuple val(climb_id), path(fastq1)

    script:
    """
    echo "CLIMB-ID: $climb_id"
    echo "FASTQ 1: $fastq1"
    echo "${params.output}"
    abricate --quiet --mincov 90 --db vfdb $fastq1 > ${params.output}/$climb_id_abricate.vdf
    """

}