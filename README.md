# Everett Relative-State Lean Library

A pinned Lean 4/mathlib reconstruction of the reusable finite-dimensional
mathematics in Hugh Everett III's 1957 “Relative State” paper.

The library formalizes intrinsic conditional vectors, normalization and phase,
finite ideal measurements, exact records and repetition, additive and product
branch weights, finite frequency bounds, multi-record/sequential behavior, and
a deliberately scoped comparison with projective-collapse predictions. It also
contains an optional finite controlled-shift analogue of the paper's continuous
measurement example.

Use `import Everett.API` for the stable core surface. Build with:

```text
lake build
lake build Everett.DownstreamSmoke Everett.Audit
```

The toolchain and mathlib revision are committed and exact. See
`docs/extending.md` for clean-clone and extension guidance,
`docs/source-map.md` for equation-by-equation status,
`docs/corrections.md` for repairs to the paper/OCR, and
`docs/analytic-edge.md` for unresolved continuous-variable obligations.

The project does not formalize interpretative or metaphysical claims, does not
represent Dirac deltas as Hilbert vectors, and does not infer almost-sure results
from finite convergence in probability.
