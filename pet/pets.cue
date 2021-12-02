package pet

//signature of obj methods
#method: {
  arg?: string //optional input arg
  res: string  //res
}

//parent class
#Pet: {
   name: string
   talk: #method
   do: #method
}

//child classes
#Cat: x=#Pet & {
   talk: {
      arg?: string
      res: {
         if arg!=_|_ {
           "meow, \(arg), meow"
         }
         if arg==_|_ {
           "meow, meow, who are you?"
         }
      }
   }
   do: res: "\(x.name) is purring"
}

#Dog: x=#Pet & {
   talk: {
      arg?: string
      res: {
         if arg!=_|_ {
           "bark, \(arg), bark"
         }
         if arg==_|_ {
           "bark, bark, who are you?"
         }
      }
   }
   do: res: "\(x.name) is pacing"
}

