#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
- class: SubworkflowFeatureRequirement
label: qiime2 DADA2 detect/correct paired sequence data
doc: "Option 1: DADA2 from https://docs.qiime2.org/2018.4/tutorials/moving-pictures/"

inputs:
  demux_sequences_artifact: File
  trunc_len_f: int
  trunc_len_r: int
  trim_left_f: int
  trim_left_r: int
  n_threads: int
  dada2_representative_sequences_filename:
    type: string
    default: rep-seqs.qza
  dada2_table_filename:
    type: string
    default: table.qza
  dada2_denoising_stats_filename:
    type: string
    default: stats.qza
  dada2_stats_filename:
    type: string
    default: stats.qzv

outputs:
  dada2_representative_sequences:
    type: File
    outputSource: dada2_denoise_paired/representative_sequences
  dada2_table:
    type: File
    outputSource: dada2_denoise_paired/table
  dada2_denoising_stats:
    type: File
    outputSource: dada2_denoise_paired/denoising_stats
  dada2_visualization_artifact:
    type: File
    outputSource: dada2_visualization/visualization_artifact

steps:
  dada2_denoise_paired:
    run: ../tools/qiime2/dada2-denoise-paired.cwl
    in:
      demultiplexed_seqs: demux_sequences_artifact
      trunc_len_f: trunc_len_f
      trunc_len_r: trunc_len_r
      trim_left_f: trim_left_f
      trim_left_r: trim_left_r
      n_threads: n_threads
      representative_sequences_filename: dada2_representative_sequences_filename
      table_filename: dada2_table_filename
      denoising_stats_filename: dada2_denoising_stats_filename
    out:
      - representative_sequences
      - table
      - denoising_stats
  dada2_visualization:
    run: ../tools/qiime2/metadata-tabulate.cwl
    in:
      input_file: dada2_denoise_paired/denoising_stats
      visualization_filename: dada2_stats_filename
    out:
      - visualization_artifact
