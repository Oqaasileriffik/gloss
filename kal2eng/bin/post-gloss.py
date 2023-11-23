#!/usr/bin/env python3
import sys
import re

# https://docs.python.org/3/tutorial/
# https://docs.python.org/3/library/re.html
# https://docs.python.org/3/library/re.html#re.sub

for line in sys.stdin:
	line = line.rstrip()

	if not line.startswith('\t'):
		print(line)
		continue

	line = re.sub(r'^\t(.+? NIQ Der/vn) (U Der/nv)', r'\t\2 \1', line) # U ved NIQ må flyttes før øvrige
#	line = re.sub(r'^3Sg U Der/nv', r'3Sg "be"', line)

	line = re.sub(r'^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)', r'\t\2 \1', line) # Swap inline translation+tags and current baseform+tags
	line = re.sub(r'<tr:([^>]+)>.+?<tr-end>', r'"\1"', line) # Turn inline translation into a baseform

	# Simple ledflytninger sent i kaskaden. Kun for de overordnede POS
	line = re.sub(r'3SgO', r'"him/her/it"', line) #simpel substitution af objektstag

	line = re.sub(r'\sNIQ\s', r' "..ing" ', line) #simpel substitution af NIQ

	line = re.sub(r'^\t(.+?) (3SgPoss)', r'\t\2 \1', line) #possessorer forrest i strengen, men efter præpositioner
	line = re.sub(r'3SgPoss', r'"his/her/its"', line)

	line = re.sub(r'^\t(.+?) (QAR Der/nv)', r'\t\2 \1', line) #QAR
	line = re.sub(r'QAR Der/nv', r'"have"', line)

	line = re.sub(r'^\t(.+?) (TUQ Der/vn SSAQ Der/nn NNGUR Der/nv)', r'\t\2 \1', line) #TUQ=SSAQ=NNGUR
	line = re.sub(r'TUQ Der/vn SSAQ Der/nn NNGUR Der/nv', r'"be about to"', line)

	line = re.sub(r'^\t(.+?) (TUQ Der/vn)', r'\t\2 \1', line) #TUQ
	line = re.sub(r'TUQ Der/vn', r'"one who/ that which"', line)

	line = re.sub(r'^\t(.+?) (RIIR Der/vv)', r'\t\2 \1', line) #RIIR
	line = re.sub(r'RIIR Der/vv', r'"be done with/ after"', line)

	line = re.sub(r'^\t(.+?) (TUQ Der/vn N Lok Sg)', r'\t\2 \1', line) #Lok på verbalnomen
	line = re.sub(r'TUQ Der/vn N Lok Sg', r'"in/on what"', line)

	line = re.sub(r'^\t(.+?) (i?Sem/Geo Prop Lok Sg)', r'\t\2 \1', line) #Lok på Geo/Prop
	line = re.sub(r'i?Sem/Geo Prop Lok Sg', r'"in"', line)

	line = re.sub(r'^\t(.+?) (Lok)', r'\t\2 \1', line) #Lok
	line = re.sub(r'Lok', r'"in"', line)

	line = re.sub(r'^\t(.+?) (Trm)', r'\t\2 \1', line) #Trm
	line = re.sub(r'Trm', r'"to"', line)

	line = re.sub(r'^\t(.+?) (Abl)', r'\t\2 \1', line) #Abl
	line = re.sub(r'Abl', r'"from"', line)


	line = re.sub(r'^\t(.+?) (V (Ind|Par|Cau|Con|Cont|ContNeg) \d(Sg|Pl)\b)', r'\t\2 \1', line) #Subjekt Sg og modus
	line = re.sub(r'V (Ind|Par|Cau|Con) 3Sg', r'"he/she/it"', line)
	line = re.sub(r'V (Ind|Par|Cau|Con|Cont|ContNeg) 1Sg\b', r'"I" \1', line)

	line = re.sub(r'Cont (".+?)_V', r'\1ing', line)

	line = re.sub(r'^\t(.+?) (@CAU.?)', r'\t\2 \1', line) #
	line = re.sub(r'@CAU.?', r'"when"', line)

	#Subjekter ved Ind og Par
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 1Sg)', r'\t\2 \1', line)
	line = re.sub(r'V (Ind|Par) 1Sg', r'"I"', line)
	
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 2Sg)', r'\t\2 \1', line)
	line = re.sub(r'V (Ind|Par) 2Sg', r'"you"', line)
	
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 3Sg)', r'\t\2 \1', line)
	line = re.sub(r'V (Ind|Par) 3Sg', r'"he/she/it"', line)
	
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 1Pl)', r'\t\2 \1', line)
	line = re.sub(r'V (Ind|Par) 1Pl', r'"we"', line)
	
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 2Pl)', r'\t\2 \1', line)
	line = re.sub(r'V (Ind|Par) 2Pl', r'"you"', line)
	
	line = re.sub(r'^\t(.+?) (V (Ind|Par) 3Pl)', r'\t\2 \1', line) #Subjekt Pl og modus
	line = re.sub(r'V (Ind|Par) 3Pl', r'"they"', line)
	
	#Possessiver
	line = re.sub(r'^\t(.+?) (1SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'(1SgPoss)', r'"my"', line)
	
	line = re.sub(r'^\t(.+?) (2SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'(2SgPoss)', r'"your"', line)
	
	line = re.sub(r'^\t(.+?) (3SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'(3SgPoss)', r'"his/her/its"', line)
	
	line = re.sub(r'^\t(.+?) (4SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'(4SgPoss)', r'"his/her/its"', line)
	
	line = re.sub(r'^\t(.+?) (1PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'(1PlPoss)', r'"our"', line)
	
	line = re.sub(r'^\t(.+?) (2PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'(2PlPoss)', r'"your"', line)
	
	line = re.sub(r'^\t(.+?) (3PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'(3PlPoss)', r'"their"', line)
	
	line = re.sub(r'^\t(.+?) (4PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'(4PlPoss)', r'"their"', line)

	line = re.sub(r'^\t(.+?) U Der/nv ', r'\t\1 "be" ', line) #simpel substitution af U

	#ENKLITIKA
	line = re.sub(r'^\t(.+?) (CONJ-LU)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LU\b', r'"and"', line)
	
	line = re.sub(r'^\t(.+?) (CONJ-LI)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LI\b', r'"but"', line)
	
	line = re.sub(r'^\t(.+?) (CONJ-LUUNNIIT)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LUUNNIIT\b', r'"or"', line)


	line = re.sub(r'\s(Der|Gram|Hyb|Orth)/\S+', r'', line) # Slet tilbageblevne sekundære tags
	line = re.sub(r' %ContHypotagme ', r' ', line) # Slet tilbageblevne sekundære tags6


	line = re.sub(r' <tr> ', r' ', line) # Remove translation marker
	line = re.sub(r' <tr-done> ', r' ', line) # Remove translation marker
	line = re.sub(r'  +', r' ', line) # Clean up spaces

	if not line.startswith('\t"'):
		line = re.sub(r'^\t', r'\t"_" ', line)

	print(line)
