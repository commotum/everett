module

public import Everett.RelativeState.Core
public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Data.ZMod.Basic

/-!
# Finite controlled-shift analogue of the continuous measurement model

This is a finite cyclic-coordinate analogue of Everett's equations (4)-(8).
It is a basis permutation, not a theorem about differential operators, `L²`
translations, Dirac deltas, or generalized position eigenvectors.
-/

@[expose] public section

namespace Everett.Analytic

open Everett.RelativeState
open scoped TensorProduct

variable {G : Type*} [Fintype G] [AddCommGroup G]

abbrev CoordinateSpace (G : Type*) [Fintype G] := EuclideanSpace ℂ G

noncomputable def coordinateBasis :
    OrthonormalBasis G ℂ (CoordinateSpace G) :=
  EuclideanSpace.basisFun G ℂ

/-- Index permutation `(q,r) ↦ (q,r+q)` underlying the finite analogue. -/
def shiftIndexEquiv (G : Type*) [AddCommGroup G] : G × G ≃ G × G where
  toFun qr := (qr.1, qr.2 + qr.1)
  invFun qr := (qr.1, qr.2 - qr.1)
  left_inv qr := by simp
  right_inv qr := by simp

/-- Constructed finite unitary controlled shift. -/
noncomputable def controlledShift :
    CoordinateSpace G ⊗[ℂ] CoordinateSpace G ≃ₗᵢ[ℂ]
      CoordinateSpace G ⊗[ℂ] CoordinateSpace G :=
  let b := (coordinateBasis (G := G)).tensorProduct (coordinateBasis (G := G))
  b.equiv b (shiftIndexEquiv G)

@[simp]
theorem controlledShift_basis (q r : G) :
    controlledShift
        (coordinateBasis (G := G) q ⊗ₜ[ℂ] coordinateBasis (G := G) r) =
      coordinateBasis (G := G) q ⊗ₜ[ℂ]
        coordinateBasis (G := G) (r + q) := by
  let b := (coordinateBasis (G := G)).tensorProduct (coordinateBasis (G := G))
  have h := b.equiv_apply_basis b (shiftIndexEquiv G) (q, r)
  simpa [controlledShift, b, shiftIndexEquiv] using h

/-- Apparatus origin, the finite analogue of a localized ready coordinate. -/
noncomputable def ready : CoordinateSpace G := coordinateBasis (G := G) 0

@[simp]
theorem controlledShift_prepared (q : G) :
    controlledShift
        (coordinateBasis (G := G) q ⊗ₜ[ℂ] ready (G := G)) =
      coordinateBasis (G := G) q ⊗ₜ[ℂ] coordinateBasis (G := G) q := by
  simp [ready]

/-- Prepared superposition with the apparatus at the finite coordinate origin. -/
noncomputable def preparedState (a : G → ℂ) :
    CoordinateSpace G ⊗[ℂ] CoordinateSpace G :=
  ∑ q, a q • (coordinateBasis (G := G) q ⊗ₜ[ℂ] ready (G := G))

/-- Correlated output of the controlled shift. -/
noncomputable def correlatedState (a : G → ℂ) :
    CoordinateSpace G ⊗[ℂ] CoordinateSpace G :=
  ∑ q, a q •
    (coordinateBasis (G := G) q ⊗ₜ[ℂ] coordinateBasis (G := G) q)

theorem controlledShift_superposition (a : G → ℂ) :
    controlledShift (preparedState a) = correlatedState a := by
  simp [preparedState, correlatedState]

omit [AddCommGroup G] in
/-- Selecting a sharp *finite basis vector* gives the corresponding apparatus
conditional. This is not point evaluation of an `L²` equivalence class. -/
theorem conditional_correlatedState (a : G → ℂ) (q : G) :
    conditional (coordinateBasis (G := G) q) (correlatedState a) =
      a q • coordinateBasis (G := G) q := by
  classical
  unfold correlatedState
  change (conditionalMap (coordinateBasis (G := G) q))
      (∑ x, a x •
        (coordinateBasis (G := G) x ⊗ₜ[ℂ] coordinateBasis (G := G) x)) = _
  rw [map_sum]
  simp only [map_smul]
  change (∑ x, a x • conditional (coordinateBasis (G := G) q)
      (coordinateBasis (G := G) x ⊗ₜ[ℂ] coordinateBasis (G := G) x)) = _
  simp_rw [conditional_tmul]
  simp_rw [(coordinateBasis (G := G)).inner_eq_ite]
  simp

end Everett.Analytic
