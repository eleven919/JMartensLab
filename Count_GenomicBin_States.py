#!/usr/bin/env python

from collections import Counter

import sys

Masterfile = open(sys.argv[1], 'r')
Resultfile = open(sys.argv[2], 'w')

Efreq = []

for line in Masterfile:
    newlist = []
    statecount = []
    linelist = line.strip().split()
    for i in linelist:
        if i.startswith('E'):
            newlist.append(i)
        else:
            continue
    elementfreq = dict(Counter(newlist))
    for i in ['E1','E2','E3','E4','E5','E6','E7','E8','E9','E10','E11','E12']:
        if i in elementfreq:
            statecount.append(elementfreq[i])
        else:
            statecount.append(0)
    Efreq.append(statecount)
    resultline = '\t'.join(map(str, statecount))
    Resultfile.write(resultline + '\n')
    
Masterfile.close()
Resultfile.close()


Efreq = zip(*Efreq)
for n, i in enumerate(Efreq):
    Enum = dict(Counter(i))
    Eline = '\t'.join(['%s-%s' % (k, v) for (k, v) in Enum.items()])
    print 'E%d' % (n + 1) + '\t' + Eline

Masterfile.close()
Resultfile.close()
