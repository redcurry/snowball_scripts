#!/usr/bin/python

import sys

if len(sys.argv) < 3:
  print 'Arguments: p_ancestral_path p_parental_path',
  print 'interactions_ancestral_path interactions_parental_path'
  sys.exit(1)

pa_path = sys.argv[1]
pp_path = sys.argv[2]
ia_path = sys.argv[3]
ip_path = sys.argv[4]

pa_file = open(pa_path)
pp_file = open(pp_path)
ia_file = open(ia_path)
ip_file = open(ip_path)

for pa_line in pa_file:

  pp_line = pp_file.readline()
  ia_line = ia_file.readline()
  ip_line = ip_file.readline()

  pa_tokens = pa_line.split()
  pp_tokens = pp_line.split()
  ia_tokens = ia_line.split()
  ip_tokens = ip_line.split()

  update = pa_tokens[0]

  pa = float(pa_tokens[1])
  pp = float(pp_tokens[1])
  ia = int(ia_tokens[1])
  ip = int(ip_tokens[1])

  denom = ia + ip

  if denom > 0:
    p = (pa * ia + pp * ip) / denom
  else:
    p = 0

  print update, p

pa_file.close()
pp_file.close()
ia_file.close()
ip_file.close()
