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
			var comparison:Array[float]=Fuz.Compare(term,term2)
			print(term +": number of differences= "+str(comparison[0])+"\n"
			+term2 + " % similar= " + str(comparison[1]*100)+"%\n")
