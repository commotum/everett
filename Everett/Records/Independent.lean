module

public import Everett.Records.Branches
public import Mathlib.Algebra.BigOperators.Fin

/-!
# Independent-copy sequence branching

This coefficient/record evolution is separate from same-system repetition.
-/

@[expose] public section

namespace Everett.Records.Independent

open Everett.Records

variable {Outcome : Type*} [Fintype Outcome]

abbrev RecordSpace (Outcome : Type*) (n : ℕ) [Fintype Outcome] :=
  EuclideanSpace ℂ (History Outcome n)

noncomputable def encoding (Outcome : Type*) (n : ℕ) [Fintype Outcome] :
    Encoding Outcome n (RecordSpace Outcome n) :=
  Encoding.canonical Outcome n

/-- Product of one-copy amplitudes along a definite outcome history. -/
noncomputable def sequenceAmplitude (a : Outcome → ℂ) {n : ℕ}
    (h : History Outcome n) : ℂ :=
  ∏ k, a (h k)

omit [Fintype Outcome] in
@[simp]
theorem sequenceAmplitude_empty (a : Outcome → ℂ) :
    sequenceAmplitude a (History.empty Outcome) = 1 := by
  simp [sequenceAmplitude]

omit [Fintype Outcome] in
@[simp]
theorem sequenceAmplitude_snoc (a : Outcome → ℂ) {n : ℕ}
    (h : History Outcome n) (i : Outcome) :
    sequenceAmplitude a (History.snoc h i) = sequenceAmplitude a h * a i := by
  rw [sequenceAmplitude, Fin.prod_univ_castSucc]
  simp [History.snoc, sequenceAmplitude]

/-- One independent-copy branching step on canonical exact record spaces. -/
noncomputable def branchingStep (a : Outcome → ℂ) (n : ℕ) :
    RecordSpace Outcome n →ₗ[ℂ] RecordSpace Outcome (n + 1) :=
  ∑ i, a i • (encoding Outcome n).appendMap (encoding Outcome (n + 1)) i

@[simp]
theorem branchingStep_basis (a : Outcome → ℂ) (n : ℕ)
    (h : History Outcome n) :
    branchingStep a n ((encoding Outcome n).basis h) =
      ∑ i, a i • (encoding Outcome (n + 1)).state (History.snoc h i) := by
  classical
  simp [branchingStep, Encoding.appendMap_basis]

@[simp]
theorem branchingStep_state (a : Outcome → ℂ) (n : ℕ)
    (h : History Outcome n) :
    branchingStep a n ((encoding Outcome n).state h) =
      ∑ i, a i • (encoding Outcome (n + 1)).state (History.snoc h i) :=
  branchingStep_basis a n h

/-- The explicit coherent history expansion after `n` independent branches. -/
noncomputable def expandedState (a : Outcome → ℂ) (n : ℕ) : RecordSpace Outcome n :=
  ∑ h, sequenceAmplitude a h • (encoding Outcome n).state h

/-- One branching step carries the `n`-history expansion to the successor expansion. -/
theorem branchingStep_expandedState (a : Outcome → ℂ) (n : ℕ) :
    branchingStep a n (expandedState a n) = expandedState a (n + 1) := by
  classical
  rw [expandedState, map_sum]
  simp_rw [map_smul, branchingStep_state, Finset.smul_sum, smul_smul]
  rw [expandedState, ← (History.snocEquiv Outcome n).sum_comp]
  rw [Fintype.sum_prod_type]
  simp [sequenceAmplitude_snoc]

/-- Recursive state obtained by actually applying successive branching maps. -/
noncomputable def iteratedState (a : Outcome → ℂ) :
  (n : ℕ) → RecordSpace Outcome n
  | 0 => (encoding Outcome 0).state (History.empty Outcome)
  | n + 1 => branchingStep a n (iteratedState a n)

/-- Independent-copy sequence expansion, proved by induction from the recursive evolution. -/
theorem iteratedState_eq_expandedState (a : Outcome → ℂ) :
    ∀ n, iteratedState a n = expandedState a n := by
  intro n
  induction n with
  | zero =>
      simp [iteratedState, expandedState, sequenceAmplitude]
      exact congrArg (encoding Outcome 0).state (Subsingleton.elim _ _)
  | succ n ih =>
      rw [iteratedState, ih, branchingStep_expandedState]

/-- The final recursive state is the coherent product-amplitude history sum. -/
theorem iteratedState_eq_sum (a : Outcome → ℂ) (n : ℕ) :
    iteratedState a n =
      ∑ h, (∏ k, a (h k)) • (encoding Outcome n).state h := by
  rw [iteratedState_eq_expandedState]
  rfl

end Everett.Records.Independent
