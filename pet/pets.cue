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
#Cat: #Pet & {
   name: string
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
   do: res: "\(name) is purring"
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

//duck typing: #Bird doesn't need be subclass of #Pet
//unification will validate #Bird has all required properties at call/use site
#Bird: {
   name: string
   talk: {
      arg?: string
      res: {
         if arg!=_|_ {
           "chirp, \(arg), chirp"
         }
         if arg==_|_ {
           "chirp, chirp, who are you?"
         }
      }
   }
   do: res: "\(name) is flying"
}
