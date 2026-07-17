# Importing and Extending the Library

## Reproducing the build

The repository pins Lean `v4.31.0` in `lean-toolchain` and mathlib commit
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` in both `lakefile.toml` and
`lake-manifest.json`. From a clean clone with `elan`, `git`, and network access
for the first dependency fetch:

```text
git clone <repository-url> everett
cd everett
lake build
lake build Everett.DownstreamSmoke Everett.Audit
lake build Everett.Analytic.Examples
```

Do not run `lake update` when reproducing the audited dependency graph; the
committed manifest is the lockfile. `.lake/` is generated and ignored.

## Stable and optional imports

Downstream finite-dimensional work should use:

```lean
import Everett.API
```

`Everett.API` re-exports intrinsic relative states, ideal measurements,
repeatability and sequential measurement, neutral records, additive/product
weights, finite frequency bounds, multi-record locality, and scoped collapse
comparison. It does not import examples, source/audit leaves, or the analytic
analogue.

The explicitly optional finite translation analogue is imported separately:

```lean
import Everett.Analytic.ControlledShift
```

It must remain labeled as a finite analogue; see `docs/analytic-edge.md` before
attempting a continuous extension.

## Extension boundaries

- Extend conditional vectors from the intrinsic adjoint contraction; do not
  introduce a basis parameter into the definition.
- Require nonzeroness before normalization and state phase covariance rather
  than silently quotienting vectors into rays.
- Preserve the distinct types for prepared-family rules, span maps, isometries,
  and full unitaries.
- Keep same-system repetition, independently prepared copies, changing-basis
  sequences, and remote tensor-factor maps in separate APIs.
- Treat `FiniteDistribution` as classical mass data and coherent sums as
  vectors; never identify them by definitional equality.
- A stronger additive-weight theorem should close the documented half-line
  extension bridge rather than hide it in a typeclass or regularity axiom.
- An almost-sure frequency theorem must construct the infinite probability
  space, measurable coordinate process, and independence hypotheses.
- Continuous measurement work must supply the spaces, unbounded domains,
  equality semantics, and a.e. conditioning listed in the analytic boundary.

New runtime leaves should import the narrowest owning modules. Examples,
counterexamples, source-specific arguments, and `#print axioms` probes belong in
diagnostic/audit leaves and must stay out of `Everett.API`.
