/
example.q: demonstrates all qt assertion primitives
Load and run:
  \l example.q
  qt.run[]
\

qt:use`cutie;

/ ============================================================================
/ eq: structural equality (uses ~)
/ ============================================================================

test_eq_integers:{
  qt.eq[2+2;4;"integer addition"]};

test_eq_symbol:{
  qt.eq[`foo;`foo;"symbol identity"]};

test_eq_list:{
  qt.eq[1 2 3;1 2 3;"integer list"]};

test_eq_mixed_list:{
  qt.eq[(1;`a;"x");(1;`a;"x");"mixed list"]};

/ ============================================================================
/ neq: assert two values are NOT equal
/ ============================================================================

test_neq_different_types:{
  qt.neq[1;1f;"int and float are not identical"]};

test_neq_different_values:{
  qt.neq[`a;`b;"distinct symbols"]};

/ ============================================================================
/ true / false: boolean conditions
/ ============================================================================

test_true_comparison:{
  qt.true[3>2;"3 is greater than 2"]};

test_true_membership:{
  qt.true[`b in `a`b`c;"symbol in list"]};

test_false_empty:{
  qt.false[0=count enlist 1;"singleton list is not empty"]};

test_false_comparison:{
  qt.false[1>2;"1 is not greater than 2"]};

/ ============================================================================
/ near: approximate float equality
/ ============================================================================

test_near_sqrt2:{
  qt.near[sqrt 2;1.41421356;1e-7;"sqrt 2 to 7 decimal places"]};

test_near_345_triangle:{
  qt.near[sqrt(3*3)+(4*4);5f;1e-10;"3-4-5 right triangle hypotenuse"]};

test_near_reciprocal:{
  qt.near[1%3;0.3333333;1e-6;"1%3 approximation"]};

/ ============================================================================
/ allnear: approximate equality for float vectors
/ ============================================================================

test_allnear_scaled:{
  a:1 2 3f;
  qt.allnear[a%max a;0.333333 0.666667 1f;1e-5;"min-max scaled vector"]};

test_allnear_cumsum:{
  qt.allnear[sums 0.1 0.1 0.1;0.1 0.2 0.3;1e-10;"cumulative sum of 0.1s"]};

/ ============================================================================
/ run
/ ============================================================================

qt.run[]
