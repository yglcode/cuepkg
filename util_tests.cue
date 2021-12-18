import (
        "list"
	"github.com/yglcode/cuepkg/util"
)

//--- test AnyOf and AllOf ---
val: {
	a: "A"
	d: "d"
	z: "zzz"
        util.#AnyOf & {#fields: ["x", "y", "z"]}
}
HasAnyOfXYZ: (util.#HasAnyFields & {value: val, fields: ["x", "y", "z"]}).res & true
HasAllOfADZ: (util.#HasAnyFields & {value: val, fields: ["a", "d", "z"], num: len(fields)}).res & true

//--- test UniqueItems: remove duplicates ---

dlist1: ["a", "b", "c", "a", "d", "c", "e"]
uniq1: (util.#UniqueItems & {items: dlist1}).res &
         ["a","b","c","d","e"] //verify return value
//#UniqueItemsByVal will keep later values
uniq2: (util.#UniqueItemsByVal & {items: dlist1}).res &
         ["b","a","d","c","e"] 
dlist3: [1, 2, 3, 2, 1, 4, 2, 5, 3, 6, 2]
uniq3: (util.#UniqueItems & {items: dlist3}).res &
         [1,2,3,4,5,6] 

//define keyFunc to remove duplicated structs by key
dlist4: [
	{key: "a", val: 1},
	{key: "b", val: 2},
	{key: "a", val: 1},
	{key: "b", val: 2},
	{key: "c", val: 2},
]
_keyFunc1: {
	value: {key: string} //list elem is any struct with key
	key: value.key
}
//remove duplicates by key
uniq4: (util.#UniqueItems & {items: dlist4, keyFunc: _keyFunc1}).res &
       [{key: "a",val: 1},{key: "b",val: 2},{key: "c",val: 2}] 

//--- verify list has required values ---
uniq3_has_2_3: (util.#HasRequiredItems & {items: uniq3, required: [2, 3]}).res & true
uniq3_has_23:  (util.#HasRequiredItems & {items: uniq3, required: [23]}).res & false

//--- test bounded recursion ---

// #RecFunc:
//    recursive function consist of user-func and recursive callSelf stub.
// #RecFuncCall:
//    bind a user #RecFunc and return a callable func, or
//    call a user #RecFunc with args and return result
//
// #RecFunc: { 
//    //user func which do real work and invoke recursive self call
//    //thru: (#callSelf & {args...}).result
//    #func: _ 
//
//    //recursive self call to "func"
//    //a call stub/placeholder to be filled by #RecFuncCall
//    #callSelf: _
// }

//a recursive add func: add(n)=n+(n-1)+(n-2)+...+2+1
#addUpToN: util.#RecFunc & {
  #callSelf: _ //stub to be filled by #RecFuncCall
  #func: {  
     n: int
     res: {
        if n <= 1 { n }
        let n1=n-1
        //make recursive self call
        if n > 1 { n+(#callSelf & {n: n1}).res }
     }
  }
}

// bind #RecFunc with stackDepth (default 10) and return a callable func
#callAddUpToN: util.#RecFuncCall & {#func:#addUpToN, #stackDepth:6}
// then invoke built func with data
addUpTo6: (#callAddUpToN & {n: 6}).res
// or all in one step
addUpTo6Again: (util.#RecFuncCall & {#func: #addUpToN, n: 6, #stackDepth:6}).res

//a recursive func to calc tree depth
#treeDepth: util.#RecFunc & {
  #callSelf: _ 
  #func: {  
     #in: _  //input tree data
     #basic: int | number | string | bytes | null
     out: {
	if (#in & #basic) != _|_ {1}
	if (#in & #basic) == _|_ {
            //make recursive self call on intermediate nodes
	    list.Max([ for k, v in #in {(#callSelf & {#in: v}).out}]) + 1
	}
     }
  }
}

treeA: {
	a: {
		foo: "bar"
		a: b: c: "d"
	}
	cow: "moo"
}

treeA_depth: (util.#RecFuncCall & {#func: #treeDepth, #in: treeA}).out
