#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: "qiime2: Mask unconserved and highly gapped columns from an alignment"

hints:
  - $import: qiime2-docker-hint.yml

inputs:
  alignment:
    type: File
    label: "alignment to be masked"
    inputBinding:
      prefix: "--i-alignment"
  masked_aligned_rep_seqs_filename:
    type: string
    label: "masked alignment filename"
    inputBinding:
      prefix: "--o-masked-alignment"
outputs:
  masked_aligned_rep_seqs:
    type: File
    outputBinding:
      glob: $(inputs.masked_aligned_rep_seqs_filename)

baseCommand: ["qiime", "alignment", "mask"]
