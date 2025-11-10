extends VBoxContainer
var terms:PackedStringArray=[
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
	var entries:= Fuz.ListComparisons("apple",terms)
	
	for entry:FuzResult in entries:
		var label := Label.new()
		label.text = entry.term +"|" +entry.comparedTo+ ". Diff= "+str(entry.differences)+ " , Similarity= "+str(entry.similarity)
		add_child(label)
