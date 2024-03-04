#!/usr/bin/env python3
import sys
import regex as re

# https://docs.python.org/3/tutorial/
# https://docs.python.org/3/library/re.html
# https://docs.python.org/3/library/re.html#re.sub

for line in sys.stdin:
	line = line.rstrip()

	if not line.startswith('\t'):
		print(line)
		continue

	line += ' '

	###line = re.sub(r'^\t(.+? NIQ Der/vn) (U Der/nv)', r'\t\2 \1', line) # U ved NIQ må flyttes før øvrige
#	line = re.sub(r'^3Sg U Der/nv ', r'3Sg "be" ', line)

	#line = re.sub(r'^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)', r'\t\2 \1', line) # Swap inline translation+tags and current baseform+tags
	line = re.sub(r' <tr:([^>]+)>.+?<tr-end> ', r' "\1" ', line) # Turn inline translation into a baseform

	# Simple ledflytninger sent i kaskaden. Kun for de overordnede POS

	###line = re.sub(r'\sNIQ\s', r' "..ing" ', line) #simpel substitution af NIQ

	###line = re.sub(r'^\t(.+?) (QAR Der/nv)', r'\t\2 \1', line) #QAR
	###line = re.sub(r' QAR Der/nv ', r' "have" ', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn SSAQ Der/nn NNGUR Der/nv)', r'\t\2 \1', line) #TUQ=SSAQ=NNGUR
	###line = re.sub(r' TUQ Der/vn SSAQ Der/nn NNGUR Der/nv ', r' "be about to" ', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn)', r'\t\2 \1', line) #TUQ
	###line = re.sub(r' TUQ Der/vn ', r' "one who/ that which" ', line)

	###line = re.sub(r'^\t(.+?) (RIIR Der/vv)', r'\t\2 \1', line) #RIIR
	###line = re.sub(r' RIIR Der/vv ', r' "be done with/ after" ', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn N Lok Sg)', r'\t\2 \1', line) #Lok på verbalnomen
	###line = re.sub(r' TUQ Der/vn N Lok Sg ', r' "in/on what" ', line)

	###line = re.sub(r'^\t(.+?) (i?Sem/Geo Prop Lok Sg)', r'\t\2 \1', line) #Lok på Geo/Prop
	###line = re.sub(r' i?Sem/Geo Prop Lok Sg ', r' "in" ', line)

	#Flytning af Cont-reflekser
	#line = re.sub(r'^\t(.+?) ("doing")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("not doing")', r'\t\2 \1', line)

	#Subjekt Sg og modus
	###line = re.sub(r'^\t(.+?) (V (Ind|Par|Cau|Con|Cont|ContNeg) \d(Sg|Pl) )', r'\t\2 \1', line)
	###line = re.sub(r' V (Ind|Par|Cau|Con) 3Sg ', r' "he/she/it" ', line)
	###line = re.sub(r' V (Ind|Par|Cau|Con|Cont|ContNeg) 1Sg ', r' "I" \1 ', line)

	###line = re.sub(r'Cont (".+?)_V', r'\1ing', line)

	###line = re.sub(r'^\t(.+?) (@CAU.?)', r'\t\2 \1', line) #
	###line = re.sub(r' @CAU.? ', r' "when" ', line)

	#Flytning af "own"
	#line = re.sub(r'^\t(.+?) ("own")', r'\t\2 \1', line)

	#Gram-tags
	line = re.sub(r' Gram/Refl ', r' "sig selv" ', line)
	line = re.sub(r' Gram/Pass ', r' "blive" ', line)
	line = re.sub(r' Gram/Reci ', r' "hinanden" ', line)

	#Possessiver
	#line = re.sub(r'^\t(.+?) (1SgPoss)', r'\t\2 \1', line)
	line = re.sub(r' 1SgPoss ', r' "min" ', line)

	#line = re.sub(r'^\t(.+?) (2SgPoss)', r'\t\2 \1', line)
	line = re.sub(r' 2SgPoss ', r' "din" ', line)

	#line = re.sub(r'^\t(.+?) (3SgPoss)', r'\t\2 \1', line)
	line = re.sub(r' 3SgPoss ', r' "hans/huns/dens/dets" ', line)

	#line = re.sub(r'^\t(.+?) (4SgPoss)', r'\t\2 \1', line)
	line = re.sub(r' 4SgPoss ', r' "hans/huns/dens/dets" ', line)

	#line = re.sub(r'^\t(.+?) (1PlPoss)', r'\t\2 \1', line)
	line = re.sub(r' 1PlPoss ', r' "vores" ', line)

	#line = re.sub(r'^\t(.+?) (2PlPoss)', r'\t\2 \1', line)
	line = re.sub(r' 2PlPoss ', r' "din" ', line)

	#line = re.sub(r'^\t(.+?) (3PlPoss)', r'\t\2 \1', line)
	line = re.sub(r' 3PlPoss ', r' "deres" ', line)

	#line = re.sub(r'^\t(.+?) (4PlPoss)', r'\t\2 \1', line)
	line = re.sub(r' 4PlPoss ', r' "deres" ', line)

	#Objekter
	#line = re.sub(r'^\t(.+?) (1SgO)', r'\t\2 \1', line)
	line = re.sub(r' 1SgO ', r' "mig" ', line)

	#line = re.sub(r'^\t(.+?) (2SgO)', r'\t\2 \1', line)
	line = re.sub(r' 2SgO ', r' "dig" ', line)

	#line = re.sub(r'^\t(.+?) (3SgO)', r'\t\2 \1', line)
	line = re.sub(r' 3SgO ', r' "ham/hun/den/det" ', line)

	#line = re.sub(r'^\t(.+?) (4SgO)', r'\t\2 \1', line)
	line = re.sub(r' 4SgO ', r' "ham selv/hende selv/den selv/det selv" ', line)

	#line = re.sub(r'^\t(.+?) (1PlO)', r'\t\2 \1', line)
	line = re.sub(r' 1PlO ', r' "vi" ', line)

	#line = re.sub(r'^\t(.+?) (2PlO)', r'\t\2 \1', line)
	line = re.sub(r' 2PlO ', r' "I" ', line)

	#line = re.sub(r'^\t(.+?) (3PlO)', r'\t\2 \1', line)
	line = re.sub(r' 3PlO ', r' "dem" ', line)

	#line = re.sub(r'^\t(.+?) (4PlO)', r'\t\2 \1', line)
	line = re.sub(r' 4PlO ', r' "dem selv" ', line)

	#Subjekter
	#line = re.sub(r'^\t(.+?) (1Sg)', r'\t\2 \1', line)
	line = re.sub(r' 1Sg ', r' "jeg" ', line)

	#line = re.sub(r'^\t(.+?) (2Sg)', r'\t\2 \1', line)
	line = re.sub(r'\b2Sg\b', r'"du"', line)

	#line = re.sub(r'^\t(.+?) (3Sg)', r'\t\2 \1', line)
	line = re.sub(r' 3Sg ', r' "han/hun/den/det" ', line)

	#line = re.sub(r'^\t(.+?) (4Sg)', r'\t\2 \1', line)
	line = re.sub(r' 4Sg ', r' "han/hun/den/det" ', line)

	#line = re.sub(r'^\t(.+?) (1Pl)', r'\t\2 \1', line)
	line = re.sub(r' 1Pl ', r' "Vi" ', line)

	#line = re.sub(r'^\t(.+?) (2Pl)', r'\t\2 \1', line)
	line = re.sub(r' 2Pl ', r' "de" ', line)

	#line = re.sub(r'^\t(.+?) (3Pl)', r'\t\2 \1', line)
	line = re.sub(r' 3Pl ', r' "dem" ', line)

	#line = re.sub(r'^\t(.+?) (4Pl)', r'\t\2 \1', line)
	line = re.sub(r' 4Pl ', r' "dem" ', line)

	###line = re.sub(r'^\t(.+?) U Der/nv ', r'\t\1 "be" ', line) #simpel substitution af U

	#flytning af præpositioner>
	#line = re.sub(r'^\t(.+?) ("of")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("than")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("because of")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("as")', r'\t\2 \1', line)

	#Oblikke kasus
	#line = re.sub(r'^\t(.+?) (Lok)', r'\t\2 \1', line) #Lok
	line = re.sub(r' Lok ', r' "i" ', line)

	#line = re.sub(r'^\t(.+?) (Trm)', r'\t\2 \1', line) #Trm
	line = re.sub(r' Trm ', r' "til" ', line)

	#line = re.sub(r'^\t(.+?) (Abl)', r'\t\2 \1', line) #Abl
	line = re.sub(r' Abl ', r' "fra" ', line)

	#line = re.sub(r'^\t(.+?) (Via)', r'\t\2 \1', line) #Via
	line = re.sub(r' Via ', r' "gennem" ', line)

	#line = re.sub(r'^\t(.+?) (Aeq)', r'\t\2 \1', line) #Aeq
	line = re.sub(r' Aeq ', r' "som" ', line)

	#flytning af konjunktioner
	#line = re.sub(r'^\t(.+?) ("that")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("if")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("when")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("while")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("when/if")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("when/because")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("everytime")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("even though")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("after")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("as soon as")', r'\t\2 \1', line)


	#ENKLITIKA
	#line = re.sub(r'^\t(.+?) (CONJ-LU) ', r'\t\2 \1', line)
	line = re.sub(r' CONJ-LU ', r' "og" ', line)

	#line = re.sub(r'^\t(.+?) (CONJ-LI) ', r'\t\2 \1', line)
	line = re.sub(r' CONJ-LI ', r' "men" ', line)

	#line = re.sub(r'^\t(.+?) (CONJ-LUUNNIIT) ', r'\t\2 \1', line)
	line = re.sub(r' CONJ-LUUNNIIT ', r' "eller" ', line)

	line = re.sub(r' ADV-LUUNNIIT ', r' "overhovedet" ', line)

	line = re.sub(r' AASIIT ', r' "som regel" ', line)

	#line = re.sub(r'^\t(.+?) (MI) ', r'\t\2 \1', line)
	line = re.sub(r' MI ', r' "som du ved" ', line)


	line = re.sub(r'\s(Der|Gram|Hyb|Orth)/\S+', r'', line) # Slet tilbageblevne sekundære tags
	line = re.sub(r' %ContHypotagme ', r' ', line) # Slet tilbageblevne sekundære tags6


	line = re.sub(r' <tr> ', r' ', line) # Remove translation marker
	line = re.sub(r' <tr-done> ', r' ', line) # Remove translation marker
	line = re.sub(r'  +', r' ', line) # Clean up spaces

	if not line.startswith('\t"'):
		line = re.sub(r'^\t', r'\t"_" ', line)

	line = line.rstrip()
	print(line)
