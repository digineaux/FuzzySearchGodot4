class_name Fuz

##Returns the number of edits required to turn one string into the other.
##insertions, deletions, or substitutions
static func NumberOfDifferences(termA: String, termB: String, caseSensitive:=false, alphabetize:=true, stopAtThisManyComparisons:=-1) -> int:
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()

	if alphabetize:  # Good for dyslexic accessibility
		termA = AlphabetizeString(termA)
		termB = AlphabetizeString(termB)

	if termA == termB:
		return 0  # early exit if identical

	var lenA = termA.length()
	var lenB = termB.length()

	# Swap to always iterate the shorter string
	if lenA < lenB:
		var tmp = termA
		termA = termB
		termB = tmp
		var tmpLen = lenA
		lenA = lenB
		lenB = tmpLen

	# Initialize single row
	var row := []
	for j in range(lenB + 1):
		row.append(j)

	# Main loop
	for i in range(1, lenA + 1):
		var prev = row[0]
		row[0] = i
		var min_in_row = row[0]

		for j in range(1, lenB + 1):
			var temp = row[j]
			var cost = 0 if termA[i - 1] == termB[j - 1] else 1
			row[j] = min(
				row[j] + 1,      # deletion
				row[j - 1] + 1,  # insertion
				prev + cost      # substitution
			)
			prev = temp
			min_in_row = min(min_in_row, row[j])

		# Early exit if minimum in this row exceeds threshold
		if stopAtThisManyComparisons >= 0 and min_in_row > stopAtThisManyComparisons:
			return stopAtThisManyComparisons + 1

	return row[lenB] if stopAtThisManyComparisons < 0 or row[lenB] <= stopAtThisManyComparisons else stopAtThisManyComparisons + 1

##Normalizes a Levenstein result as a % 0-1
static func similarityLevenstein(a: String, b: String,caseSensitive:=false) -> float:
	if a.is_empty() and b.is_empty():
		return 1.0
	var distance := NumberOfDifferences(a, b,caseSensitive)
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
