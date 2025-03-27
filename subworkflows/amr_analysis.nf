#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {GZ_TO_FASTQ} from "../modules/gunzip"
include {RUN_ABRICATE} from "../modules/abricate"
include {READ_ANALYSIS} from "../modules/taxonomy"
include {SCAGAIRE} from "../modules/scagaire"


workflow AMR_ANALYSIS {
    take:
    single_end_ch

    main:
    // 1. Gunzip FASTQ
    // Abricate can use fastq.gz, so just point to files.
    GZ_TO_FASTQ(single_end_ch)
    
    // 2 - Run Abricate
    RUN_ABRICATE(GZ_TO_FASTQ.out)

    // test if any AMR annotations have been made
    RUN_ABRICATE.out.abricate_results
        .branch{
            climb_id, kraken_assignments, kraken_report, abricate_out ->
            // The abricate file will cotnain only headers if no AMR annotations have been made
            annotated: abricate_out.readLines().size() > 1
            unannotated: abricate_out.readLines().size() <= 1
        }. set{amr_status}
    // amr_status.unannotated.view()
    // // if not AMR annotations then skip
    amr_status.unannotated
        .map{ climb_id, kraken_assignments, kraken_report, abricate_out ->
            log.info "No AMR annotations where made for ${climb_id}."
            return null
        }

    // 3. Extract species IDs for each READ assigned AMR
    READ_ANALYSIS(amr_status.annotated)
    READ_ANALYSIS.out.view()
    // 4. Run Scagaire
    println params.species
    // species_list = params.species.split(',')
    // speices_list.view()
    // species_ch = channel.fromList(species_list)

    // combine abricate_results with new channel

    // call scagaire process, input would be value from string
    // SCAGAIRE(ABRICATE.out, species_ch)
    // SCAGAIRE(ABRICATE.out.abricate)
}