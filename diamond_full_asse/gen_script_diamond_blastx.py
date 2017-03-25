surfix = [
    'pair1',
    'pair2',
    'pair3',
    'pair4',
    'pair5',
]
for i in range(len(surfix)):    
    filename_out = 'diamond_blastx_j%s.sh' % str(i)
    inpath = '%s/scaffold.fa' % surfix[i]
    outname = '%s' % surfix[i]
    with open('template_diamond_blastx.sh', 'r') as fin:
        with open(filename_out, 'w') as fout:
            for line_in in fin:
                line_out = line_in.replace('replace_this_with_the_rest_of_input_path', inpath)
                line_out = line_out.replace('replace_this_with_output_filename', outname)
                fout.write(line_out)
           
