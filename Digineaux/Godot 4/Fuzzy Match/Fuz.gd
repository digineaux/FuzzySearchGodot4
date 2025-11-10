class_name Fuz

##Returns the number of edits required to turn one string into the other.
##insertions, deletions, or substitutions
static func levenshtein(termA: String, termB: String, caseSensitive:=false,alphabetize:=true) -> int:
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()
	if alphabetize:#Good for dyslexic accessibility. The order of letters doesn't mattter. Can sometimes produce false posistives.
		termA = AlphabetizeString(termA)
		termB = AlphabetizeString(termB)
	
	if termA == termB: return 0 #exit early if exact match
	
	var aLength = termA.length()
	var bLength = termB.length()
	#exit if either string is empty, returning the length of the other, which repsents the difference and therefore changes
	if aLength == 0:return bLength
	if bLength == 0:return aLength

	# Initialize two rows
	var prev_row := []
	var curr_row := []

	for i in range(bLength + 1):
		prev_row.append(i)
	
	#basically iterates along a table of [termA.letter,termB.letter]
	for i in range(1, aLength + 1):
		curr_row.resize(bLength + 1)
		curr_row[0] = i
		for j in range(1, bLength + 1):
			var cost = 0 if termA[i - 1] == termB[j - 1] else 1
			curr_row[j] = min(
				curr_row[j - 1] + 1,      # insertion
				prev_row[j] + 1,          # deletion
				prev_row[j - 1] + cost    # substitution
			)
		prev_row = curr_row.duplicate()
	
	return curr_row[bLength]

static func LogicalLevenshtein(termA: String, termB: String, caseSensitive:=false, alphabetize=true):
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()
	if alphabetize:#Good for dyslexic accessibility. The order of letters doesn't mattter. Can sometimes produce false posistives.
		termA = AlphabetizeString(termA)
		termB = AlphabetizeString(termB)
	
	if termA == termB: return 0 #exit early if exact match
	
	var aLength = termA.length()
	var bLength = termB.length()
	#exit if either string is empty, returning the length of the other, which repsents the difference and therefore changes
	if aLength == 0:return bLength
	if bLength == 0:return aLength
	
	if bLength==aLength:return HammingDistance(termA,termB,caseSensitive,alphabetize)#use the faster hamming distance algo if the srings length matches
	
	

##Normalizes a Levenstein result as a % 0-1
static func similarityLevenstein(a: String, b: String,caseSensitive:=false) -> float:
	if a.is_empty() and b.is_empty():
		return 1.0
	var distance := levenshtein(a, b,caseSensitive)
	var max_len :float= max(a.length(), b.length())
	return 1.0 - float(distance) / float(max_len)

##faster than levenstein. But intended only for strings of the same length
static func HammingDistance(a: String, b: String, caseSensitive:=false,alphabetize:=true) -> int:
	if not caseSensitive:
		a = a.to_lower()
		b = b.to_lower()
	if alphabetize:#Good for dyslexic accessibility. The order of letters doesn't mattter. Can sometimes produce false posistives.
		a = AlphabetizeString(a)
		b = AlphabetizeString(b)

	if a==b:return 0
	
	var changes:=0
	
	var aLength:= a.length()
	#use length of shortest string
	if b.length()<aLength:aLength-=b.length()
	if b.length()>aLength:changes+= b.length()-aLength
	
	for i:int in range(aLength):
		if a[i] != b[i]:changes+=1
	
	return changes

##Reorders a strings characters alphabetically
static func AlphabetizeString(s: String) -> String:
	var chars := s.split("")
	chars.sort()
	return "".join(chars)

##list of comparisons with scores
##Optionally ordered by scroe
static func ListComparisons(query: String, stringsToCompare: PackedStringArray,threshold:=0.01,caseSensitive:=false,sort:=true,sortByHybridScore:=true) -> Array[FuzResult]:
	var results:Array[FuzResult]=[]
	var score:=0.0
	var hybrid:=0.0
	
	for term in stringsToCompare:
		score= similarityLevenstein(query,term,caseSensitive)
		hybrid= Compare(query,term,caseSensitive)
		
		if score<threshold&& hybrid< threshold: continue #skip if term doesnt score high enough
		
		var result:= FuzResult.new()
		result.term =query
		result.comparedTo=term
		result.levenshteinScore=score
		result.hybridScore=hybrid
		result.differences=levenshtein(query,term,caseSensitive)
		
		results.append(result)
	
	if sort:
		# sort descending
		results.sort_custom(func(a:FuzResult, b:FuzResult):
			if sortByHybridScore:
				return b.hybridScore < a.hybridScore
			else:
				return b.levenshteinScore < a.levenshteinScore
		)
	return results

##returns the amount of edits required for one string to become another
## combines multiple algorithms tuned to be more convenient to user in cases of a search engine or autocomplete
static func Compare(termA:String,termB:String,caseSensitive:=false, alphabetize:=true)->int:
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()
	if alphabetize:#Good for dyslexic accessibility. The order of letters doesn't mattter. Can sometimes produce false posistives.
		termA = AlphabetizeString(termA)
		termB = AlphabetizeString(termB)
	
	if termA == termB: return 0 #exit early if exact match
	var edits:=0
	if termA.length()==termB.length():
		edits=HammingDistance(termA,termB,caseSensitive,alphabetize)
	else:
		edits=levenshtein(termA,termB,caseSensitive,alphabetize)
	
	return edits
