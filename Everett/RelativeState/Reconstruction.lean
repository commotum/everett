module

public import Everett.RelativeState.Normalization
public import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Coordinate formulas and reconstruction

Finite orthonormal-basis calculations are proved equal to the intrinsic
conditional vector. The intrinsic definition remains in the lower core leaf.
-/

@[expose] public section

namespace Everett.RelativeState

open scoped InnerProduct TensorProduct

variable {H₁ H₂ : Type*} {ι κ κ' : Type*}
  [NormedAddCommGroup H₁] [InnerProductSpace ℂ H₁] [FiniteDimensional ℂ H₁]
  [NormedAddCommGroup H₂] [InnerProductSpace ℂ H₂] [FiniteDimensional ℂ H₂]
  [Fintype ι] [Fintype κ] [Fintype κ']

omit [FiniteDimensional ℂ H₁] [FiniteDimensional ℂ H₂] in
/-- Equation-(1)-style expansion in a product orthonormal basis. -/
theorem productBasis_reconstruction (b : OrthonormalBasis ι ℂ H₁)
    (c : OrthonormalBasis κ ℂ H₂) (Ψ : H₁ ⊗[ℂ] H₂) :
    Ψ = ∑ p : ι × κ,
      (b.tensorProduct c).repr Ψ p • (b p.1 ⊗ₜ[ℂ] c p.2) := by
  simpa only [OrthonormalBasis.tensorProduct_apply'] using
    ((b.tensorProduct c).sum_repr Ψ).symm

/-- Coordinate of an intrinsic conditional in any second-factor orthonormal basis. -/
theorem conditional_repr_apply (b : OrthonormalBasis ι ℂ H₁)
    (c : OrthonormalBasis κ ℂ H₂) (i : ι) (j : κ) (Ψ : H₁ ⊗[ℂ] H₂) :
    c.repr (conditional (b i) Ψ) j = (b.tensorProduct c).repr Ψ (i, j) := by
  rw [c.repr_apply_apply, inner_conditional]
  simpa using ((b.tensorProduct c).repr_apply_apply Ψ (i, j)).symm

/-- Reconstruct a candidate conditional from coordinates in a chosen basis. -/
noncomputable def coordinateConditional (b : OrthonormalBasis ι ℂ H₁)
    (c : OrthonormalBasis κ ℂ H₂) (i : ι) (Ψ : H₁ ⊗[ℂ] H₂) : H₂ :=
  c.repr.symm <| WithLp.toLp 2 fun j => (b.tensorProduct c).repr Ψ (i, j)

/-- Every coordinate construction computes the intrinsic conditional vector. -/
theorem coordinateConditional_eq_conditional (b : OrthonormalBasis ι ℂ H₁)
    (c : OrthonormalBasis κ ℂ H₂) (i : ι) (Ψ : H₁ ⊗[ℂ] H₂) :
    coordinateConditional b c i Ψ = conditional (b i) Ψ := by
  apply c.repr.injective
  ext j
  simp [coordinateConditional, conditional_repr_apply]

/-- Changing the complementary basis does not change the reconstructed vector. -/
theorem coordinateConditional_basis_independent (b : OrthonormalBasis ι ℂ H₁)
    (c : OrthonormalBasis κ ℂ H₂) (d : OrthonormalBasis κ' ℂ H₂)
    (i : ι) (Ψ : H₁ ⊗[ℂ] H₂) :
    coordinateConditional b c i Ψ = coordinateConditional b d i Ψ := by
  rw [coordinateConditional_eq_conditional, coordinateConditional_eq_conditional]

/-- Reconstruct a bipartite vector from any first-factor orthonormal basis. -/
theorem reconstruction (b : OrthonormalBasis ι ℂ H₁) (Ψ : H₁ ⊗[ℂ] H₂) :
    Ψ = ∑ i, b i ⊗ₜ[ℂ] conditional (b i) Ψ := by
  induction Ψ using TensorProduct.induction_on with
  | zero => simp
  | tmul u v =>
      calc
        u ⊗ₜ[ℂ] v = (∑ i, inner ℂ (b i) u • b i) ⊗ₜ[ℂ] v :=
          congrArg (fun w => w ⊗ₜ[ℂ] v) (b.sum_repr' u).symm
        _ = ∑ i, (inner ℂ (b i) u • b i) ⊗ₜ[ℂ] v := by
          simpa using TensorProduct.sum_tmul (R := ℂ) Finset.univ
            (fun i => inner ℂ (b i) u • b i) v
        _ = ∑ i, b i ⊗ₜ[ℂ] conditional (b i) (u ⊗ₜ[ℂ] v) := by
          apply Finset.sum_congr rfl
          intro i _hi
          rw [TensorProduct.smul_tmul, conditional_tmul]
  | add Ψ Φ hΨ hΦ =>
      simp only [conditional_add_state, TensorProduct.tmul_add, Finset.sum_add_distrib]
      rw [← hΨ, ← hΦ]

/--
One term of the normalized reconstruction. A zero conditional contributes zero;
only a proved nonzero conditional is normalized.
-/
noncomputable def normalizedReconstructionTerm (b : OrthonormalBasis ι ℂ H₁)
    (Ψ : H₁ ⊗[ℂ] H₂) (i : ι) : H₁ ⊗[ℂ] H₂ := by
  classical
  exact if h : conditional (b i) Ψ ≠ 0 then
      b i ⊗ₜ[ℂ]
        (‖conditional (b i) Ψ‖ • normalizedConditional (b i) Ψ h)
    else
      0

/-- Equation-(3)-style reconstruction with the zero branches handled explicitly. -/
theorem normalized_reconstruction (b : OrthonormalBasis ι ℂ H₁)
    (Ψ : H₁ ⊗[ℂ] H₂) :
    Ψ = ∑ i, normalizedReconstructionTerm b Ψ i := by
  calc
    Ψ = ∑ i, b i ⊗ₜ[ℂ] conditional (b i) Ψ := reconstruction b Ψ
    _ = ∑ i, normalizedReconstructionTerm b Ψ i := by
      apply Finset.sum_congr rfl
      intro i _hi
      by_cases h : conditional (b i) Ψ = 0
      · simp [normalizedReconstructionTerm, h]
      · simp [normalizedReconstructionTerm, h, norm_smul_normalizedConditional]

end Everett.RelativeState
