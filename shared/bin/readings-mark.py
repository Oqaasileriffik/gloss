#!/usr/bin/env python3
# Copyright 2019 Oqaasileriffik <oqaasileriffik@oqaasileriffik.gl> at https://oqaasileriffik.gl/
# Licensed under the GNU GPL v3 or later - https://www.gnu.org/licenses/gpl-3.0.en.html

import sys
import argparse
import tempfile

parser = argparse.ArgumentParser(prog='readings-mark.py', description='Numbers all readings sequentially and stores them separately')
parser.add_argument('id', nargs='?', default='0')
args = parser.parse_args()

output = open(f'/tmp/nutserut-readings.{args.id}', 'w', encoding='utf-8')

n = 0
for line in sys.stdin:
	line = line.rstrip()

	if not line.startswith('\t'):
		print(line)
		continue

	n += 1
	line += f' ¤:{n}'

	output.write(line + '\n')
	print(line)

output.close()
