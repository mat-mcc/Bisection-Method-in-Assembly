
# Bisection Method in AArch64 Assembly

This project implements the **bisection method**, a classic numerical root-finding algorithm, using **AArch64 assembly**. It evaluates a user-defined polynomial over a closed interval and iteratively narrows the range to approximate a root within a configurable tolerance.

---

## Features

- Root-finding for arbitrary-degree polynomials
- Double-precision floating-point arithmetic
- Interval halving based on sign analysis (`f(c)` vs. 0)
- Outputs:
  - Approximate root `x`
  - Function value `f(x)` at that point

---

## Data Configuration

Polynomial coefficients, bounds, and precision tolerance are declared in the `.data` section of the program:

```asm
coeff:  .double 0.2, 3.1, -0.3, 1.9, 0.2   // Coefficients of f(x)
N:      .dword 4                          // Degree of the polynomial
a:      .double -1                        // Lower bound of the interval
b:      .double 1                         // Upper bound of the interval
tau:    .double 0.01                      // Error tolerance
