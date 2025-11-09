class_name Fuz

##Reteurns the number of edits required to turn one string into the other
static func levenshtein(a: String, b: String, caseSensitive:=false) -> int:
	if not caseSensitive:
		a = a.to_lower()
		b = b.to_lower()
	var rows = a.length() + 1
	var cols = b.length() + 1
	var table: Array = []

	# Initialize table with zeros
	for _i in range(rows):
		var row := []
		for _j in range(cols):
			row.append(0)
		table.append(row)

	# Base cases
	for i in range(rows):
		table[i][0] = i
	for j in range(cols):
		table[0][j] = j

	# Fill table
	for i in range(1, rows):
		for j in range(1, cols):
			var cost = 0 if a[i-1] == b[j-1] else 1
			table[i][j] = min(
				table[i-1][j] + 1,      # deletion
				table[i][j-1] + 1,      # insertion
				table[i-1][j-1] + cost  # substitution
			)
	return table[rows-1][cols-1]


##Normalizes a Levenstein result as a % 0-1
static func similarityLevenstein(a: String, b: String,caseSensitive:=false) -> float:
	if a.is_empty() and b.is_empty():
		return 1.0
	var distance := levenshtein(a, b,caseSensitive)
	var max_len :float= max(a.length(), b.length())
	return 1.0 - float(distance) / float(max_len)


##Reorders a strings characters alphabetically
static func AlphabetizeString(s: String) -> String:
	var chars := s.split("")
	chars.sort()
	return "".join(chars)


##Alphabetizes the order of characters in both strings to account for letter ujmbling.
static func hybrid_score(query: String, target: String, caseSensitive:=false) -> float:
	var score1 := similarityLevenstein(query, target,caseSensitive)
	var score2 := similarityLevenstein(AlphabetizeString(query), AlphabetizeString(target),caseSensitive)

	var weight_original := 0.7  # prioritize actual order of letters
	var weight_jumble := 0.3    # partial credit for jumbled letters

	return clamp(score1 * weight_original + score2 * weight_jumble, 0.0, 1.0)


##list of comparisons with scores
##Optionally ordered by scroe
static func ListComparisons(query: String, stringsToCompare: PackedStringArray,threshold:=0.01,caseSensitive:=false,sort:=true,sortByHybridScore:=true) -> Array[FuzResult]:
	var results:Array[FuzResult]=[]
	var score:=0.0
	var hybrid:=0.0
	
	for term in stringsToCompare:
		score= similarityLevenstein(query,term,caseSensitive)
		hybrid= hybrid_score(query,term,caseSensitive)
		
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
