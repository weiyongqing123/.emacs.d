If you are working with XML documents, the parsed data structure
returned by the XML parser (xml.el) may be enough for you: Lists of
lists, symbols, strings, plus a number of accessor functions.

If you want a more elaborate data structure to work with your XML
document, you can create a document object model (DOM) from the XML
data structure using dom.el.

You can create a DOM from XML using `dom-make-document-from-xml'.
Note that `xml-parse-file' will return a list of top level elements
found in the file, so you must choose one element in that list.
Here's an example:

(setq doc (dom-make-document-from-xml (car (xml-parse-file "sample.xml"))))

Note that this DOM implementation uses the attributes and tag names
used by the XML parser.  If the XML parser uses symbols instead of
string (like xml.el does), then dom.el will also use symbols.  If the
XML parsers uses strings (like xml-parse.el does), then dom.el will
use strings.

It should be trivial to write functions analogous to the
dom-*-from-xml functions in order to use an another XML parsers (from
psgml.el, for example).

On Interfaces and Classes

The elisp DOM implementation uses the dom-node structure to store all
attributes.  The various interfaces consist of sets of functions to
manipulate these dom-nodes.  The functions of a certain interface
share the same prefix.
