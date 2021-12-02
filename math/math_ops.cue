//package for math operations
package math

import (
   "encoding/json"
)

//math function prototype: func(args)res
Op: {
  args: [int,int]  //input args
  res: int         //return result
  msg: string      //a text description of a math operation
}

Add: x=Op & {
  res: x.args[0]+x.args[1]
  msg: "Add \(json.Marshal(x.args)): \(res)"
}

Sub: x=Op & {
  res: x.args[0]-x.args[1]
  msg: "Substract \(json.Marshal(x.args)): \(res)"
}

Mult: x=Op & {
  res: x.args[0]*x.args[1]
  msg: "Mult \(json.Marshal(x.args)): \(res)"
}

//a generic math calc func, with polymorphic ops: Add,Del,Mult,Divide
Calc: x={
  //--calc input: input args and calc-op to invoke
  args: [...int] //input args
  op: Op //polymorphic Ops
  //--intermediate state: perform calc-op
  _compute: op & { args: x.args }
  //--final results: retrieve calc results here
  res: _compute.res
  msg: _compute.msg
}
