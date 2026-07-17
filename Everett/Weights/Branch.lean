module

public import Everett.Records.Branches
public import Everett.Weights.Additive

/-!
# Finite branch weights and normalization

Weights and probability distributions are separate bundled objects.
-/

@[expose] public section

namespace Everett.Weights

/-- A finite probability mass function with nonnegativity and total-one evidence. -/
structure FiniteDistribution (ι : Type*) [Fintype ι] where
  mass : ι → ℝ
  nonnegative : ∀ i, 0 ≤ mass i
  sum_mass : ∑ i, mass i = 1

namespace FiniteDistribution

variable {ι : Type*} [Fintype ι]

/-- Normalize arbitrary nonnegative weights with strictly positive total mass. -/
noncomputable def normalize (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i)
    (htotal : 0 < ∑ i, w i) : FiniteDistribution ι where
  mass i := w i / ∑ j, w j
  nonnegative i := div_nonneg (hw i) htotal.le
  sum_mass := by
    rw [← Finset.sum_div]
    exact div_self (ne_of_gt htotal)

@[simp]
theorem normalize_mass (w : ι → ℝ) (hw : ∀ i, 0 ≤ w i)
    (htotal : 0 < ∑ i, w i) (i : ι) :
    (normalize w hw htotal).mass i = w i / ∑ j, w j := rfl

end FiniteDistribution

open Everett.Records

/-- Squared norm of a vector, still merely a nonnegative weight. -/
noncomputable def squareWeight {H : Type*} [NormedAddCommGroup H] (x : H) : ℝ :=
  ‖x‖ ^ 2

theorem squareWeight_nonnegative {H : Type*} [NormedAddCommGroup H] (x : H) :
    0 ≤ squareWeight x :=
  sq_nonneg _

/-- Two orthogonal vector weights add under coherent addition. -/
theorem squareWeight_add_of_inner_eq_zero {H : Type*}
    [NormedAddCommGroup H] [InnerProductSpace ℂ H] (x y : H)
    (hxy : inner ℂ x y = 0) :
    squareWeight (x + y) = squareWeight x + squareWeight y := by
  simpa [squareWeight, pow_two] using
    norm_add_sq_eq_norm_sq_add_norm_sq_of_inner_eq_zero x y hxy

variable {Outcome H : Type*} {n : ℕ} [Fintype Outcome]
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- Normalize the coefficient norm-square data when its total is positive. -/
noncomputable def normalizedBranchDistribution (b : Branches Outcome n H)
    (htotal : 0 < b.totalNormSquareData) :
    FiniteDistribution (History Outcome n) :=
  FiniteDistribution.normalize b.normSquareData
    (fun _ => sq_nonneg _) (by simpa [Branches.totalNormSquareData] using htotal)

/-- Unit coherent norm and orthonormal branches directly give a probability distribution. -/
noncomputable def unitBranchDistribution (b : Branches Outcome n H)
    (hv : Orthonormal ℂ b.vector) (hunit : ‖b.coherentState‖ = 1) :
    FiniteDistribution (History Outcome n) where
  mass := b.normSquareData
  nonnegative _ := sq_nonneg _
  sum_mass := by
    change b.totalNormSquareData = 1
    rw [← b.norm_coherentState_sq hv, hunit, one_pow]

@[simp]
theorem unitBranchDistribution_mass (b : Branches Outcome n H)
    (hv : Orthonormal ℂ b.vector) (hunit : ‖b.coherentState‖ = 1)
    (h : History Outcome n) :
    (unitBranchDistribution b hv hunit).mass h = ‖b.amplitude h‖ ^ 2 := rfl

end Everett.Weights
