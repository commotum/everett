# EVERETT-LIB Execution Loop

Use this protocol for every implementation session after the scaffold is
accepted. This file governs execution; `0-plan.md` remains the authoritative
strategy and status document. Do not begin a later stage because it looks easier
while an earlier dependency is incomplete, unless checked evidence requires a
reordering and both files are updated first.

## Repeatable Loop

1. Sync current state with the actual repository, Lean modules, source assets,
   documentation, tests, git diff, and pinned tool versions.
2. Update `goal-1/0-plan.md` with current facts before starting the next stage.
   If the repository contradicts the plan, record the contradiction and revise
   the plan before implementation.
3. Select the first incomplete stage whose prerequisites are satisfied.
4. Create or refresh `goal-1/[INDEX]-[SHORTHAND].md` from the template below.
   Preserve prior results when refreshing it.
5. Implement only that stage. Prefer narrow dependency leaves and the smallest
   proof surface that settles the stage's real obligations.
6. Add verification and no-cheating checks. Before formalizing a paper formula,
   verify its transcription against the local PDF/page image and update the
   source map/correction log.
7. Run focused Lean builds, required adjacent consumer builds, and then any full
   verification justified by the dependency impact. Run proof-hole, project-
   axiom, forbidden-shortcut, import, whitespace/diff, and source-traceability
   checks appropriate to the stage.
8. Record exact commands, outcomes, theorem names, failed obligations, source
   decisions, and lessons in the stage file.
9. Fold results back into `goal-1/0-plan.md`: update facts, assumptions, stage
   status, module names, theorem names, corrections, and downstream changes.
10. Continue toward the original objective. If stopping for the session, leave
    the goal resumable with current evidence, the next experiment or theorem,
    concrete unblock actions, and assumptions that still need challenge.

## Invariants

- Do not narrow the user's objective without saying so and recording why.
- Do not mark a stage complete without requirement-by-requirement evidence.
- Do not treat a green build as evidence unless the built declarations and tests
  cover the stated requirement.
- Prefer small, low-complexity stages and leaf modules that reduce uncertainty
  and minimize rebuilds.
- Convert blockers into work items: decompose them, probe the API, produce a
  counterexample, isolate a theorem, route around missing infrastructure, or
  state the exact unresolved obligation.
- Preserve the distinction between implementation, public API, verifier,
  diagnostic, source audit, analytic edge, and fallback path.
- Preserve user changes and unrelated dirty-worktree state. Never rewrite source
  assets merely to make OCR agree with a theorem.
- Check the PDF or page image before relying on an OCR equation. Put verbatim
  transcription facts in documentation; put mathematical repairs in theorem
  statements and the correction log.
- Keep vectors, normalized vectors, rays, weights, probability measures,
  coherent states, and mixtures distinct in both Lean and prose.
- Keep basis prescriptions, span maps, isometries, and unitaries distinct.
- Keep same-system repetition, independent copies, sequential observables, and
  multi-record interactions distinct.
- Never introduce `sorry`, `admit`, or a project axiom to get a completed module
  green. A failed obligation is a result to diagnose, not a license to assume it.
- Do not import an umbrella/API module into an internal leaf when a narrow import
  suffices. Keep heavy proofs and diagnostics out of high-fanout core modules.
- Update traceability and corrections in the same stage as the corresponding
  mathematics; do not postpone all source honesty to the release stage.
- Philosophical or interpretative statements remain documentation exclusions
  unless reduced to explicit mathematics and assumptions.

## Build And Verification Discipline

Before code changes:

1. Identify the lowest module that should own each declaration.
2. Identify high-fanout modules to avoid.
3. Classify each declaration as core runtime/data, public API, proof-side,
   diagnostic, source-specific, fallback, or temporary scaffolding.
4. Write the focused build command and necessary adjacent consumer builds in the
   stage file.
5. Write the source locations and mathematical obligations being implemented.

During code changes:

- Build after adding a module skeleton and after import changes.
- Name target definitions and theorem statements before beginning long proofs.
- Prefer local helper lemmas until multiple real consumers justify promotion.
- If proof search becomes slow, split the obligation or use explicit lemmas
  instead of widening global simp/instance behavior.
- Avoid global instances, notation, or `[simp]` declarations unless the stage
  needs them and adjacent consumers are rebuilt.

After code changes, adapt and run commands such as:

```text
lake build Everett.RelativeState.Core
lake build Everett.RelativeState.Reconstruction Everett.RelativeState.Examples
lake build Everett.API
lake build
rg -n --glob '*.lean' '\bsorry\b|\badmit\b|^\s*axiom\b' .
rg -n 'FORBIDDEN_STAGE_SHORTCUT' Everett
git diff --check
```

For principal exported results, maintain an audit leaf containing `#print axioms`
commands or record an equivalent reproducible audit. Documentation mentions of
forbidden words are acceptable only when classified; unexplained Lean-code hits
are not.

Run a full build when a stage changes the lake configuration, public API,
high-fanout imports, notation, global instances, simp behavior, or when its
completion requirements explicitly demand one. Otherwise build the touched leaf
and the smallest adjacent consumers that prove the intended surface.

## Stage File Template

```markdown
# [INDEX]-[SHORTHAND]

## Current Facts

- Facts from current code, tests, docs, source verification, and previous stage
  results.

## Updated Assumptions

- Assumptions that still look valid.
- Assumptions that changed.
- Assumptions that need tests before being trusted.

## Big Picture Objective

- Restate the stage objective, adjusted for current facts.

## Detailed Implementation Plan

- Concrete code/doc/test changes for this stage.
- Files expected to change.
- Source equations or claims that must be checked against PDF/page images.
- New tests, examples, or commands required.

## Build Structure

- New or touched Lean modules and why they own these declarations.
- High-fanout modules intentionally avoided.
- Focused build command.
- Adjacent consumer builds required.

## No-Cheating Checks

- Explicit checks proving the implementation does not route through forbidden
  fallback paths or conflate mathematical levels.
- Proof-hole, project-axiom, import, source-traceability, and interpretation
  boundary scans required for this stage.

## Completion Requirements

- Requirement-by-requirement checks.
- Required build and audit commands.
- Documentation, source-map, and correction-log updates required.

## Stage Results

- Fill in at the end of the stage.
- Include definitions, theorem names, and files added or changed.
- Include exact tests/builds/scans run and outcomes.
- Include source/OCR decisions and mathematical corrections.
- Include what was learned and any failed proof obligation.
- Include what should change in `0-plan.md` before the next stage.
```

## Fold-Back Checklist

Before stopping a stage or session:

1. Update its stage file with exact evidence.
2. Update `goal-1/0-plan.md` current facts, assumptions, architecture, and status.
3. Record exact declaration names and module paths.
4. Update `docs/source-map.md` and `docs/corrections.md` for touched paper claims.
5. Record failed obligations and their next diagnostic or construction action.
6. Leave the next stage resumable.

Do not mark the overall goal complete until the release audit covers the
original objective, all nine core mathematical claims, explicit exclusions, the
full build, and the axiom/source audits.
