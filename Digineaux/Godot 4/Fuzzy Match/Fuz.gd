class_name Fuz

static func Format( termA: String, termB: String,maxlength:=20,caseSensitive:=false, alphabetize:=true)->Array[String]:
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()

	if alphabetize:  # Good for dyslexic accessibility
		termA = AlphabetizeString(termA)
		termB = AlphabetizeString(termB)
	
	if maxlength>=1:
		termA=termA.substr(0,maxlength)
		termB=termB.substr(0,maxlength)
	return [termA,termB]

##Returns the number of edits required to turn one string into the other.
##Counts insertions, deletions, or substitutions as per Levenshtein algo
static func NumberOfDifferences(termA: String, termB: String,returnPercent:=true) -> float:
	if termA == termB:
		return 0  # early exit if identical
	
	var lenA:=termA.length()
	var lenB:=termB.length()

	# Swap to always iterate the shorter string - less iterations, better performance
	if lenA < lenB:
		var tmp = termA
		termA = termB
		termB = tmp
		var tmpLen = lenA
		lenA = lenB
		lenB = tmpLen

	# Initialize single row
	var row :Array[int]= []
	for j in range(lenB + 1):
		row.append(j)

	# Main loop
	for i in range(1, lenA + 1):
		var prev = row[0]
		row[0] = i

		for j in range(1, lenB + 1):
			var temp = row[j]
			var cost = 0 if termA[i - 1] == termB[j - 1] else 1
			row[j] = min(
				row[j] + 1,      # deletion
				row[j - 1] + 1,  # insertion
				prev + cost      # substitution
			)
			prev = temp

	if returnPercent:
		return 1.0 - float(row[lenB]) / float(lenA+ lenB)
	return row[lenB]

##faster than levenstein. But intended only for strings of the same length
static func HammingDistance(a: String, b: String) -> int:
	if a==b:return 0
	
	var changes:=0
	#use length of shortest string
	var min_len = min(a.length(), b.length())
	
	for i in range(min_len):
		if a[i] != b[i]:
			changes += 1
	changes += abs(a.length() - b.length())	
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
	
	for term in stringsToCompare:
		score= Compare(query,term,caseSensitive)
		
		if score<threshold: continue #skip if term doesnt score high enough
		
		var result:= FuzResult.new()
		result.term =query
		result.comparedTo=term
		result.levenshteinScore=score
		result.differences=NumberOfDifferences(query,term,caseSensitive)
		
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
		edits=NumberOfDifferences(termA,termB,caseSensitive,alphabetize)
	
	return edits
