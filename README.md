Fuz.hybrid_score(string,string)
Will return a score(float between 0-1) representing how closely the two strings match. 1 being an exact match, 0 being not a match at all and 0.5 being aproximately a 50% match.
This system can account for empty spaces, case sensitivity and (jumbled phrases,ujumbled sesarhp)=near exact match. These are all optional arguments or seperate functions.
Two examples are included, one printing scores to the console and another displaying an ordered list of comparison reuslts, with their scores and match partners. I reccomend testing your use case with those examples, before commiting to the system.

It makes use of a slightly customized levenshtein algorithm which scores based on changes needed for one string to become the other and an optional function that also grants score for mispelt and jumbled words (for my fellow dyslexics).

I tested it pretty thouroughly, but it's yet to see field testing. So don't be shy in reporting issues.

Compatibility

This was built for and tested on godot 4.5. But is most likely backwards compatible to previous Godot 4 versions and forwards compatible to future versions.

Installation

Put the root folder into your godot porjects assets folder. 
Make sure to extract it first if you download it as a .zip.

Contact

digineaux@gmail.com
or comment on my website or socials or here on github somewhere

Consider supporting my work here: https://donate.stripe.com/9AQ29QcU04IygE0144


License 

This work is licensed under the Creative Commons Attribution 4.0 International (often shortened to  CC BY 4.0 ).
You should carefully review all of the license terms before using this material.
Full license text available at: https://creativecommons.org/licenses/by/4.0/

In short you can do anything you want with it so long as you credit me. For example include a link to here or my website: Digineaux.com

Warranty

The software is provided “as is”, without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of, or in connection with the software or the use or other dealings in the software.
