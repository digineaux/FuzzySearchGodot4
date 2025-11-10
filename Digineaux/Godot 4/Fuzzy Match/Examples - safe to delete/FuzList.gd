extends VBoxContainer
var terms:PackedStringArray = [
	# --- Apple variants ---
	"apple", "Apple", "APPLE", "aPpLe",
	"ap pl e", "Ap pl e", "APP LE",
	"appl", "Appl", "APPL",
	"appel", "Appel", "APPEL",
	"apples", "Apples", "APPLES",
	"appls", "Appls", "APPLES",
	"aple", "Aple", "APLE",
	"appple", "Appple", "APPPLE",
	"apple!", "apple?", "apple.", "apple,", "apple-juice",

	# --- Apricot variants ---
	"apricot", "Apricot", "APRICOT", "aPrIcOt",
	"ap ricot", "Ap ricot", "AP RICOT",
	"appricot", "Appricot", "APPRICOT",
	"aprict", "apricott", "aprico", "apric0t",
	"apricots", "Apricots", "APRlCOT", # note lowercase l instead of i
	"apr1cot", "Apr1cot",

	# --- Banana variants ---
	"banana", "Banana", "BANANA", "bAnAnA",
	"bannana", "bannnana", "bananna", "banan", "bananas",
	"b a n a n a", "b a na na", "ban ana",
	"banána", "banäna", "banâna", "bañana", # unicode tests
	"banana!", "banana?", "banana-split", "banana bread",

	# --- Orange variants ---
	"orange", "Orange", "ORANGE", "oRaNgE",
	"oragne", "orenge", "orrange", "ornage",
	"orange ", " orange", "orange!", "orange.",
	"o range", "Or ange", "O R A N G E",
	"oranges", "Oranges", "orangs", "orangey",

	# --- Grape variants ---
	"grape", "Grape", "GRAPE", "gRaPe",
	"grap", "graape", "grappe", "grapefruit",
	"grape!", "grape ", " grape",
	"grapes", "Grapes", "grapevine",
]


func _ready() -> void:
	for term:String in terms:
		var entries:= Fuz.ListComparisons(term,terms)
		for entry:FuzResult in entries:
			var label := Label.new()
			label.text = entry.term +"|" +entry.comparedTo+ ". Diff= "+str(entry.differences)+ " , Similarity= "+str(floorf(entry.similarity*100))+"%"
			add_child(label)
