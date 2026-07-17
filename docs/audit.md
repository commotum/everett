# Release Audit

Audit date: 2026-07-16. The checked-out base and `origin/master` both resolve to
`0f924f53940cef225b01d8f98cd33fde8d659c4c`; the implementation is the reviewed
working-tree change on top of that base.

## Core-claim disposition

| Claim family | Release disposition |
|---|---|
| Relative vectors, normalization, phase, and equations (1)-(3) | Formalized with intrinsic conditionals, explicit zero/nonzero normalization, coordinate independence, reconstruction, and phase covariance. |
| Ideal measurement and Rules 1-2 | Formalized with distinct prescription, prepared-span, isometry, and full-unitary levels; superposition rules are linearity theorems. |
| Neutral records and repetition, equations (9), (18)-(24) | Formalized with length-indexed histories; same-system repeatability and independent-copy expansion are separate APIs. Dormant unmeasured spectator tensors in (20)-(23) are intentionally abstracted away and marked partial rather than equated to the record core. |
| Additive square weights, equations (25)-(31) | Assumption-qualified: proved for an additive all-real extension nonnegative on nonnegative inputs, deriving regularity and the square form. The bridge from the paper's exact half-line formulation remains explicit and unresolved. |
| Product weights, equations (32)-(34) | Formalized and linked to the independent-history amplitude theorem; normalized finite distributions compile. |
| Frequency/typicality | Finite expectation, variance, Chebyshev bound, and convergence in probability are formalized. Infinite-product almost-sure/measure-zero language remains unresolved because the required process was not constructed. |
| Multiple records and page-9 cases | Formalized at corrected scope: exact distinguished-basis copying, conditional/existential `A→B→A` disagreement, and explicit tensor-factor map commutation. No arbitrary cloning, universal disagreement, or unrestricted no-signalling theorem. |
| Collapse comparison | Assumption-qualified to `FiniteProjectiveExperiment`: one-step masses, nonzero normalized conditionals, and finite independent-repetition histories agree. Coherent vectors and classical mass data remain different types. |
| Continuous example, equations (4)-(8) | Finite controlled-shift analogue only. The continuous shear, unbounded generator, distributional delta, and a.e. conditioning obligations are individually unresolved in `docs/analytic-edge.md`. |

Interpretative/metaphysical prose is excluded from theorem statements. Every
paper item and correction is traceable in `docs/source-map.md` and
`docs/corrections.md`.

## Build evidence

The pinned tools report Lean `4.31.0` (commit `68218e8`) and Lake `5.0.0`.
`lake-manifest.json` pins mathlib commit
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.

- `lake build Everett.API Everett.DownstreamSmoke Everett.Audit` succeeds with
  2,375 jobs.
- All nine diagnostic example families plus the downstream consumer succeed in
  one matrix build with 2,384 jobs.
- `lake build Everett.Analytic.ControlledShift Everett.Analytic.Examples`
  succeeds with 2,357 jobs.
- `lake build` succeeds cleanly with 2,974 jobs.
- `git diff --check` and explicit PCRE trailing-whitespace scans pass.

`Everett.API` contains only reusable core imports. Import scans confirm that it
does not mention `Examples`, `Audit`, `Smoke`, or `Analytic`; neither
`Everett.API` nor the compatibility root imports the optional analytic leaf.

## Proof-integrity and axiom evidence

Scans over all project Lean sources find no `sorry`, `admit`, `proof_wanted`,
project `axiom`, broad umbrella `import Mathlib`, unsafe declaration, forbidden
interpretative term, or documented overclaim pattern. Every source-map entry
carries a final classified disposition.

`Everett.Audit` runs `#print axioms` on 17 principal exports spanning intrinsic
conditionals, reconstruction, unitary extension, repeatability, independent
histories, additive/product weights, finite frequency bounds, multi-record
copy/sequential/locality results, and all three collapse-comparison criteria.
Every export reports exactly:

- `propext`: Lean's propositional extensionality;
- `Classical.choice`: standard classical choice used by mathlib's
  finite-dimensional/noncomputable constructions;
- `Quot.sound`: standard quotient soundness used beneath quotient-based
  constructions such as tensor products and real/analytic infrastructure.

No project-specific axiom is reported.
