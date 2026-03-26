/
init.q: minimal test framework for Q
Provides assertion primitives and a test runner.

Usage:
  test_foo:{.t.eq[1+1;2;"basic math"]}
  test_bar:{.t.near[sqrt 2;1.414;0.001;"sqrt approx"]}
  qt:use`cutie
  qt.run[]  / runs all test_* functions
\

/ ANSI color helpers (ESC = char 27)
esc_:enlist "c"$27;
green_:esc_,"[32m";
red_:esc_,"[31m";
reset_:esc_,"[0m";

/
Assertion primitives - signal on failure
\

/ Assert equal (uses ~ for comparison)
/ @param a - actual value
/ @param e - expected value
/ @param m - message describing what's being tested
eq:{[a;e;m]
  if[not a~e;
    '"EQ: ",m,"\n  expected: ",(-3!e),"\n  actual:   ",-3!a]};

/ Assert not equal
/ @param a - actual value
/ @param e - value that should NOT match
/ @param m - message
neq:{[a;e;m]
  if[a~e;
    '"NEQ: ",m,"\n  did not expect: ",-3!e]};

/ Assert condition is true
/ @param c - condition (should be 1b)
/ @param m - message
true:{[c;m]
  if[not c;'"TRUE: ",m]};

/ Assert condition is false
/ @param c - condition (should be 0b)
/ @param m - message
false:{[c;m]
  if[c;'"FALSE: ",m]};

/ Assert values are approximately equal (for floats)
/ @param a - actual value
/ @param e - expected value
/ @param t - tolerance
/ @param m - message
near:{[a;e;t;m]
  if[t<abs a-e;
    '"NEAR: ",m,"\n  expected: ",(-3!e)," +/-",(-3!t),"\n  actual:   ",-3!a]};

/ Assert all elements approximately equal (for float vectors)
/ @param a - actual vector
/ @param e - expected vector
/ @param t - tolerance
/ @param m - message
allnear:{[a;e;t;m]
  if[not all t>abs a-e;
    '"ALL NEAR: ",m,"\n  expected: ",(-3!e)," +/-",(-3!t),"\n  actual:   ",-3!a]};

/
Test runner
\

/ Run a single test, return (name;passed;detail)
/ @param n - test function name (symbol)
/ @return (name;1b;"") on pass, (name;0b;error) on fail
run1:{[n]
  r:@[{x[];(1b;"")};n;{(0b;x)}];
  (n;r 0;r 1)};

/ Find all test_* functions in current namespace
/ @return list of symbols
discover:{
  f:key`.;
  f where f like "test_*"};

/ Run tests and print results
/ @param ts - list of test names (symbols), or () to auto-discover
/ @return count of failures
run:{[ts]
  if[(::)~ts;ts:discover[]];
  if[0=count ts;-1"No tests found.";:0];

  res:run1 each ts;

  {[r]
    $[r 1;
      -1(green_,"[PASS] "),reset_,string[r 0];
      -1(red_,"[FAIL] "),reset_,string[r 0]]
  } each res;

  passed:sum res[;1];
  failed:(count res)-passed;
  -1"";
  -1(string count res)," tests, ",string[passed]," passed, ",string[failed]," failed";

  if[failed>0;
    -1"";
    -1"FAILURES:";
    -1"─────────";
    {[r]
      if[not r 1;
        -1"  ",string[r 0],":";
        -1"    ",ssr[r 2;"\n";"\n    "];
        -1""]
    } each res];

  failed};

/ Convenience: run all tests
runall:run;

export:([eq;neq;true;false;near;allnear;run1;discover;run;runall]);
