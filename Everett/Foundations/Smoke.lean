module

import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.InnerProductSpace.TensorProduct
import Mathlib.Analysis.Normed.Module.Normalize
import Mathlib.MeasureTheory.Measure.ProbabilityMeasure
import Mathlib.Probability.ProductMeasure

/-!
# Foundations API smoke tests

Compiling probes for the mathlib APIs and conventions used by later stages.
This diagnostic leaf is not intended as a runtime dependency.
-/

namespace Everett.Foundations

open scoped ComplexConjugate TensorProduct

section HilbertSpaceAPIs

variable {H K : Type*}
  [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [NormedAddCommGroup K] [InnerProductSpace ℂ K]

/-- Mathlib's inner product is conjugate-linear in its first argument. -/
theorem inner_smul_left_convention (c : ℂ) (x y : H) :
    inner ℂ (c • x) y = conj c * inner ℂ x y := by
  exact inner_smul_left x y c

/-- Mathlib's inner product is linear in its second argument. -/
theorem inner_smul_right_convention (c : ℂ) (x y : H) :
    inner ℂ x (c • y) = c * inner ℂ x y := by
  exact inner_smul_right x y c

/-- Pure tensors use the same left/right factor order as their notation. -/
theorem tensor_inner_convention (x x' : H) (y y' : K) :
    inner ℂ (x ⊗ₜ[ℂ] y) (x' ⊗ₜ[ℂ] y') =
      inner ℂ x x' * inner ℂ y y' := by
  exact TensorProduct.inner_tmul ℂ x x' y y'

example : H →L[ℂ] H := ContinuousLinearMap.id ℂ H

example : H →ₗᵢ[ℂ] H := LinearIsometry.id

example : H ≃ₗᵢ[ℂ] H := LinearIsometryEquiv.refl ℂ H

example (x : H) : NormedSpace.normalize x = 0 ↔ x = 0 :=
  NormedSpace.normalize_eq_zero_iff x

noncomputable example [FiniteDimensional ℂ H] [FiniteDimensional ℂ K] :
    CompleteSpace (H ⊗[ℂ] K) := FiniteDimensional.complete ℂ _

end HilbertSpaceAPIs

section FiniteBasisAPI

noncomputable example :
    OrthonormalBasis (Fin 2) ℂ (EuclideanSpace ℂ (Fin 2)) :=
  EuclideanSpace.basisFun (Fin 2) ℂ

end FiniteBasisAPI

section ProbabilityAPIs

local instance : MeasurableSpace (Fin 2) := ⊤

noncomputable def pointMass : MeasureTheory.ProbabilityMeasure (Fin 2) :=
  ⟨MeasureTheory.Measure.dirac 0, MeasureTheory.Measure.dirac.isProbabilityMeasure⟩

noncomputable example : MeasureTheory.IsProbabilityMeasure
    (MeasureTheory.Measure.pi fun _ : Fin 3 => (pointMass : MeasureTheory.Measure (Fin 2))) :=
  inferInstance

noncomputable example : MeasureTheory.IsProbabilityMeasure
    (MeasureTheory.Measure.infinitePi fun _ : ℕ =>
      (pointMass : MeasureTheory.Measure (Fin 2))) :=
  inferInstance

end ProbabilityAPIs

end Everett.Foundations
