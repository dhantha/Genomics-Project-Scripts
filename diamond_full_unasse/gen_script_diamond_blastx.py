
surfix = [
    'pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_2',
    'pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_1',
    'pair1/JRKD001_S1_L001_R1_001_kneaddata_paired_1',
    'pair1/JRKD001_S1_L001_R1_001_kneaddata_paired_2',
    'pair2/JRKD002_S2_L001_R1_001_kneaddata_paired_1',
    'pair2/JRKD002_S2_L001_R1_001_kneaddata_paired_2',
    'pair3/JRKD003_S3_L001_R1_001_kneaddata_paired_2',
    'pair3/JRKD003_S3_L001_R1_001_kneaddata_paired_1',
    'pair4/JRKD004_S4_L001_R1_001_kneaddata_paired_2',
    'pair4/JRKD004_S4_L001_R1_001_kneaddata_paired_1',
]
for i in range(len(surfix)):    
    filename_out = 'diamond_blastx_full_j%s.sh' % str(i)
    with open('template_diamond_blastx.sh', 'r') as fin:
        with open(filename_out, 'w') as fout:
            for line_in in fin:
                line_out = line_in.replace('replace_this_with_the_rest_of_input_path', surfix[i])
                fout.write(line_out)
           
