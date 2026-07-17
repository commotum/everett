# 12-RELEASE-AUDIT

## Current Facts

- Stages 1-11 have focused compiling modules, examples, source statuses, and
  explicit corrected/unresolved boundaries.
- `Everett.lean` is still a temporary staged root. The stable public surface,
  downstream import smoke test, and principal-export axiom report do not exist.
- The optional finite analytic analogue intentionally remains outside the core
  root.

## Updated Assumptions

- `Everett.API` will re-export only reusable core modules; examples, smoke
  probes, audit declarations, and the optional analytic analogue remain out.
- `Everett.lean` will become a compatibility root importing `Everett.API` plus
  private diagnostic examples.
- Standard mathlib axioms such as choice, quotient soundness, and
  propositional extensionality may appear and must be recorded; any project
  axiom or proof hole is a release failure.

## Big Picture Objective

- Produce an intentional, downstream-usable API and an evidence-backed final
  audit of every original claim and every build/proof-integrity boundary.

## Detailed Implementation Plan

- Add `Everett/API.lean`, `Everett/Audit.lean`, and a narrow downstream import
  consumer. Keep the analytic analogue optional.
- Add extending/build documentation with pinned-toolchain commands and API
  boundaries.
- Sweep the source map for scheduled/TODO statuses and the implementation for
  proof holes, project axioms, forbidden shortcuts, broad imports, and silent
  overclaims.
- Run all focused example families, optional analytic examples, API/root/full
  builds, `git diff --check`, and repository status/diff review.
- Run `#print axioms` for principal theorem exports and document every reported
  logical axiom category.

## No-Cheating Checks

- No stage is complete merely because documentation labels an item unresolved;
  each unresolved item must name a precise missing framework and preserve every
  stronger proved finite theorem.
- No diagnostics/examples leak into `Everett.API`.
- No analytic import leaks into the core API/root.
- No `sorry`, `admit`, `proof_wanted`, unexplained project axiom, or silent
  strengthening remains.

## Completion Requirements

- Stable API and downstream consumer compile under the pinned lockfile.
- Every important paper item has a final classified status.
- All focused, optional, root, and full builds plus scans pass.
- Axiom audit is recorded and contains no unexplained project axiom.
- Final repository diff/status is reviewed; completion evidence is folded into
  the main plan.

## Stage Results

- `Everett.API` is a thin public re-export of all finite core theorem families.
  It excludes examples, smoke probes, audit declarations, and the optional
  analytic analogue. `Everett.lean` now wraps that API for compatibility while
  privately importing diagnostic examples.
- `Everett.DownstreamSmoke` imports only `Everett.API` and compiles intrinsic
  conditional and product-weight uses as a downstream consumer.
- `README.md` and `docs/extending.md` give pinned clean-clone commands, stable
  versus optional imports, and the extension invariants. Final source-map
  headers/statuses contain no scheduled work.
- `docs/audit.md` checks the nine claim families individually, preserving the
  assumption-qualified, partial, analogue-only, excluded, and unresolved
  statuses rather than promoting them to full formalizations.
- `Everett.Audit` checks 17 principal exports. Every `#print axioms` result is
  exactly `[propext, Classical.choice, Quot.sound]`; these are documented
  standard Lean/mathlib logical axioms and no project-specific axiom appears.
- API/downstream/audit build: 2,375 jobs. Complete diagnostic matrix: 2,384
  jobs. Optional analytic build: 2,357 jobs. Clean full build: 2,974 jobs.
- Proof-hole/project-axiom, unsafe/shortcut, broad-import, interpretation,
  overclaim, API-leak, analytic-boundary, final-status, and trailing-whitespace
  scans plus `git diff --check` pass. Base and `origin/master` both remain
  `0f924f53940cef225b01d8f98cd33fde8d659c4c`; the implementation is the reviewed
  working-tree change on top.
