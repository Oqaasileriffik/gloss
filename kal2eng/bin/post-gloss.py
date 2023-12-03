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

	###line = re.sub(r'^\t(.+? NIQ Der/vn) (U Der/nv)', r'\t\2 \1', line) # U ved NIQ må flyttes før øvrige
#	line = re.sub(r'^3Sg U Der/nv', r'3Sg "be"', line)

	#line = re.sub(r'^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)', r'\t\2 \1', line) # Swap inline translation+tags and current baseform+tags
	line = re.sub(r'<tr:([^>]+)>.+?<tr-end>', r'"\1"', line) # Turn inline translation into a baseform

	# Simple ledflytninger sent i kaskaden. Kun for de overordnede POS

	###line = re.sub(r'\sNIQ\s', r' "..ing" ', line) #simpel substitution af NIQ

	###line = re.sub(r'^\t(.+?) (QAR Der/nv)', r'\t\2 \1', line) #QAR
	###line = re.sub(r'QAR Der/nv', r'"have"', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn SSAQ Der/nn NNGUR Der/nv)', r'\t\2 \1', line) #TUQ=SSAQ=NNGUR
	###line = re.sub(r'TUQ Der/vn SSAQ Der/nn NNGUR Der/nv', r'"be about to"', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn)', r'\t\2 \1', line) #TUQ
	###line = re.sub(r'TUQ Der/vn', r'"one who/ that which"', line)

	###line = re.sub(r'^\t(.+?) (RIIR Der/vv)', r'\t\2 \1', line) #RIIR
	###line = re.sub(r'RIIR Der/vv', r'"be done with/ after"', line)

	###line = re.sub(r'^\t(.+?) (TUQ Der/vn N Lok Sg)', r'\t\2 \1', line) #Lok på verbalnomen
	###line = re.sub(r'TUQ Der/vn N Lok Sg', r'"in/on what"', line)

	###line = re.sub(r'^\t(.+?) (i?Sem/Geo Prop Lok Sg)', r'\t\2 \1', line) #Lok på Geo/Prop
	###line = re.sub(r'i?Sem/Geo Prop Lok Sg', r'"in"', line)

	#Flytning af Cont-reflekser
	#line = re.sub(r'^\t(.+?) ("doing")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("not doing")', r'\t\2 \1', line)

	#Subjekt Sg og modus
	###line = re.sub(r'^\t(.+?) (V (Ind|Par|Cau|Con|Cont|ContNeg) \d(Sg|Pl)\b)', r'\t\2 \1', line)
	###line = re.sub(r'V (Ind|Par|Cau|Con) 3Sg', r'"he/she/it"', line)
	###line = re.sub(r'V (Ind|Par|Cau|Con|Cont|ContNeg) 1Sg\b', r'"I" \1', line)

	###line = re.sub(r'Cont (".+?)_V', r'\1ing', line)

	###line = re.sub(r'^\t(.+?) (@CAU.?)', r'\t\2 \1', line) #
	###line = re.sub(r'@CAU.?', r'"when"', line)

	#Flytning af "own"
	#line = re.sub(r'^\t(.+?) ("own")', r'\t\2 \1', line)

	#Gram-tags
	line = re.sub(r'\bGram/Refl\b', r'"oneself"', line)
	line = re.sub(r'\bGram/Pass\b', r'"become"', line)
	line = re.sub(r'\bGram/Reci\b', r'"each other"', line)

	#Possessiver
	#line = re.sub(r'^\t(.+?) (1SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b1SgPoss\b', r'"my"', line)

	#line = re.sub(r'^\t(.+?) (2SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b2SgPoss\b', r'"your"', line)

	#line = re.sub(r'^\t(.+?) (3SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b3SgPoss\b', r'"his/her/its"', line)

	#line = re.sub(r'^\t(.+?) (4SgPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b4SgPoss\b', r'"his/her/its"', line)

	#line = re.sub(r'^\t(.+?) (1PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b1PlPoss\b', r'"our"', line)

	#line = re.sub(r'^\t(.+?) (2PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b2PlPoss\b', r'"your"', line)

	#line = re.sub(r'^\t(.+?) (3PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b3PlPoss\b', r'"their"', line)

	#line = re.sub(r'^\t(.+?) (4PlPoss)', r'\t\2 \1', line)
	line = re.sub(r'\b4PlPoss\b', r'"their"', line)

	#Objekter
	#line = re.sub(r'^\t(.+?) (1SgO)', r'\t\2 \1', line)
	line = re.sub(r'\b1SgO\b', r'"me"', line)

	#line = re.sub(r'^\t(.+?) (2SgO)', r'\t\2 \1', line)
	line = re.sub(r'\b2SgO\b', r'"you"', line)

	#line = re.sub(r'^\t(.+?) (3SgO)', r'\t\2 \1', line)
	line = re.sub(r'\b3SgO\b', r'"him/her/it"', line)

	#line = re.sub(r'^\t(.+?) (4SgO)', r'\t\2 \1', line)
	line = re.sub(r'\b4SgO\b', r'"himself/herself/itself"', line)

	#line = re.sub(r'^\t(.+?) (1PlO)', r'\t\2 \1', line)
	line = re.sub(r'\b1PlO\b', r'"us"', line)

	#line = re.sub(r'^\t(.+?) (2PlO)', r'\t\2 \1', line)
	line = re.sub(r'\b2PlO\b', r'"you"', line)

	#line = re.sub(r'^\t(.+?) (3PlO)', r'\t\2 \1', line)
	line = re.sub(r'\b3PlO\b', r'"them"', line)

	#line = re.sub(r'^\t(.+?) (4PlO)', r'\t\2 \1', line)
	line = re.sub(r'\b4PlO\b', r'"themselves"', line)

	#Subjekter
	#line = re.sub(r'^\t(.+?) (1Sg)', r'\t\2 \1', line)
	line = re.sub(r'\b1Sg\b', r'"I"', line)

	#line = re.sub(r'^\t(.+?) (2Sg)', r'\t\2 \1', line)
	line = re.sub(r'\b2Sg\b', r'"you"', line)

	#line = re.sub(r'^\t(.+?) (3Sg)', r'\t\2 \1', line)
	line = re.sub(r'\b3Sg\b', r'"he/she/it"', line)

	#line = re.sub(r'^\t(.+?) (4Sg)', r'\t\2 \1', line)
	line = re.sub(r'\b4Sg\b', r'"he/she/it"', line)

	#line = re.sub(r'^\t(.+?) (1Pl)', r'\t\2 \1', line)
	line = re.sub(r'\b1Pl\b', r'"we"', line)

	#line = re.sub(r'^\t(.+?) (2Pl)', r'\t\2 \1', line)
	line = re.sub(r'\b2Pl\b', r'"you"', line)

	#line = re.sub(r'^\t(.+?) (3Pl)', r'\t\2 \1', line)
	line = re.sub(r'\b3Pl\b', r'"they"', line)

	#line = re.sub(r'^\t(.+?) (4Pl)', r'\t\2 \1', line)
	line = re.sub(r'\b4Pl\b', r'"they"', line)

	###line = re.sub(r'^\t(.+?) U Der/nv ', r'\t\1 "be" ', line) #simpel substitution af U

	#flytning af præpositioner>
	#line = re.sub(r'^\t(.+?) ("of")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("than")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("because of")', r'\t\2 \1', line)
	#line = re.sub(r'^\t(.+?) ("as")', r'\t\2 \1', line)

	#Oblikke kasus
	#line = re.sub(r'^\t(.+?) (Lok)', r'\t\2 \1', line) #Lok
	line = re.sub(r'\bLok\b', r'"in"', line)

	#line = re.sub(r'^\t(.+?) (Trm)', r'\t\2 \1', line) #Trm
	line = re.sub(r'\bTrm\b', r'"to"', line)

	#line = re.sub(r'^\t(.+?) (Abl)', r'\t\2 \1', line) #Abl
	line = re.sub(r'\bAbl\b', r'"from"', line)

	#line = re.sub(r'^\t(.+?) (Via)', r'\t\2 \1', line) #Via
	line = re.sub(r'\bVia\b', r'"through"', line)

	#line = re.sub(r'^\t(.+?) (Aeq)', r'\t\2 \1', line) #Aeq
	line = re.sub(r'\bAeq\b', r'"like"', line)

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
	#line = re.sub(r'^\t(.+?) (CONJ-LU)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LU\b', r'"and"', line)

	#line = re.sub(r'^\t(.+?) (CONJ-LI)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LI\b', r'"but"', line)

	#line = re.sub(r'^\t(.+?) (CONJ-LUUNNIIT)\b', r'\t\2 \1', line)
	line = re.sub(r'\bCONJ-LUUNNIIT\b', r'"or"', line)

	line = re.sub(r'\bADV-LUUNNIIT\b', r'"at all"', line)

	line = re.sub(r'\bAASIIT\b', r'"as usual"', line)

	#line = re.sub(r'^\t(.+?) (MI)\b', r'\t\2 \1', line)
	line = re.sub(r'\bMI\b', r'"as you know"', line)


	line = re.sub(r'\s(Der|Gram|Hyb|Orth)/\S+', r'', line) # Slet tilbageblevne sekundære tags
	line = re.sub(r' %ContHypotagme ', r' ', line) # Slet tilbageblevne sekundære tags6


	line = re.sub(r' <tr> ', r' ', line) # Remove translation marker
	line = re.sub(r' <tr-done> ', r' ', line) # Remove translation marker
	line = re.sub(r'  +', r' ', line) # Clean up spaces

	if not line.startswith('\t"'):
		line = re.sub(r'^\t', r'\t"_" ', line)

	print(line)
