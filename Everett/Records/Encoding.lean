module

public import Everett.Records.History
public import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Exact record encodings

An exact encoding assigns an orthonormal basis vector to every finite history.
-/

@[expose] public section

namespace Everett.Records

variable {Outcome R R' : Type*} {n : ℕ} [Fintype Outcome]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R]
  [NormedAddCommGroup R'] [InnerProductSpace ℂ R']

/-- A complete exact record basis indexed by length-`n` histories. -/
structure Encoding (Outcome : Type*) (n : ℕ) (R : Type*) [Fintype Outcome]
    [NormedAddCommGroup R] [InnerProductSpace ℂ R] where
  basis : OrthonormalBasis (History Outcome n) ℂ R

namespace Encoding

/-- The record vector encoding a history. -/
noncomputable def state (e : Encoding Outcome n R) (h : History Outcome n) : R :=
  e.basis h

/-- The canonical coordinate-space encoding. -/
noncomputable def canonical (Outcome : Type*) (n : ℕ) [Fintype Outcome] :
    Encoding Outcome n (EuclideanSpace ℂ (History Outcome n)) where
  basis := EuclideanSpace.basisFun (History Outcome n) ℂ

/-- In the next record space, append a fixed outcome to every prior history. -/
noncomputable def appendFamily (e' : Encoding Outcome (n + 1) R') (a : Outcome) :
    History Outcome n → R' :=
  fun h => e'.state (History.snoc h a)

/-- A fixed-outcome appended family is orthonormal. -/
theorem appendFamily_orthonormal (e' : Encoding Outcome (n + 1) R') (a : Outcome) :
    Orthonormal ℂ (e'.appendFamily a) := by
  change Orthonormal ℂ
    (e'.basis ∘ fun h : History Outcome n => History.snoc h a)
  exact e'.basis.orthonormal.comp
    (fun h : History Outcome n => History.snoc h a) (History.snoc_injective a)

/-- Linear extension of the fixed-outcome action on encoded histories. -/
noncomputable def appendMap (e : Encoding Outcome n R)
    (e' : Encoding Outcome (n + 1) R') (a : Outcome) : R →ₗ[ℂ] R' where
  toFun x := ∑ h, e.basis.repr x h • e'.appendFamily a h
  map_add' x y := by simp [map_add, add_smul, Finset.sum_add_distrib]
  map_smul' c x := by simp [map_smul, smul_smul, Finset.smul_sum]

@[simp]
theorem appendMap_basis (e : Encoding Outcome n R)
    (e' : Encoding Outcome (n + 1) R') (a : Outcome) (h : History Outcome n) :
    e.appendMap e' a (e.basis h) = e'.state (History.snoc h a) := by
  classical
  simp [appendMap, appendFamily, state, e.basis.repr_apply_apply,
    e.basis.inner_eq_ite]

/-- The fixed-outcome append map is isometric under exact encodings. -/
noncomputable def appendIsometry (e : Encoding Outcome n R)
    (e' : Encoding Outcome (n + 1) R') (a : Outcome) : R →ₗᵢ[ℂ] R' :=
  (e.appendMap e' a).isometryOfOrthonormal (v := e.basis.toBasis)
    e.basis.orthonormal (by
      have heq :
          (e.appendMap e' a ∘ e.basis.toBasis : History Outcome n → R') =
            e'.appendFamily a := by
        funext h
        exact e.appendMap_basis e' a h
      rw [heq]
      exact e'.appendFamily_orthonormal a)

@[simp]
theorem appendIsometry_basis (e : Encoding Outcome n R)
    (e' : Encoding Outcome (n + 1) R') (a : Outcome) (h : History Outcome n) :
    e.appendIsometry e' a (e.basis h) = e'.state (History.snoc h a) :=
  e.appendMap_basis e' a h

end Encoding

end Everett.Records
