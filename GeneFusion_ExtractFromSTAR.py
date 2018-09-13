#!/usr/bin/env python

import glob, sys

filenames = glob.glob("%s/*_Fusion" % sys.argv[1])

print glob.glob(sys.argv[1]), filenames


fusion = open(sys.argv[2], 'w')

for eachfile in filenames:
    filename = eachfile.split('/')[-1].split('_')[0]
    mappingfile = open('%s/star-fusion.fusion_candidates.final' % eachfile, 'r')
    for line in mappingfile:
        if line.startswith('#'):
            continue
        else:
            sline = line.strip().split()
            fusionname = sline[0]
            Junction, Spanning = int(sline[1]), int(sline[2])
            Left, Right, Type = sline[5],sline[7],sline[3]
            if Junction >= 2 and Spanning >= 2:
                newline = '\t'.join(map(str, [filename, fusionname,Junction, Spanning, Left, Right, Type]))
                fusion.write(newline + '\n')
            else:
                continue

fusion.close()
