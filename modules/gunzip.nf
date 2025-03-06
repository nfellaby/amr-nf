#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process GZ_TO_FASTQ{
    container 'community.wave.seqera.io/library/pip_gunzip:1ea8ddc0b75355cd'

    input:
    tuple val(climb_id), path(fastq1)

    output:
    tuple val(climb_id), path("${climb_id}.fastq")

    script:
    """
    gunzip -c "${fastq1}" > "${climb_id}.fastq"
    """


}
