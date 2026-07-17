# Mathematical and Lean Conventions

## Reproducible environment

- Lean is pinned by `lean-toolchain` to `leanprover/lean4:v4.31.0`.
- Mathlib is pinned by `lakefile.toml` and `lake-manifest.json` to commit
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` (upstream tag `v4.31.0`).
- `Everett.Foundations.Smoke` is the compiling convention/API audit leaf. It is
  diagnostic and must not become an internal runtime dependency.

## Scalars and inner products

The first library milestone uses complex inner-product spaces. Mathlib's
`inner ℂ x y` is conjugate-linear in `x` and linear in `y`:

```text
inner ℂ (c • x) y = conj c * inner ℂ x y
inner ℂ x (c • y) = c * inner ℂ x y
```

These are proved as `Everett.Foundations.inner_smul_left_convention` and
`Everett.Foundations.inner_smul_right_convention`. Consequently, a conditional
vector characterized by

```text
inner ℂ y (conditional x Ψ) = inner ℂ (x ⊗ₜ y) Ψ
```

is conjugate-linear in the selected vector `x` and linear in the bipartite
vector `Ψ`. Later coefficient and phase theorems must preserve this orientation.

## Tensor products

`x ⊗ₜ[ℂ] y` places `x` in the left factor and `y` in the right factor. The
compiling sanity theorem `Everett.Foundations.tensor_inner_convention` states

```text
inner ℂ (x ⊗ₜ y) (x' ⊗ₜ y') = inner ℂ x x' * inner ℂ y y'.
```

Mathlib `v4.31.0` supplies this inner product on the algebraic tensor product
`H ⊗[ℂ] K`; the owning source explicitly lists completion as a TODO. There is no
general completed Hilbert tensor product API to rely on. For finite-dimensional
`H` and `K`, `H ⊗[ℂ] K` is finite-dimensional and can be given its justified
`CompleteSpace` instance using `FiniteDimensional.complete ℂ _`. Stages 2-4
therefore use the algebraic tensor product under explicit finite-dimensional
hypotheses unless a narrower theorem needs no completeness at all.

## Vectors, normalization, and rays

- A vector is not assumed to have unit norm.
- `NormedSpace.normalize 0 = 0`; this total mathlib function must not be used to
  pretend that a zero conditional defines a physical normalized branch.
- Public normalized-relative-state declarations require an explicit nonzero
  proof (or return a type that records partiality).
- Two nonzero vectors differing by a unit scalar may be phase-equivalent, but
  they are not definitionally equal. No ray quotient is assumed in Stage 1.

## Maps

The following levels remain distinct:

1. A prescription on a selected family of prepared states.
2. A `LinearMap` on the span.
3. A `ContinuousLinearMap` when boundedness is established.
4. A `LinearIsometry` when norm preservation is established.
5. A `LinearIsometryEquiv` for a surjective norm-preserving linear map (the
   finite-dimensional operator-level unitary representation used here).

Coercions may simplify application syntax but never justify promotion between
these levels.

Stage 4 realizes these distinctions concretely. `MeasurementData` records the
prepared family prescription, `PreparedSpanMap` has the actual prepared
subspace as its domain, `PreparedIsometry` carries norm preservation, and
`FullUnitary` carries a full-space `LinearIsometryEquiv`. `IdealData` assumes a
unit ready state and an orthonormal record family. Its canonical prepared
isometry is constructed from those hypotheses; its full unitary is then proved
to exist by finite-dimensional isometric extension and
injective-implies-surjective. Only named forgetful maps go in the reverse,
strong-to-weak direction.

## Probability

Branch data begins as nonnegative weights. It becomes a probability measure
only after a total-mass-one theorem or explicit normalization with positive
total mass. Mathlib APIs verified in the smoke leaf include
`MeasureTheory.ProbabilityMeasure`, finite `Measure.pi`, and infinite
`Measure.infinitePi`, each with `IsProbabilityMeasure` evidence.

Stage 7 introduces `FiniteDistribution`, a finite mass function bundled with
pointwise nonnegativity and a total-one proof. It is not a coherent vector and
is not automatically a measure. `FiniteDistribution.normalize` requires a
strictly positive total; `sequenceDistribution` instead requires a proved
one-step total of one and derives every finite product total using
`Fintype.sum_pow`.

## Source policy

The page PNGs and PDF are primary local evidence; the Markdown is OCR and only a
search aid. Material equations are checked against a page image before a theorem
depending on them is implemented. OCR repairs and mathematical repairs are
separate entries in `docs/corrections.md`.
