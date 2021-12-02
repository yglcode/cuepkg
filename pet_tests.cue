import (
   "github.com/yglcode/cuepkg/pet"
)

//instantiate objects
dog: pet.#Dog & {name:"Otto"}
cat: pet.#Cat & {name:"Kitty"}
bird: pet.#Bird & {name:"Parrot"}

//invoke obj methods
dog_sound: (dog.talk & {arg: "Master"}).res
dog_action: dog.do.res

cat_sound: cat.talk.res
cat_action: cat.do.res

bird_sound: bird.talk.res
bird_action: bird.do.res

//polymorphic behaviors
_pets: [...pet.#Pet] & [dog,cat,bird]
pets_actions: [for _, p in _pets { p.do.res }]
