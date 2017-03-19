#!/usr/bin/env python
# this script is designed for adding tax id to diamond output in order for MEGAN to reconize
# this works by lookup accession number (without version number)
# the map for this look up is obtained from ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/
# the sorted map can be obtained by cat and pipe to sort 

import re, sys, time, argparse, logging, bisect

parser = argparse.ArgumentParser()
parser.add_argument('--map', type=argparse.FileType('r'), default='prot.accession2taxid.sorted',
                    help='path to SORTED accession2taxid file')
parser.add_argument('--out_suffix', type=str, default='.taxided',
                    help='suffix_of_output_file')
parser.add_argument('--log', type=str, default='taxid.log',
                    help='path to log file')
parser.add_argument('data', type=argparse.FileType('r'), nargs='+',
                            help='path to m8 file(s)')
args = parser.parse_args()

logging.basicConfig(
                    level=logging.DEBUG,  # set debug level here
                    format='%(asctime)s %(levelname)s %(message)s',
                    filename=args.log )

logging.info('script starting')

lookup_keys = []
lookup_vals = []
last_accession = ''
last_taxid = -1
line_count = 0
for line in args.map:
    line_count += 1
    ls = line.split('\t')
    if (len(ls) == 4) and ls[2].isdigit():
        taxid = int(ls[2])
        accession = ls[0].strip()
        if taxid == last_taxid:
            continue
        if accession == last_accession:
            assert (taxid == last_taxid), line
            continue
        elif accession < last_accession:
            logging.error('map is not sorted in increasing order at line %d' % line_count)
            logging.error('last accession: %s, this accession: %s' % (last_accession, accession))
            logging.error('exiting')
            exit()
        lookup_keys.append(accession)
        lookup_vals.append(taxid)
        last_taxid = taxid
        last_accession = accession
    else:
        logging.warning('map line not reconized: %s\n' % line.strip())
logging.info('map finished loading')


key_size = sys.getsizeof(lookup_keys)
val_size = sys.getsizeof(lookup_vals)
val_length = len(lookup_vals)
logging.info('val length: %d | key size: %d | val size: %d ' % (val_length, key_size, val_size))

for data in args.data:
    logging.info('start lookup for %s' % data.name)
    path_out = data.name + args.out_suffix
    fout = open(path_out, 'w')
    for line in data:
        ls = line.split('\t')
        accession_ls = ls[1].split('.')
        if len(accession_ls) == 2:
            accession_nover = accession_ls[0].strip()
        elif len(accession_ls) > 2:
            logging.warning('data accession has more than 2 dots: %s\n' % ls[1])
            accession_nover = accession_ls[0:-1].join('.').strip()
        else:
            logging.warning('data accession has no dot: %s\n' % ls[1])
            accession_nover = accession_ls.strip()
        idx = bisect.bisect(lookup_keys, accession_nover)-1
        taxid = lookup_vals[idx]
        fout.write('%s\t%d\n' % (line.strip(), taxid))
    logging.info('done populating %s' % fout.name)
    fout.close()

exit()





