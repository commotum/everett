# Continuous-Variable Boundary and Finite Analogue

Images 3-4 (printed pp. 456-457) were reinspected directly on 2026-07-16.
The equation-safe readings relevant here are:

- (4) `H_I = -iℏ q (∂/∂r)` during `0 ≤ t ≤ T`;
- (5) `ψ_t^{S+A}(q,r) = φ(q)η(r-qt)`;
- (6) `iℏ(∂ψ_t^{S+A}/∂t) = H_I ψ_t^{S+A}`;
- (7) at `T`, the displayed decomposition is
  `∫ φ(q') δ(q-q') η(r-q'T) dq'`;
- (8) `ξ^{r'}(q) = N_{r'} φ(q) η(r'-qT)`, followed by the
  unnumbered normalization equation
  `(1/N_{r'})² = ∫ φ*(q)φ(q)η*(r'-qT)η(r'-qT)dq`.

The text then makes an approximation claim when `η` is sufficiently sharp. Its
footnote explicitly observes that the relative states generally cannot be
obtained from the original system state by a projection: idempotence would
force a relation of the form `η² = η`, which generally fails.

## What compiles

`Everett.Analytic.ControlledShift` works over any finite additive coordinate
group `G`. It constructs the unitary basis permutation
`(q,r) ↦ (q,r+q)`, proves the exact prepared-input rule
`|q⟩|0⟩ ↦ |q⟩|q⟩`, derives the correlated output for arbitrary finite
superpositions, and computes its intrinsic conditional vector. This is a finite
analogue of translation/correlation only. The cyclic wraparound example makes
the finite boundary explicit.

## Exact unresolved obligations

A continuous version of (5) should first define the shear on
`L²(ℝ_q × ℝ_r)`, prove that `(q,r) ↦ (q,r-qT)` is measure preserving with the
needed measurability, and construct the induced unitary independent of chosen
representatives.

Equations (4) and (6) additionally require a dense domain for the unbounded
operator corresponding to `q ⊗ (-iℏ∂/∂r)`, a self-adjointness or generator
theorem, a precise strong/mild solution notion, differentiability in `t`, and
domain preservation. None is inferred from the finite permutation.

Equation (7) is not an equality of ordinary `L²` vectors term by term because
`δ(q-q')` is a distribution/generalized eigenstate. A proof needs a rigged
Hilbert or distributional framework and a named weak equality notion.

Equation (8) uses sharp-coordinate conditioning. Point evaluation at `r'` is
not defined on an arbitrary `L²` equivalence class. A valid theorem needs a
direct-integral/disintegration or chosen-representative construction, an
almost-everywhere statement, measurability of the fibers, and an explicit
nonzero condition before normalization. Quantifying “sufficiently sharp” also
requires a topology or error bound and a specified localized family.
