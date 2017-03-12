import os.path

surfix = [
    'pair1/JRKD001_S1_L001_R1_001_kneaddata_paired_',
    'pair2/JRKD002_S2_L001_R1_001_kneaddata_paired_',
    'pair3/JRKD003_S3_L001_R1_001_kneaddata_paired_',
    'pair4/JRKD004_S4_L001_R1_001_kneaddata_paired_',
    'pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_',
]

for i in range(len(surfix)):    
    sp = os.path.split(surfix[i])
    rep_list = []
    # rep_list.append(('replace_this_with_the_rest_of_input_dir',sp[0]))
    rep_list.append(('replace_this_with_input_filename', sp[1][0:15]+'.fasta'))
    rep_list.append(('replace_this_with_output_folder_name', sp[0]))
    print(str(rep_list))
    
    filename_out = 'idba_j%s.sh' % str(i)
    with open('template_idba.sh', 'r') as fin:
        with open(filename_out, 'w') as fout:
            for line_in in fin:
                line_out = line_in
                for a,b in rep_list:
                    line_out = line_out.replace(a,b)
                fout.write(line_out)
           
