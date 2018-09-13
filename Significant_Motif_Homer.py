#!/usr/bin/env python

from __future__ import division
import os, sys, math

KnownMotifs = open(sys.argv[1], 'r')
next(KnownMotifs)
SigMotifs = open(sys.argv[2], 'w')


for line in KnownMotifs:
    linelist = line.strip().split()
    motif = linelist[0].split('/')[0]
    pval, qval = map(float, [linelist[2], linelist[4]])
    fore, back = map(float, [linelist[6].strip('%'), linelist[8].strip('%')])
    log10p, enrich = abs(-math.log10(pval)), fore/back
    if qval <= 0.01 and enrich >= 1.1:
        newresults = '\t'.join(map(str, [motif, log10p, enrich, pval, qval, fore, back]))
        SigMotifs.write(newresults + '\n')
    else:
        continue

KnownMotifs.close()
SigMotifs.close()
 
