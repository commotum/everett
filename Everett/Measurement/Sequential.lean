module

public import Everett.Measurement.Linearity
public import Mathlib.LinearAlgebra.TensorProduct.Map

/-!
# Sequential basis changes and tensor-factor locality
-/

@[expose] public section

namespace Everett.Measurement

open scoped TensorProduct

variable {ι κ S : Type*} [Fintype ι] [Fintype κ]
  [NormedAddCommGroup S] [InnerProductSpace ℂ S]

/-- Change-of-basis amplitude from an `A` eigenvector to a `B` eigenvector. -/
noncomputable def transitionAmplitude (a : OrthonormalBasis ι ℂ S)
    (b : OrthonormalBasis κ ℂ S) (i : ι) (j : κ) : ℂ :=
  inner ℂ (b j) (a i)

/-- Branch amplitude for `A_i → B_j → A_k`. -/
noncomputable def abaAmplitude (a : OrthonormalBasis ι ℂ S)
    (b : OrthonormalBasis κ ℂ S) (i k : ι) (j : κ) : ℂ :=
  transitionAmplitude a b i j * transitionAmplitude b a j k

/-- The same two-transition product when one normalized intermediate vector is
named directly. Such a vector represents one member of the intervening basis,
not a complete measurement by itself. -/
noncomputable def viaVectorAmplitude (a : OrthonormalBasis ι ℂ S)
    (v : S) (i k : ι) : ℂ :=
  inner ℂ v (a i) * inner ℂ (a k) v

@[simp]
theorem viaVectorAmplitude_basis (a : OrthonormalBasis ι ℂ S)
    (b : OrthonormalBasis κ ℂ S) (i k : ι) (j : κ) :
    viaVectorAmplitude a (b j) i k = abaAmplitude a b i k j :=
  rfl

theorem abaAmplitude_ne_zero (a : OrthonormalBasis ι ℂ S)
    (b : OrthonormalBasis κ ℂ S) {i k : ι} {j : κ}
    (h₁ : transitionAmplitude a b i j ≠ 0)
    (h₂ : transitionAmplitude b a j k ≠ 0) :
    abaAmplitude a b i k j ≠ 0 :=
  mul_ne_zero h₁ h₂

/-- A possible disagreement branch is witnessed by nonzero change-of-basis transitions. -/
theorem disagreement_possible (a : OrthonormalBasis ι ℂ S)
    (b : OrthonormalBasis κ ℂ S) {i k : ι} (hik : i ≠ k)
    (h : ∃ j, transitionAmplitude a b i j ≠ 0 ∧
      transitionAmplitude b a j k ≠ 0) :
    ∃ j, i ≠ k ∧ abaAmplitude a b i k j ≠ 0 := by
  obtain ⟨j, h₁, h₂⟩ := h
  exact ⟨j, hik, abaAmplitude_ne_zero a b h₁ h₂⟩

/-- Linear interactions on distinct tensor factors commute. -/
theorem local_maps_commute {A A' B B' : Type*}
    [AddCommMonoid A] [Module ℂ A] [AddCommMonoid A'] [Module ℂ A']
    [AddCommMonoid B] [Module ℂ B] [AddCommMonoid B'] [Module ℂ B']
    (f : A →ₗ[ℂ] A') (g : B →ₗ[ℂ] B')
    (ψ : A ⊗[ℂ] B) :
    g.lTensor A' (f.rTensor B ψ) = f.rTensor B' (g.lTensor A ψ) := by
  change ((g.lTensor A').comp (f.rTensor B)) ψ =
    ((f.rTensor B').comp (g.lTensor A)) ψ
  rw [LinearMap.lTensor_comp_rTensor, LinearMap.rTensor_comp_lTensor]

end Everett.Measurement
