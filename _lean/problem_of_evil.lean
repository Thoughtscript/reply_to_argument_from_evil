structure ArgumentFormulation where
  P1 : String
  P2 : String
  P3 : String
  P4 : String
  P5 : String
  P6 : String
  P7 : String
  P8 : String
  P9 : String
  C : String

def «Jeff Speaks Mackie Logical Argument from Evil formulation» : ArgumentFormulation :=
  { P1 := "God exists."
    P2 := "If God exists, then God is wholly good."
    P3 := "If something is wholly good, it always eliminates as much evil as it can."
    P4 := "If God exists, then God eliminates as much evil as God can. (2,3)"
    P5 := "If God exists, then God is omnipotent."
    P6 := "If something is omnipotent, it can do anything."
    P7 := "If God exists, then God can eliminate all evil. (5,6)"
    P8 := "If God exists, then God eliminates all evil. (4,7)"
    P9 := "God eliminates all evil. (1,8)"
    C := "There is no evil. (9)" }
