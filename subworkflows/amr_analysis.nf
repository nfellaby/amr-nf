#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {ABRICATE} from "../modules/abricate"
include {SCAGAIRE} from "../modules/scagaire"

workflow AMR_ANALYSIS {
    take:
    single_end_ch

    main:
    // 1 - Run Abricate
    // Abricate can use fastq.gz, so just point to files.
    single_end_ch.view()
    ABRICATE(single_end_ch)
    // 2. Extract species IDs for each READ assigned AMR

    // 3. Run Scagaire
    // SCAGAIRE(ABRICATE.out.abricate)
}