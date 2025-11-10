class_name Fuz

##Max length truncates characters to match the max length, if it's >0
##alphabetize rearranges characters into alphabetical order. This i useful to compare ujmbled worsd
static func Format( termA: String, termB: String,maxlength:=20,caseSensitive:=false, alphabetize:=true)->Array[String]:
	if not caseSensitive:
		termA = termA.to_lower()
		termB = termB.to_lower()

	if alphabetize:  # Good for dyslexic accessibility
		var chars:= termA.split("")
		chars.sort()
		termA = "".join(chars)
		
		chars= termB.split("")
		chars.sort()
		termB = "".join(chars)
	
	if maxlength>=1:
		termA=termA.substr(0,maxlength)
		termB=termB.substr(0,maxlength)
	return [termA,termB]

##Returns an array[numberOfChanges,%similarity]using a modified levenshteing algorithm
##Counts insertions, deletions, or substitutions as per Levenshtein algo
static func NumberOfDifferences(termA: String, termB: String) -> Array[float]:
	if termA == termB:
		return [0,1]  # early exit if identical
	
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
	var changes:=row[lenB]
	var similarityPercent:=1.0 - float(row[lenB]) / float(lenA+ lenB)

	return [changes,similarityPercent]

##faster than levenstein. But intended only for strings of the same length
## returns an array[changesInt,%match]
static func HammingDistance(a: String, b: String) -> Array[float]:
	if a==b:return [0,1]
	
	var changes:=0
	#use length of shortest string
	var min_len = min(a.length(), b.length())
	
	for i in range(min_len):
		if a[i] != b[i]:
			changes += 1
	changes += abs(a.length() - b.length())
	return [changes,1.0 - float(changes) / float(max(a.length(), b.length()))]

##list of comparisons with scores
##Optionally ordered by score
## those that score below the threshold are ignored
static func ListComparisons(query: String, stringsToCompare: PackedStringArray,threshold:=0.01,sorted:=true) -> Array[FuzResult]:
	var results:Array[FuzResult]=[]
	var score:Array[float]=[]
	
	for term in stringsToCompare:
		score= Compare(query,term,)
		
		if score[1]<threshold: continue #skip if term doesnt score high enough
		
		var result:= FuzResult.new()
		result.term =query
		result.comparedTo=term
		result.similarity=score[1]
		result.differences=score[0]
		
		results.append(result)
	
	if sorted:
		# sort descending
		results.sort_custom(func(a:FuzResult, b:FuzResult):
			return b.similarity < a.similarity
		)
	return results

##returns the amount of edits required for one string to become another
##returns array[edits,%similarity]
## combines multiple algorithms tuned to be more convenient to user in cases of a search engine or autocomplete
static func Compare(termA:String,termB:String)->Array[float]:
	if termA == termB: return [0,1] #exit early if exact match
	var edits:Array[float]=[]
	if termA.length()==termB.length():
		edits=HammingDistance(termA,termB)
	else:
		edits=NumberOfDifferences(termA,termB)
	
	return edits
