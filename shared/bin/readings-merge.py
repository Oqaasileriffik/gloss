#!/usr/bin/env python3
import sys
import regex as re
import argparse
import tempfile

parser = argparse.ArgumentParser(prog='readings-merge.py', description='Merge in unmodified readings')
parser.add_argument('id', nargs='?', default='0')
args = parser.parse_args()

tmpdir = tempfile.gettempdir()
input = open(f'{tmpdir}/nutserut-readings.{args.id}', 'r', encoding='utf-8')
rs = {}

for line in sys.stdin:
	line = line.rstrip()

	if not line.startswith('\t'):
		rs = {}
		print(line)
		continue

	if m := re.search(r' ¤:(\d+)', line):
		m = int(m[1])
		while m not in rs:
			reading = input.readline()
			n = re.search(r' ¤:(\d+)', reading)
			n = int(n[1])
			rs[n] = reading
		print(rs[m].rstrip() + ' ¤MERGED')

	print(line)
