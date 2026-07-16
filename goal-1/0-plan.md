# Everett Relative-State Lean Library

Shorthand goal: **EVERETT-LIB**

Status: scaffolded; no implementation stage has started.

## Big-Picture Objective

Build a pinned, compiling Lean 4/mathlib library that reconstructs the reusable
mathematical core of Hugh Everett III's 1957 paper, *"Relative State"
Formulation of Quantum Mechanics*. The library should make all domain,
normalization, orthogonality, independence, and regularity assumptions visible
in definitions and theorem signatures. It should prove the valid finite and
asymptotic results, repair or delimit claims that are not valid as printed, and
keep the paper's physical interpretation separate from its formal mathematics.

The first stable target is finite-dimensional complex Hilbert spaces. Greater
generality is earned theorem by theorem when mathlib supports it cleanly and it
does not obscure the hypotheses. Continuous-variable and generalized-eigenstate
claims are a separate analytic edge, not a prerequisite for the algebraic core.

## Non-Negotiable Constraints

- The paper is evidence, not a formal specification. Check every material
  equation, index, conjugation, normalization, and symbol against the local PDF
  or page image before depending on it.
- Preserve the distinction between vectors, normalized vectors, and rays.
- Preserve the distinction between an unnormalized conditional vector, the
  possible zero vector, a normalized relative state, and uniqueness up to phase.
- Define relative state intrinsically by a partial inner product or equivalent
  tensor universal construction. Coordinate expansions may prove formulas but
  may not define the concept in a basis-dependent way.
- Verify and document Lean/mathlib's inner-product convention before proving any
  coefficient or phase formula.
- A basis rule, an isometry on a prepared-input subspace, and a unitary on the
  full composite space are different objects. No theorem may silently pass from
  one to another.
- Record states used to encode distinguishable exact outcomes must carry the
  exact hypotheses actually needed, especially orthogonality when required for
  an isometry or branch decomposition.
- Rules 1 and 2 are consequences of linearity in the model, not new axioms.
- Same-system repetition, independent-copy measurements, sequential
  noncommuting measurements, and multi-record correlations are separate APIs
  and theorem families.
- Branch weights are mathematical weights until explicitly normalized into a
  probability distribution. Interpretative language such as actuality,
  experience, consciousness, or what an observer should expect does not belong
  in core theorem statements.
- The square-amplitude characterization must state its full domain and every
  additivity, phase-invariance, nonnegativity, and regularity assumption used.
  If the printed assumptions do not imply uniqueness, prove the strongest
  corrected theorem and record the gap.
- "Almost all," "typical," and "nearly zero" must become finite bounds,
  convergence in probability, or almost-sure statements over an explicitly
  defined measure.
- Do not formalize Dirac deltas or generalized position eigenvectors as Hilbert
  vectors. Use a justified finite or `L²` analogue, a distributional framework,
  or record the exact remaining obligation.
- Do not add `sorry`, `admit`, or unexplained project-specific axioms to a
  completed module. Do not disguise missing mathematics as a typeclass,
  classical-choice construction, or stronger unmotivated assumption.
- Keep internal modules narrow and dependency-layered. Heavy proofs,
  diagnostics, source audits, and examples stay out of low-level public modules.
- Do not declare the project complete because some abstractions compile. Each of
  the nine core claims in the objective must be proved separately or assigned a
  precise corrected/unresolved status with checked evidence.

## Current Facts

- The repository currently has no Lean project, lakefile, toolchain pin, or
  mathlib dependency.
- Lean `4.31.0` and Lake `5.0.0` are available through elan, but this installed
  version is not yet a project pin and says nothing about the selected mathlib
  revision.
- The source bundle contains `everett-1957/everett-1957.pdf`, nine page PNGs,
  and a 1,260-line OCR Markdown transcription.
- The OCR is visibly unreliable in equations and symbols. The page images or
  PDF must be treated as the local primary source.
- The relevant mathematical material is concentrated in the paper's relative
  state construction (printed equations 1-3), von Neumann measurement example
  (4-9), ideal observation rules and repeated observations (10-24), weighting
  argument (25-34), frequency discussion, and multiple-observer examples.
- `BUILD-PLAN.md` supplies the repository's generic Lean workflow: incremental
  leaf modules, import hygiene, focused builds, boundary scans, fold-back, and
  axiom/proof-hole auditing.
- `BUILD-PLAN.md` is presently untracked. It is an input to this plan, not a file
  this goal is authorized to modify.
- There are no existing `goal-*` directories, so this scaffold is `goal-1`.

## Assumptions To Test Early

- Mathlib's completed tensor product and inner-product APIs are sufficient for
  an intrinsic partial-inner-product map in the desired generality.
- A finite-dimensional first milestone will avoid irrelevant analytic overhead
  while retaining every algebraic claim needed for measurements and records.
- Finite orthonormal bases and `Fintype`-indexed families will provide a simpler
  reconstruction and branch API than immediately using general Hilbert bases.
- Mathlib already contains enough finite probability, product measure, variance,
  concentration, and strong-law infrastructure to reuse rather than reprove.
- A nonnegative additive function on nonnegative reals may yield the needed
  linearity without separately assuming continuity; the exact theorem and domain
  must be checked rather than presumed.
- Exact unitary extension of a prescribed prepared-apparatus isometry will be
  easiest and most reusable in finite dimensions; the infinite-dimensional
  extension statement may require extra complement/dimension hypotheses.
- A ray quotient may be unnecessary in the first public API if phase covariance
  and an explicit equivalence relation state the physical invariance more
  cleanly. This choice must be revisited after the conditional-vector API exists.

## Preliminary Architecture

The exact module names are provisional until Stage 1 import/API probes compile.
Prefer a small package root such as `Everett` with leaves along these boundaries:

```text
Everett/
  RelativeState/Core.lean
  RelativeState/Normalization.lean
  RelativeState/Reconstruction.lean
  RelativeState/Examples.lean
  Measurement/Core.lean
  Measurement/Linearity.lean
  Measurement/Repeatability.lean
  Records/History.lean
  Records/Multiple.lean
  Weights/Additive.lean
  Weights/Product.lean
  Probability/Frequency.lean
  Comparison/Collapse.lean
  Analytic/Approximation.lean       optional, only if justified
  Audit.lean
  API.lean
docs/
  conventions.md
  source-map.md
  corrections.md
  scope.md
  extending.md
```

`API.lean` should remain a thin, intentional public re-export. Diagnostics,
source-specific facts, counterexamples, and exhaustive finite checks should live
in proof/audit leaves. Internal leaves should import the narrowest dependency,
not `Everett.API`.

## Success Metrics And Final Verification

Completion means all of the following have evidence recorded in stage files and
folded back here:

1. A committed `lean-toolchain`, lake configuration, and pinned mathlib revision
   reproduce a clean build.
2. The library exposes an intrinsic unnormalized conditional vector for every
   bipartite vector and chosen subsystem vector; it proves basis independence,
   zero/nonzero behavior, normalization existence, phase behavior, and relevant
   reconstruction formulas.
3. Ideal measurement declarations distinguish prepared-subspace behavior,
   isometry, unitary extension, nondemolition/repeatability, and arbitrary
   interactions. The correlated-superposition rule follows from linearity.
4. Neutral record histories encode finite outcomes. Separate theorems cover
   same-system repeatability and coherent branches for independently prepared
   systems.
5. Sequence coefficient norms are proved to equal the corresponding product of
   single-outcome square norms and normalize to a finite product distribution.
6. The additive-weight uniqueness result is proved under inspectable sufficient
   hypotheses, with the paper's actual assumptions and any missing hypothesis
   documented precisely.
7. At least one explicit finite frequency bound is proved. Convergence in
   probability and an almost-sure result are added when their exact hypotheses
   and mathlib support are verified; otherwise the precise missing infrastructure
   is documented without weakening the finite result.
8. Multiple ideal record systems, communication/agreement, and the effect of an
   intervening noncommuting measurement are handled at the correct level of
   generality. Correlated but noninteracting systems are stated without a
   no-signalling or invariance claim stronger than the model proves.
9. Collapse comparison is restricted to a defined experiment language and a
   defined criterion such as matching conditional vectors or finite measurement
   distributions.
10. Representative finite-dimensional examples compile and exercise zero
    conditionals, product states, entangled states, phase changes, ideal
    measurements, repeated records, and sequence weights.
11. `docs/source-map.md` classifies every important paper item as formalized,
    corrected, split, assumption-qualified, analogue-only, partial, excluded, or
    unresolved. `docs/corrections.md` records OCR and mathematical corrections
    with downstream effects.
12. The full build, focused examples, proof-hole scans, forbidden-shortcut scans,
    `git diff --check`, and `#print axioms` audit of principal exports pass. Any
    standard logical axioms reported by Lean are explained; no unexplained
    project axiom remains.

## Stage Index

- [ ] `1-FOUNDATIONS` — pin the project, probe APIs, fix conventions, and create
  source/traceability guardrails.
- [ ] `2-CONDITIONAL` — define intrinsic unnormalized and normalized conditional
  vectors with zero and phase behavior.
- [ ] `3-RECONSTRUCTION` — prove coordinate formulas, basis independence,
  reconstruction, and finite examples.
- [ ] `4-MEASUREMENT` — model exact ideal measurement maps at their distinct
  linear/isometric/unitary levels and derive linearity rules.
- [ ] `5-RECORDS` — define neutral finite histories and coherent observation
  branches.
- [ ] `6-REPETITION` — prove same-system repeatability and independent-copy
  sequence expansions separately.
- [ ] `7-WEIGHTS` — characterize additive amplitude weights and build normalized
  branch/product distributions.
- [ ] `8-FREQUENCY` — prove finite concentration and justified asymptotic results.
- [ ] `9-MULTI-RECORD` — formalize agreement, communication, intervening
  measurements, and correlated noninteracting systems.
- [ ] `10-COMPARISON` — define and prove scoped comparisons with collapse-based
  predictions.
- [ ] `11-ANALYTIC-EDGE` — delimit or formalize the continuous-variable example
  without abusing Hilbert-space notation.
- [ ] `12-RELEASE-AUDIT` — stabilize the API, finish traceability, run examples,
  full builds, source audit, and axiom audit.

## 1-FOUNDATIONS

### Big Picture Objective

Create the smallest reproducible Lean/mathlib project and settle conventions and
source-control procedures before mathematical implementation begins.

### Detailed Implementation Plan

- Add a pinned Lean toolchain, lake package configuration, mathlib dependency,
  package root, and one smoke-test leaf.
- Probe the exact APIs for complex inner-product spaces, completed tensor
  products, orthonormal bases, continuous linear maps, linear isometries,
  unitary operators, normalization, finite probability measures, and product
  measures. Record exact imports and convention facts, not remembered names.
- Decide the first theorem generality: general Hilbert spaces where intrinsic
  maps are cheap, finite dimensions where bases, unitary extension, or finite
  distributions are essential.
- Create `docs/conventions.md`, `docs/source-map.md`, `docs/corrections.md`, and
  `docs/scope.md`. Seed the source map with printed equations 1-34, Rules 1-2,
  the frequency paragraph, and the three page-9 multi-observer cases.
- Verify the relevant OCR passages against the page PNG/PDF before transcribing
  them into the source map. Record uncertainty rather than guessing.
- Choose the concrete module dependency graph and focused build commands.

### Completion Requirements

- A fresh `lake build` succeeds with the pinned toolchain and dependency lock.
- A narrow smoke module compiles real instances/examples for every critical API
  family that later stages rely on.
- Inner-product linearity/conjugate-linearity and tensor notation conventions are
  stated with a compiling sanity lemma.
- Source map and correction log exist, cite page/equation locations, and clearly
  distinguish OCR repair from mathematical repair.
- The final module graph, high-fanout files, focused build commands, and first
  public names are recorded in the stage file and folded into this plan.
- No proof holes or project axioms exist; `git diff --check` passes.

## 2-CONDITIONAL

### Big Picture Objective

Expose the relative-state construction as an intrinsic partial inner product,
with total unnormalized output and partial/nonzero normalization semantics.

### Detailed Implementation Plan

- Define the unnormalized conditional vector of `Ψ : H₁ ⊗ H₂` relative to
  `x : H₁` using a tensor-universal/continuous-linear construction.
- Prove linearity in `Ψ`, the correct conjugate/phase behavior in `x`, behavior
  on pure tensors, norm bounds, and the exact zero criterion available from the
  API.
- Define a normalized conditional only behind an explicit nonzero hypothesis or
  as an explicit partial construction. Do not fabricate a default physical
  state for the zero branch.
- Prove unit norm, scaling/normalization formulas, uniqueness at the vector
  level, and phase covariance. Add a minimal ray-equivalence statement if it
  clarifies rather than complicates the API.
- Update conventions and source map for Everett's printed equation 2, including
  its suppressed zero case and normalization constant.

### Completion Requirements

- Focused builds pass for the conditional and normalization leaves and their
  direct examples.
- The public theorem signatures visibly distinguish the zero, nonzero,
  normalized, and phase-equivalent cases.
- Pure tensor, zero vector, orthogonal selected vector, and entangled two-level
  examples compile.
- A scan confirms the intrinsic definition does not depend on a selected basis.
- Equation 2 is classified and any correction is recorded with downstream
  consequences; no proof holes or project axioms remain.

## 3-RECONSTRUCTION

### Big Picture Objective

Connect the intrinsic conditional vector to basis expansions and prove that the
paper's coordinate procedure is basis independent.

### Detailed Implementation Plan

- For a finite orthonormal basis of the selected subsystem, prove the coefficient
  formula for conditional vectors with the verified inner-product convention.
- Prove reconstruction of a bipartite vector as a finite sum of basis vectors
  tensored with their unnormalized conditionals.
- Derive the normalized-relative-state version only for nonzero branches, keeping
  zero terms separate rather than dividing by zero.
- Prove invariance under changing the complement basis and, more strongly, that
  all coordinate presentations compute the same intrinsic vector.
- Add product and entangled-state examples that catch conjugation and phase
  mistakes. Compare printed equations 1-3 with the proved formulas.

### Completion Requirements

- Focused builds pass for reconstruction and examples, followed by the adjacent
  `RelativeState` API build.
- At least one non-real complex coefficient example verifies conjugation
  orientation; a rephased selected vector verifies ray/phase behavior.
- Reconstruction handles zero conditional components without an invalid
  normalization constant.
- Printed equations 1-3 have exact source-map statuses and checked corrections.
- No broad umbrella import is introduced into low-level relative-state leaves;
  proof-hole, project-axiom, shortcut, and whitespace scans pass.

## 4-MEASUREMENT

### Big Picture Objective

Model idealized measurement precisely and derive Everett's correlated
superposition rule from linearity.

### Detailed Implementation Plan

- Define finite outcomes, orthonormal system eigenstates, a ready record state,
  and outcome record states without embedding interpretative terminology.
- Represent separately: prescribed behavior on the prepared input family; the
  induced linear map on its span; an isometry of the prepared subspace; and a
  unitary on the full system-record tensor product.
- Prove the exact orthogonality/norm conditions under which the prescription is
  isometric. Prove or import a finite-dimensional unitary-extension theorem with
  all dimension/complement hypotheses visible.
- Define nondemolition and exact repeatability properties instead of assuming
  that every interaction has them.
- Prove that applying the measurement map to a finite superposition gives the
  correlated superposition. Treat Everett's Rules 1 and 2 as corollaries of
  linearity and composition.
- Classify equations 10-17 and the continuous von Neumann example separately.

### Completion Requirements

- Each map level has a distinct type/name and conversion theorem; source scans
  show no silent coercion is used to claim a stronger level.
- The correlated-superposition theorem and a spectator-system/naturality theorem
  compile from linearity alone.
- The unitary-extension result either compiles under explicit sufficient
  hypotheses or is recorded as a checked obstruction while the isometric core
  remains complete; it may not be assumed.
- Two-level and multi-outcome exact measurement examples compile.
- Equations 10-17 and Rules 1-2 are traceable; proof-hole, project-axiom, import,
  and whitespace checks pass.

## 5-RECORDS

### Big Picture Objective

Build reusable, mathematically neutral infrastructure for finite outcome
histories and coherent record branches.

### Detailed Implementation Plan

- Represent a finite record as a length-indexed outcome sequence with explicit
  empty, append, lookup, and prefix behavior.
- Define orthonormal record encodings and the assumptions needed to extend a
  history by one outcome isometrically.
- Define branch labels, branch vectors, amplitudes, and a coherent finite sum.
  Keep this representation distinct from a density operator or classical
  mixture.
- Prove orthogonality of distinct record branches under explicit record-state
  orthogonality assumptions and derive branch norm/sum identities.
- Make observer/apparatus terminology optional aliases or documentation only.

### Completion Requirements

- The record core does not mention consciousness, awareness, actuality, or
  primitive probability.
- Empty/singleton/append examples compile, and distinct histories have the
  claimed orthogonality only under inspectable hypotheses.
- The coherent global vector and its classical index/weight data are different
  definitions with no accidental equality claim.
- Focused record/history builds and adjacent measurement builds pass; equations
  18-24 receive preliminary source-map entries.
- Proof-hole, project-axiom, forbidden-language, import, and whitespace scans
  pass.

## 6-REPETITION

### Big Picture Objective

Prove separately the algebra for repeating an ideal measurement on one system
and for measuring many independently prepared systems.

### Detailed Implementation Plan

- Prove same-system repeatability: a nondemolition ideal measurement with an
  existing matching record appends the same outcome and preserves agreement.
- State exactly what fails if the system eigenstate is disturbed, the record
  encoding is nonorthogonal, or the second interaction measures another basis.
- For `n` independently prepared copies, define the iterated measurement map and
  prove by induction that the final vector is a coherent sum over outcome
  sequences with product amplitudes.
- Prove the tensor/order bookkeeping lemmas needed for reusable sequential
  composition without conflating independent copies with repeated measurement.
- Revisit equations 18-24 and document any OCR/index repairs.

### Completion Requirements

- Same-system repeatability and independent-copy expansion are separate exported
  theorems with visibly different inputs.
- The sequence expansion is checked for `n = 0`, `1`, and `2` and proved for
  arbitrary finite `n`.
- A negative or diagnostic example demonstrates why an arbitrary interaction or
  intervening basis change does not satisfy the repeatability theorem.
- Focused builds for repeatability and independent sequences pass, along with
  their adjacent record/measurement consumers.
- Equations 18-24 have final source-map statuses; scans and `git diff --check`
  pass.

## 7-WEIGHTS

### Big Picture Objective

Separate and verify the characterization of square-amplitude weights, branch
normalization, and the product distribution of independent preparations.

### Detailed Implementation Plan

- Formalize candidate radial weight functions with explicit domain,
  nonnegativity, phase invariance/radiality, zero behavior, and finite additivity
  under orthogonal refinement.
- Determine by proof or counterexample exactly which assumptions force
  `w(z) = c * ‖z‖²`. Use nonnegativity-derived monotonicity if sufficient; add
  continuity/measurability only if genuinely required.
- Keep the characterization theorem independent of quantum terminology.
- Define branch square weights from squared norms and prove finite additivity on
  orthogonal coherent decompositions.
- Normalize a finite branch family only under a positive total-weight hypothesis.
  For normalized input/measurement data, prove that the total is one.
- Prove that sequence branch weights equal products of one-step weights and
  package them as the appropriate finite product probability distribution.
- Audit printed equations 25-34 and Everett's uniqueness wording.

### Completion Requirements

- The exact assumptions of the uniqueness theorem are visible in its signature,
  and dropping any material assumption is discussed with a proof, counterexample,
  or precise open obligation.
- Additivity, normalization, and product form are three separate theorem groups.
- The product-weight theorem is linked formally to the sequence expansion from
  Stage 6, not merely reproved for an unrelated list of numbers.
- Finite sample distributions sum to one and agree with branch squared norms in
  compiling examples.
- Equations 25-34 and the prose uniqueness claim have final source-map/correction
  entries; all focused builds and scans pass.

## 8-FREQUENCY

### Big Picture Objective

Replace the paper's informal typicality claims with explicit finite and
asymptotic probability theorems over the branch-weight distribution.

### Detailed Implementation Plan

- Define empirical counts and frequencies for finite outcome sequences.
- Prove expectation and variance identities for indicators under the finite
  product distribution.
- Prove at least a Chebyshev-style finite bound; use Hoeffding or a sharper
  mathlib theorem if available without rebuilding substantial probability
  infrastructure.
- State convergence in probability as a separate corollary.
- Add an infinite product/process model and almost-sure convergence only after
  checking measurability, independence, and an applicable strong-law API. Never
  infer an almost-sure theorem merely from finite bad-set measures tending to
  zero.
- Translate each result back to total branch weight of exceptional finite
  histories. Treat general finite outcomes and binary examples explicitly.

### Completion Requirements

- A theorem gives an explicit bound in `n`, tolerance, and outcome weight for
  the total weight of histories whose empirical frequency deviates.
- Convergence in probability is proved from the finite theorem.
- Any almost-sure theorem has an explicit probability space, random variables,
  measurability, and independence hypotheses; otherwise it is marked unresolved
  without overstating the paper.
- Edge cases (`p = 0`, `p = 1`, empty outcome type where relevant, `n = 0`, and
  positive tolerance) are handled explicitly.
- The page-8 phrases "nearly zero," "almost all," and "in the limit" have exact
  source-map replacements; probability builds and all scans pass.

## 9-MULTI-RECORD

### Big Picture Objective

Formalize correlations among multiple ideal record systems without importing
claims about observers or reality.

### Detailed Implementation Plan

- Define communication as a controlled record-copy/correlation interaction and
  state its isometry/unitarity hypotheses.
- Prove agreement for multiple records of the same nondemolition eigenbasis,
  including the ordering where one record is copied before another system
  interaction.
- Model `A`-then-`B`-then-`A` and characterize the final two-`A` correlation in
  terms of change-of-basis amplitudes. Prove nonagreement is possible rather than
  claiming it for every pair labeled noncommuting.
- For correlated noninteracting bipartite systems, prove the appropriate local
  invariance/commutation statement and same-system repeatability under explicit
  tensor-factor locality. Do not smuggle in a collapse step.
- Link relative conditionals to record branches where useful.

### Completion Requirements

- Same-basis agreement, communication, intervening measurement, and remote local
  interaction are distinct theorems.
- The noncommuting-observable result matches what the algebra establishes; any
  stronger paper wording is corrected in the log.
- A two-qubit entangled example and an incompatible-basis example compile.
- The three page-9 cases have precise traceability statuses and assumptions.
- Focused multi-record builds, adjacent consumers, proof-hole/project-axiom
  scans, forbidden-interpretation scans, and whitespace checks pass.

## 10-COMPARISON

### Big Picture Objective

State a rigorous, deliberately scoped comparison between unitary record models
and collapse-based predictions.

### Detailed Implementation Plan

- Define a finite experiment language or other explicit class sufficient for the
  proved ideal projective measurements and record readouts.
- Define comparison criteria separately: equal branch distributions, equal
  conditional post-measurement vectors/rays, and equal distributions of later
  record readouts.
- Prove equivalence for the supported experiment class by induction/composition,
  using Stages 4-9.
- State exclusions: arbitrary POVMs/channels, approximate measurement,
  continuous spectra, unrestricted empirical equivalence, and interpretative
  claims unless separately implemented.
- Add counterexamples or boundary documentation showing why equality of a pure
  coherent global state is not equality with a classical collapsed mixture.

### Completion Requirements

- Every equivalence theorem names its experiment class and comparison criterion
  in the signature or immediately owning definition.
- No theorem claims unrestricted equivalence of interpretations.
- Coherent-state versus mixture distinctions are exercised by a finite example.
- Supported sequential experiments build end to end, and excluded cases are
  explicit in `docs/scope.md` and `docs/source-map.md`.
- Focused comparison builds, adjacent API builds, shortcut scans, and whitespace
  checks pass.

## 11-ANALYTIC-EDGE

### Big Picture Objective

Resolve the status of Everett's continuous-coordinate measurement example
without blocking or contaminating the finite algebraic library.

### Detailed Implementation Plan

- Recheck printed equations 4-9 against page images/PDF, including signs,
  factors of `i`, time dependence, translations, and delta notation.
- Identify the exact mathematical claim: translation generated by a coupling,
  an `L²` wavefunction identity, a generalized-eigenvector decomposition, or a
  mixture of these.
- Choose the smallest honest result: a finite-dimensional controlled-shift
  analogue; an `L²` translation/unitary statement; an approximation by localized
  wave packets; or a documented unresolved distributional theorem.
- Keep any heavy analysis in an optional leaf that the core API does not import.
- Record approximate versus exact claims and all missing analytic infrastructure.

### Completion Requirements

- Equations 4-9 have verified transcriptions and individual statuses.
- At least the controlled-shift finite analogue compiles and is explicitly
  labeled an analogue, not the continuous theorem.
- Any stronger analytic theorem included has valid function spaces, operators,
  domains, and equality notions; no Dirac delta is represented as an `L²` vector.
- Unresolved content names the exact proof obligation and required framework.
- Core builds remain independent of analytic-edge imports; focused builds and
  all scans pass.

## 12-RELEASE-AUDIT

### Big Picture Objective

Turn the verified stage outputs into a stable, documented, auditable reusable
library and ensure the original objective—not merely the easiest subset—has an
honest final status.

### Detailed Implementation Plan

- Stabilize names and expose only intentional declarations through `Everett.API`.
- Add representative end-to-end examples and a concise import/extension guide.
- Complete `docs/conventions.md`, `source-map.md`, `corrections.md`, `scope.md`,
  and `extending.md`, including dependent consequences of every material repair.
- Check all nine core claims one by one against exported theorem signatures.
- Run focused leaf builds, adjacent consumers, the full project build, examples,
  proof-hole and forbidden-shortcut scans, import review, `git diff --check`, and
  any formatter/linter supported by the pinned project.
- Run `#print axioms` (or an equivalent audit leaf) on every principal export and
  explain standard Lean/mathlib logical axioms separately from project axioms.
- Produce a final status report covering formalized results, assumptions,
  corrections, exclusions, unresolved analysis, build evidence, and extension
  guidance.

### Completion Requirements

- Clean-clone instructions reproduce the pinned build.
- Every planned module and example compiles; the public API imports without
  pulling audit/diagnostic/analytic leaves unintentionally.
- No `sorry`, `admit`, or unexplained project-specific axiom exists in Lean code.
- Each core claim is proved or has a precise non-success status supported by a
  checked obstruction; unresolved work remains explicit next work, not hidden.
- Source map covers equations 1-34, Rules 1-2, repeated measurements, weighting,
  frequency claims, multiple-record cases, and philosophical exclusions.
- The axiom audit, full build, example builds, scans, and whitespace checks are
  recorded with exact commands and outcomes.
- The final report explains how to import and extend the library and makes every
  material difference from the paper easy to locate.
