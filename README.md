# cutie

A minimal testing module for kdb+/q. Provides assertion primitives and a test runner, packaged as a [kdb-x module](https://code.kx.com/kdb-x/modules/module-framework/quickstart.html).

## Installation

Place the `cutie` directory on your module search path (`$QHOME/mod` by default).

## Usage

Load the module and bind it to a name:

```q
qt: use`cutie
```

Define test functions — any function named `test_*` in the root namespace is automatically discovered:

```q
test_add:{ qt.eq[1+1; 2; "integer addition"] };
test_sqrt:{ qt.near[sqrt 2; 1.41421356; 1e-7; "sqrt 2"] };
```

Run all tests:

```q
qt.run[]
```

Example output:

```
[PASS] test_add
[PASS] test_sqrt

2 tests, 2 passed, 0 failed
```

On failure:

```
[PASS] test_add
[FAIL] test_sqrt

2 tests, 1 passed, 1 failed

FAILURES:
─────────
  test_sqrt:
    NEAR: sqrt 2
      expected: 1.41421356 +/-1e-07
      actual:   1.414213562373095
```

You can also run a specific subset of tests by passing a list of symbols:

```q
qt.run`test_add`test_sqrt
```

## API

### `qt.eq[a; e; m]`

Asserts `a ~ e` (structural equality). Fails if they differ in value or type.

```q
qt.eq[1+1; 2; "basic addition"]
qt.eq[`foo; `foo; "symbol identity"]
qt.eq[(1;`a;"x"); (1;`a;"x"); "mixed list"]

/ Note: int and float are NOT structurally equal
qt.neq[1; 1f; "int vs float"]
```

### `qt.neq[a; e; m]`

Asserts `a` and `e` are not structurally equal.

```q
qt.neq[`a; `b; "distinct symbols"]
```

### `qt.true[c; m]`

Asserts condition `c` is `1b`.

```q
qt.true[3>2; "3 is greater than 2"]
qt.true[`b in `a`b`c; "symbol membership"]
```

### `qt.false[c; m]`

Asserts condition `c` is `0b`.

```q
qt.false[1>2; "1 is not greater than 2"]
```

### `qt.near[a; e; t; m]`

Asserts `abs[a-e] < t`. Use this instead of `eq` when comparing floats.

```q
qt.near[sqrt 2; 1.41421356; 1e-7; "sqrt 2"]
qt.near[1%3; 0.3333333; 1e-6; "reciprocal"]
```

### `qt.allnear[a; e; t; m]`

Like `near`, but for float vectors — asserts `all t > abs a-e`.

```q
a: 1 2 3f;
qt.allnear[a%max a; 0.333333 0.666667 1f; 1e-5; "normalised vector"]
```

### `qt.run[ts]`

Runs tests and prints results. Pass `()` or call as `qt.run[]` to auto-discover all `test_*` functions in the root namespace. Pass a symbol list to run specific tests.

Returns the count of failures (0 on full pass).

### `qt.discover[]`

Returns a list of all `test_*` symbols found in the root namespace. Useful for inspecting what would be run before calling `qt.run[]`.

## Example

See [`example.q`](example.q) for a runnable file that exercises every primitive.
