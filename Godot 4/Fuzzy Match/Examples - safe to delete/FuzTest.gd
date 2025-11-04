extends Node
class_name FuzTest
var terms:=[
	# Apple variants
	"apple", "Apple", "APPLE", "aPpLe",
	"ap pl e", "Ap pl e", "APP LE",
	"appl", "Appl", "APPL",
	"appel", "Appel", "APPEL",
	"apples", "Apples", "APPLES",

	# Apricot variants
	"apricot", "Apricot", "APRICOT", "aPrIcOt",
	"ap ricot", "Ap ricot", "AP RICOT",
	"appricot", "Appricot", "APPRICOT"
	]

func _ready() -> void:
	for term:String in terms:
		for term2:String in terms:
			var levenshteinScore:=Fuz.similarity(term,term2,true)
			var hybridScore:=Fuz.hybrid_score(term,term2,true)
			print(term +" levenstein= "+str(levenshteinScore)+"\n"
			+term2 + " Hybrid score= " + str(hybridScore)+"\n")
