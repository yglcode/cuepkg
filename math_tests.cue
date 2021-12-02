import (
   m "github.com/yglcode/cuepkg/math"
)

sub11_2: (m.Sub & {args:[11,2]}).res
sub11_2info: (m.Sub & {args:[11,2]}).msg
//invoke thru polymorphic calc
add11_2info: (m.Calc & {args:[11,2],op:m.Add}).msg
mult11_2info: (m.Calc & {args:[11,2],op:m.Mult}).msg
