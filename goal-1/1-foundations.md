# 1-FOUNDATIONS

## Current Facts

- The clean checkout was fetched and fast-forwarded from `5a54867` to
  `0f924f5`; Stage 1 begins with local `master` equal to `origin/master`.
- No Lean package, toolchain pin, lake configuration, or mathlib dependency
  exists yet.
- Direct probes report Lean `4.31.0` at commit `68218e8` and Lake `5.0.0`.
  `elan show` aborts under the restricted sandbox, so it is not usable as a
  verification command here.
- The paper PDF, OCR Markdown, and page images 1-9 are tracked. Images 3-9 were
  inspected directly for equations (1)-(34), Rules 1-2, the frequency passage,
  and the three multiple-record cases.
- The OCR is materially unreliable: it loses equation (9)'s notation, mangles
  radicals/exponents in (27), and reads page 9's “not in general” as “mot in
  general,” among other symbol errors.

## Updated Assumptions

- A finite-dimensional first milestone remains appropriate, while the
  conditional-vector definition should use the general completed tensor-product
  API if the focused probe stays small.
- The installed Lean version suggests pinning Lean and mathlib at `v4.31.0`, but
  the matching upstream mathlib tag and its exact revision must be verified
  before the lockfile is accepted.
- Critical APIs must be established by compiling probes rather than inferred
  from remembered mathlib names.
- Equation (27)'s claim that additivity forces linearity requires later
  mathematical qualification; positivity/nonnegativity is a material
  hypothesis, not merely prose decoration.

## Big Picture Objective

- Create the smallest reproducible Lean 4/mathlib package, compile probes for
  every API family needed downstream, settle scalar/inner-product and tensor
  conventions, and install source/traceability guardrails grounded in the page
  images.

## Detailed Implementation Plan

- Add `lean-toolchain`, `lakefile.toml`, `lake-manifest.json`, a package root,
  and `Everett/Foundations/Smoke.lean`.
- Pin mathlib to a verified revision compatible with Lean `v4.31.0`.
- Compile real probes for complex inner-product spaces, completed tensor
  products, orthonormal bases, continuous linear maps, linear isometries,
  unitary operators, vector normalization, finite probability measures, and
  product measures.
- Prove a compiling sanity lemma fixing mathlib's complex inner-product
  convention and a pure-tensor sanity lemma fixing tensor notation/order.
- Create `docs/conventions.md`, `docs/source-map.md`, `docs/corrections.md`, and
  `docs/scope.md`. Seed all equations (1)-(34), Rules 1-2, the page-8 frequency
  claims, and page-9 cases 1-3 from direct image inspection.
- Record exact build and scan results here and fold stable facts into
  `goal-1/0-plan.md`.

## Build Structure

- `Everett/Foundations/Smoke.lean` is a diagnostic/proof leaf for API probes;
  later runtime modules will not import it.
- `Everett.lean` is the temporary package root required for a full build; a
  deliberate `Everett.API` will replace its public role in the release stage.
- No mathematical core or future high-fanout API module is introduced in this
  stage.
- Focused build: `lake build Everett.Foundations.Smoke`.
- Adjacent/full build required because this stage creates package configuration:
  `lake build`.

## No-Cheating Checks

- Every probe must instantiate or state a declaration using the actual API; an
  import-only smoke file is insufficient.
- The inner-product convention must be demonstrated by a compiling scalar
  identity, not asserted only in prose.
- Source-map transcription facts must cite the page image and classify later
  formalization status without treating OCR as authoritative.
- Scan Lean sources for `sorry`, `admit`, and project `axiom` declarations.
- Scan for `FORBIDDEN_STAGE_SHORTCUT`, review imports, run
  `git diff --check`, and confirm docs exclude philosophical prose from theorem
  targets.

## Completion Requirements

- `lean-toolchain`, lake configuration, and a manifest pin an exact reproducible
  Lean/mathlib combination.
- `lake build Everett.Foundations.Smoke` and `lake build` pass.
- The smoke module exercises every named critical API family and proves the
  scalar/tensor convention lemmas.
- All four documentation files exist; the source map covers equations (1)-(34),
  Rules 1-2, frequency language, and all three page-9 cases.
- OCR and mathematical corrections are distinguished and downstream effects
  are recorded.
- Proof-hole/project-axiom/shortcut scans and `git diff --check` pass.

## Stage Results

- Completed the repository sync: `git fetch --prune origin` advanced
  `origin/master` from `5a54867` to `0f924f5`; `git merge --ff-only
  origin/master` then fast-forwarded the clean local checkout to `0f924f5`.
- Verified upstream tag `v4.31.0` with `git ls-remote`; it resolves to mathlib
  commit `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.
- Added `lean-toolchain`, `lakefile.toml`, and the generated
  `lake-manifest.json`. `lake update` completed, checked out the exact mathlib
  revision and transitive revisions, and downloaded/decompressed 8,542 cached
  build files. Added `.lake/` to `.gitignore`.
- Added diagnostic module `Everett.Foundations.Smoke` and temporary package root
  `Everett.lean`.
- The smoke module proves:
  - `Everett.Foundations.inner_smul_left_convention` (conjugate-linear first
    argument);
  - `Everett.Foundations.inner_smul_right_convention` (linear second argument);
  - `Everett.Foundations.tensor_inner_convention` (pure-tensor factor order).
- The same module compiles concrete probes for `ContinuousLinearMap`,
  `LinearIsometry`, `LinearIsometryEquiv`, `NormedSpace.normalize`, a standard
  two-dimensional `OrthonormalBasis`, finite-dimensional tensor completeness,
  `ProbabilityMeasure`, finite `Measure.pi`, and infinite
  `Measure.infinitePi`.
- The first smoke build failed because Lean 4.31 requires imports before module
  declarations/doc comments; adding the `module` header fixed that package
  convention. The next probe exposed exact namespace/signature differences
  (`NormedSpace.normalize`, `MeasureTheory.ProbabilityMeasure`, scalar argument
  order for `inner_smul_*`) and the lack of an inferred general tensor
  `CompleteSpace`. The corrected finite-dimensional probe uses
  `FiniteDimensional.complete ℂ _`.
- Checked mathlib source
  `Mathlib.Analysis.InnerProductSpace.TensorProduct`: it supplies the
  inner-product structure on the algebraic tensor product and explicitly lists
  completion as a TODO. This contradicts the original completed-tensor API
  assumption. Stages 2-4 will use the finite-dimensional algebraic tensor
  product; an infinite-dimensional completed construction is not silently
  assumed.
- Directly inspected local images 3-9 (printed pp. 456-462), covering equations
  (1)-(34), Rules 1-2, the frequency passage, and cases 1-3. Created:
  - `docs/conventions.md` for scalar, tensor, normalization, map, and probability
    conventions;
  - `docs/source-map.md` with an entry for every required source item;
  - `docs/corrections.md` separating OCR repairs from mathematical repairs;
  - `docs/scope.md` for the finite target, analytic edge, and interpretation
    exclusions.
- Verification evidence:
  - `lake build Everett.Foundations.Smoke` — success, 2,946 jobs;
  - `lake build` — success, 2,948 jobs;
  - `rg -n --glob '*.lean' '\bsorry\b|\badmit\b|^\s*axiom\b' Everett
    Everett.lean` — exit 1, no matches;
  - `rg -n --glob '*.lean' 'FORBIDDEN_STAGE_SHORTCUT' Everett Everett.lean` —
    exit 1, no matches;
  - forbidden-interpretation scan over Lean sources — exit 1, no matches;
  - import listing confirms the smoke leaf uses five named mathlib leaves and
    no `Mathlib` umbrella import;
  - `git diff --check` — exit 0.
- No failed Stage 1 mathematical obligation remains. The first Stage 2
  experiment is to construct the intrinsic first-factor contraction as a
  `TensorProduct.lift` into the second factor under finite-dimensional complex
  inner-product hypotheses, then determine the narrowest continuity wrapper.
