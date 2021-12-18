package util

// functions implementing patterns at cuetorials.com/patterns
// design and main code from cuetorials.com/patterns, 
// turn them into reusable functions

import (
	"list"
)

//--- struct fields patterns ---

//#AnyOf: embedded into a struct to verify it has at least "num" of named fields
//#AllOf = #AnyOf & { #fields:[...], #num: len(#fields) }, because fields labels are unique
//val: {
//   x: int
//   ...
//   #AnyOf & {#fields:["x","y","z"]}
//}
#AnyOf: this={
	#fields: [...string]
	#num: *1 | >=1 & <=len(#fields)
	#res: true & list.MinItems([ for label, _ in this if list.Contains(#fields, label) {label}], #num)
	...
}

//#HasAnyFileds: verify a value/struct has at least "num" of named fields, eg:
//HasAny2XYZ: (#HasAnyFields & {value: val, fields:["x","y","z"],num:2}).res
#HasAnyFields: {
	value: {...} //any struct values
	fields: [...string] //field labels
	num: *1 | >=1 & <=len(fields)
	res: list.MinItems([ for label, _ in value if list.Contains(fields, label) {label}], num)
}

//--- list patterns ---

//#KeyFunc: extract key from list items value
#KeyFunc: {
	value: _ //list item value
	key:   _ //extracted key from value
}

//by default, values are used as keys
#defKeyFunc: {
	value: _
	key:   value
}

//remove duplicates in list, either remove duplicated simple values, 
//or remove by duplicated keys (if values are structs with key), eg:
//uniq: (#UniqueItems & {items:[...]}).res
#UniqueItems: {
	items: [...]
	keyFunc: *#defKeyFunc | #KeyFunc
	_set: {
		for e in items {
			"\((keyFunc & {value: e}).key)": e
		}
	}
	res: [ for s in _set {s}]
}

//remove duplicates in list by comparing values, keep later values, eg:
//uniqByVal: (#UniqueItemsByVal & {items:[...]}).res
#UniqueItemsByVal: {
	items: [...]
	res: [ for i, x in items if !list.Contains(list.Drop(items, i+1), x) {x}]
}

//verify that list has the requrired items (or keys for values with key), eg:
//has2and3: (#HasRequiredItems & {items:[1,2,3,4],required:[2,3]}).res & true
#HasRequiredItems: {
	items: [...]
	keyFunc: *#defKeyFunc | #KeyFunc
	required: [...]
	#set: {
		for e in items {
			"\((keyFunc & {value: e}).key)": e
		}
	}
	res: (#set & {for x in required {"\(x)": _}}) != _|_
}

//--- bounded recursion ---

// design and main code from cuetorials.com/deep-dive/recursion
// some renaming and rearrangement for understanding

// recursive function consist of user-func and recursive callSelf stub.
#RecFunc: { 
   //user func which do real work and invoke recursive self call
   //thru: (#callSelf & {args...}).result
   #func: _ 

   //recursive self call to "func"
   //a stub/placeholder to be filled by #RecFuncCall
   #callSelf: _
}

// bind a user #RecFunc and return a callable recursive func, or
// call a user #RecFunc with args and return result
#RecFuncCall: {
   //api:
   //max stack depth; if not deep enough, cue fail with "null" func error
   #stackDepth: *10 | int
   //recursive func to be invoked
   #func: #RecFunc

   //internal: build call stack
   _stack: [string]: #RecFunc
   for k, _ in list.Range(0, #stackDepth, 1) {
      _stack: "\(k)": #func & {#callSelf: _stack["\(k+1)"].#func}
   }
   _stack: "\(#stackDepth)": #func & {#callSelf: null}

   //start with func at stack top
   _stack["0"].#func
}
