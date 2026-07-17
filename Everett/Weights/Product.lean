module

public import Everett.Records.Independent
public import Everett.Weights.Branch
public import Mathlib.Algebra.BigOperators.Ring.Finset

/-!
# Product weights for independent histories
-/

@[expose] public section

namespace Everett.Weights

open Everett.Records Everett.Records.Independent

variable {Outcome : Type*} [Fintype Outcome]

/-- One-outcome square-amplitude weight. -/
noncomputable def outcomeWeight (a : Outcome → ℂ) (i : Outcome) : ℝ :=
  ‖a i‖ ^ 2

/-- Square-amplitude weight of a definite finite history. -/
noncomputable def sequenceWeight (a : Outcome → ℂ) {n : ℕ}
    (h : History Outcome n) : ℝ :=
  ‖sequenceAmplitude a h‖ ^ 2

omit [Fintype Outcome] in
/-- The square weight of a product amplitude is the product of one-step weights. -/
theorem sequenceWeight_eq_prod (a : Outcome → ℂ) {n : ℕ}
    (h : History Outcome n) :
    sequenceWeight a h = ∏ k, outcomeWeight a (h k) := by
  simp [sequenceWeight, sequenceAmplitude, outcomeWeight, Finset.prod_pow]

/-- Total sequence weight is the `n`th power of total one-step weight. -/
theorem sum_sequenceWeight (a : Outcome → ℂ) (n : ℕ) :
    ∑ h : History Outcome n, sequenceWeight a h =
      (∑ i, outcomeWeight a i) ^ n := by
  simp_rw [sequenceWeight_eq_prod]
  exact (Fintype.sum_pow (outcomeWeight a) n).symm

/-- A normalized one-step amplitude family gives a finite outcome distribution. -/
noncomputable def outcomeDistribution (a : Outcome → ℂ)
    (hnorm : ∑ i, outcomeWeight a i = 1) : FiniteDistribution Outcome where
  mass := outcomeWeight a
  nonnegative _ := sq_nonneg _
  sum_mass := hnorm

/-- The finite product distribution on length-`n` histories. -/
noncomputable def sequenceDistribution (a : Outcome → ℂ)
    (hnorm : ∑ i, outcomeWeight a i = 1) (n : ℕ) :
    FiniteDistribution (History Outcome n) where
  mass := sequenceWeight a
  nonnegative _ := sq_nonneg _
  sum_mass := by rw [sum_sequenceWeight, hnorm, one_pow]

@[simp]
theorem sequenceDistribution_mass (a : Outcome → ℂ)
    (hnorm : ∑ i, outcomeWeight a i = 1) (n : ℕ) (h : History Outcome n) :
    (sequenceDistribution a hnorm n).mass h = sequenceWeight a h := rfl

/-- Product-distribution factorization, matching the sequence branch coefficient theorem. -/
theorem sequenceDistribution_mass_eq_prod (a : Outcome → ℂ)
    (hnorm : ∑ i, outcomeWeight a i = 1) (n : ℕ) (h : History Outcome n) :
    (sequenceDistribution a hnorm n).mass h =
      ∏ k, (outcomeDistribution a hnorm).mass (h k) := by
  exact sequenceWeight_eq_prod a h

end Everett.Weights
