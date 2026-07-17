module

public import Everett.Records.Encoding
public import Mathlib.Analysis.InnerProductSpace.TensorProduct

/-!
# Exact copying of distinguished record states
-/

@[expose] public section

namespace Everett.Records

open scoped TensorProduct

variable {Outcome R : Type*} {n : ℕ} [Fintype Outcome]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R] [FiniteDimensional ℂ R]

namespace Encoding

/-- Diagonal family of two agreeing exact records. -/
noncomputable def diagonalFamily (e : Encoding Outcome n R) :
    History Outcome n → R ⊗[ℂ] R :=
  fun h => e.state h ⊗ₜ[ℂ] e.state h

omit [FiniteDimensional ℂ R] in
theorem diagonalFamily_orthonormal (e : Encoding Outcome n R) :
    Orthonormal ℂ e.diagonalFamily := by
  constructor
  · intro h
    change ‖e.basis h ⊗ₜ[ℂ] e.basis h‖ = 1
    simp [e.basis.orthonormal.norm_eq_one]
  · intro h k hne
    change inner ℂ (e.basis h ⊗ₜ[ℂ] e.basis h)
      (e.basis k ⊗ₜ[ℂ] e.basis k) = 0
    rw [TensorProduct.inner_tmul, e.basis.inner_eq_zero hne, zero_mul]

/-- Linear map copying the distinguished exact record basis. -/
noncomputable def copyMap (e : Encoding Outcome n R) : R →ₗ[ℂ] R ⊗[ℂ] R where
  toFun x := ∑ h, e.basis.repr x h • e.diagonalFamily h
  map_add' x y := by simp [map_add, add_smul, Finset.sum_add_distrib]
  map_smul' c x := by simp [map_smul, smul_smul, Finset.smul_sum]

omit [FiniteDimensional ℂ R] in
@[simp]
theorem copyMap_basis (e : Encoding Outcome n R) (h : History Outcome n) :
    e.copyMap (e.basis h) = e.state h ⊗ₜ[ℂ] e.state h := by
  classical
  change (∑ k, e.basis.repr (e.basis h) k • e.diagonalFamily k) = _
  rw [e.basis.repr_self]
  simp [EuclideanSpace.single, diagonalFamily]

/-- Exact record copying is an isometry on the whole source record space. -/
noncomputable def copyIsometry (e : Encoding Outcome n R) : R →ₗᵢ[ℂ] R ⊗[ℂ] R :=
  e.copyMap.isometryOfOrthonormal (v := e.basis.toBasis) e.basis.orthonormal (by
    have heq : (e.copyMap ∘ e.basis.toBasis : History Outcome n → R ⊗[ℂ] R) =
        e.diagonalFamily := by
      funext h
      exact e.copyMap_basis h
    rw [heq]
    exact e.diagonalFamily_orthonormal)

omit [FiniteDimensional ℂ R] in
@[simp]
theorem copyIsometry_basis (e : Encoding Outcome n R) (h : History Outcome n) :
    e.copyIsometry (e.state h) = e.state h ⊗ₜ[ℂ] e.state h :=
  e.copyMap_basis h

end Encoding

end Everett.Records
