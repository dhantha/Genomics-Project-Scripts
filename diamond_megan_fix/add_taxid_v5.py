#!/usr/bin/env python
# Feiyang Xue, xfy1111@gmail.com
# this script is designed for adding tax id to diamond output in order for MEGAN to reconize
# this works by lookup accession number (without version number)
# the map for this look up is obtained from ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/
# for obtaining the sorted map, see the other bash script
# for values unobtainable from dump, it looks up NCBI protein database
# note that the frequency of this lookup is limited. 
# this script depends on requests: "pip install requests" if needed

import re, sys, time, argparse, logging, bisect, requests, re, Queue, threading, gc
import xml.etree.ElementTree as ET

def find_taxid(line, acc, qout, tmp_map):
    url = 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=%s&rettype=gp&retmode=xml' % acc
    try:
        r = requests.get(url, timeout=10)
    except Exception as e:
        logging.warning(e)
        qout.put('%s\n' % line.strip())
        return -1
    if r.status_code == 200:
        try:
            root = ET.fromstring(r.content)
            for a in root.iter('GBQualifier_value'):
                hit = re.match('^taxon\:(\d+)$', a.text.strip())
                if hit:
                    taxid = int(hit.group(1))
                    logging.info('tax id found to be %d for %s on ncbi' % (taxid, acc))
                    tmp_map[acc] = taxid # add to cache
                    qout.put('%s\t%d\n' % (line.strip(), taxid)) 
                    return taxid
        except Exception as e:
            logging.warning('cannot parse xml reuslt for %s, blacklist for future. err msg %s' % (acc, str(e)))
            tmp_map[acc] = -r.status_code
    else:
        logging.warning('200 is not returned for %s: %d. blacklist for future' % (acc, r.status_code))
        tmp_map[acc] = -r.status_code
    logging.warning('no tax id found for %s' % line.strip())
    qout.put('%s\n' % line.strip())
    return -1
    
    
def add_from_temp_map(acc, line, tmp_map, qout):
    try:
        taxid = tmp_map[acc]
        if taxid >= 0:
            qout.put('%s\t%s\n' % (line.strip(), taxid))
        else:
            qout.put(line.strip() + '\n')
    except:
        qout.put(line.strip() + '\n')

def keep_recents(recents):
    for n, t in recents.iteritems():
        if (time.time() - t) > 10:
            del recents[n]
    
def query_firer(tq, td, temp_map, qout):
    period = 0.35
    recents = {}
    last_check = 0
    while(td['run']):
        start = time.time()
        t, line = tq.get()
        if t.name in temp_map:
            td['cache_count'] += 1
            add_from_temp_map(t.name, line, temp_map, qout)
            tq.task_done()
            continue
        if (time.time() - last_check) > 2:
            keep_recents(recents)
            last_check = time.time()
        if t.name not in recents:
            td['count']+=1
            recents[t.name] = time.time()
            t.start()
            tq.task_done()
            end = time.time()
            duration = end - start
            if (duration < period):
                time.sleep(period - duration)
        else:
            # put back to queue
            tq.put((t,line))
            tq.task_done()

def write_output(f, qout):
    count = 0
    while (not qout.empty()):
        count += 1
        line = qout.get()
        f.write(line)
        qout.task_done()
    logging.debug('%d lines written from queue' % count)
    gc.collect()

parser = argparse.ArgumentParser()
parser.add_argument('--map', type=argparse.FileType('r'),
                    help='path to SORTED accession2taxid file')
parser.add_argument('--out_suffix', type=str, default='.taxided',
                    help='suffix_of_output_file')
parser.add_argument('--log', type=str, default='taxid.log',
                    help='path to log file')
parser.add_argument('--map_out', type=str, default='new_items.map',
                    help='path to file for storing new map items')
parser.add_argument('--offline', help='do not lookup ncbi website')
parser.add_argument('data', type=argparse.FileType('r'), nargs='+',
                            help='path to m8 file(s)')


args = parser.parse_args()
offline = (args.offline is not None)

logging.basicConfig(
                    level=logging.DEBUG,  # set debug level here
                    format='%(asctime)s %(levelname)s %(message)s',
                    filename=args.log )

logging.info('script starting')
logging.info('offline mode is set to %s' % str(offline))


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
        logging.warning('map line not reconized and skipped: %s\n' % line.strip())
logging.info('map finished loading')
gc.collect()

key_size = sys.getsizeof(lookup_keys)
val_size = sys.getsizeof(lookup_vals)
val_length = len(lookup_vals)
logging.info('val length: %d | key size: %d | val size: %d ' % (val_length, key_size, val_size))

temp_map = {}
qout = Queue.Queue()
tq = Queue.Queue()
tqf_td = {'run':True, 'count':0, 'cache_count':0 }
tqf = threading.Thread(target=query_firer, args=(tq, tqf_td, temp_map, qout))
tqf.daemon = True
tqf.start()

for data in args.data:
    logging.info('start lookup for %s' % data.name)
    path_out = data.name + args.out_suffix
    fout = open(path_out, 'w')
    line_count = 0
    for line in data:
        line_count += 1
        ls = line.split('\t')
        accession_ls = ls[1].split('.')
        if len(accession_ls) == 2:
            accession_nover = accession_ls[0].strip()
        elif len(accession_ls) > 2:
            logging.warning('data accession has more than 2 dots (%d): %s\n' % (line_count, line.strip()))
            accession_nover = accession_ls[0:-1].join('.').strip()
        else:
            # logging.warning('data accession has no dot: %s\n' % line)
            accession_nover = accession_ls[0].strip()
            if re.match('[A-Za-z0-9]{4}_[A-Za-z0-9]{2}', accession_nover) and (accession_nover[-1] == accession_nover[-2]):
                accession_nover = accession_nover[0:-1]
            if '|' in accession_nover:
                # logging.debug('use string after | for %s' % accession_nover)
                accession_nover = accession_nover.split('|')[-1]
        idx = bisect.bisect(lookup_keys, accession_nover) -1
        # for exact match
        if lookup_keys[idx] == accession_nover:
            taxid = lookup_vals[idx]
            fout.write('%s\t%d\n' % (line.strip(), taxid))
        # for previously looked up value
        elif accession_nover in temp_map:
            add_from_temp_map(accession_nover, line, temp_map, qout)
        # for no match nor previous lookup
        elif (not offline):
            logging.info('no exact match for %s. searching ncbi website' % accession_nover)
            t = threading.Thread(target=find_taxid, args=(line, accession_nover, qout, temp_map), name=accession_nover)
            tq.put((t, line))
        else:
            fout.write(line.strip() + '\n')
        # check and write output once a while
        if line_count % 1e6 == 0:
            write_output(fout, qout)
    write_output(fout, qout)
    logging.info('waiting for query threads to be executed')
    if (not tq.empty()):
        tq.join()
        time.sleep(12)
    write_output(fout, qout)
    logging.info('%d threads were started for no-matches' % tqf_td['count'])
    logging.info('%d accs were looked up from temp map' % tqf_td['cache_count'])
    logging.info('temp map length: %d' % len(temp_map))
    logging.info('done populating %s' % fout.name)
    fout.close()

tqf_td['run'] = False

with open(args.map_out.strip(), 'w') as fout:
    for k, v in temp_map.iteritems():
        if v >= 0:
            line = '%s\tNA\t%d\tNA\n' % (k, v)
            fout.write(line)

exit()





