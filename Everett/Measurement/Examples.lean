module

import Everett.Measurement.Linearity

/-!
# Finite ideal-measurement examples

Concrete two- and three-outcome models exercise the distinction between raw
prescriptions, prepared-subspace isometries, and full unitary extensions.
-/

namespace Everett.Measurement.Examples

open Everett.Measurement
open scoped TensorProduct

abbrev Qubit := EuclideanSpace ℂ (Fin 2)
abbrev Qutrit := EuclideanSpace ℂ (Fin 3)

noncomputable def qubitBasis : OrthonormalBasis (Fin 2) ℂ Qubit :=
  EuclideanSpace.basisFun (Fin 2) ℂ

noncomputable def qutritBasis : OrthonormalBasis (Fin 3) ℂ Qutrit :=
  EuclideanSpace.basisFun (Fin 3) ℂ

/-- Two-outcome ideal data with computational-basis records. -/
noncomputable def twoOutcome : IdealData (ι := Fin 2) (S := Qubit) (R := Qubit) where
  systemBasis := qubitBasis
  ready := qubitBasis 0
  record := qubitBasis
  ready_norm := qubitBasis.orthonormal.norm_eq_one 0
  record_orthonormal := qubitBasis.orthonormal

/-- Three-outcome ideal data, showing the construction is not qubit-specific. -/
noncomputable def threeOutcome : IdealData (ι := Fin 3) (S := Qutrit) (R := Qutrit) where
  systemBasis := qutritBasis
  ready := qutritBasis 0
  record := qutritBasis
  ready_norm := qutritBasis.orthonormal.norm_eq_one 0
  record_orthonormal := qutritBasis.orthonormal

noncomputable example : PreparedIsometry twoOutcome :=
  twoOutcome.canonicalPreparedIsometry

noncomputable example : FullUnitary twoOutcome :=
  twoOutcome.unitaryExtension

noncomputable example : PreparedIsometry threeOutcome :=
  threeOutcome.canonicalPreparedIsometry

noncomputable example : FullUnitary threeOutcome :=
  threeOutcome.unitaryExtension

/-- A visibly non-real superposition is correlated with the same coefficients. -/
noncomputable example :
    twoOutcome.unitaryExtension.toLinearIsometryEquiv
        (∑ i, (if i = 0 then Complex.I else 1) •
          twoOutcome.toMeasurementData.input i) =
      ∑ i, (if i = 0 then Complex.I else 1) •
        twoOutcome.toMeasurementData.output i :=
  twoOutcome.unitaryExtension.map_superposition _

/-- A spectator qubit is unchanged by the extended measurement interaction. -/
noncomputable example (i : Fin 2) (t : Qubit) :
    TensorProduct.map twoOutcome.unitaryExtension.toLinearIsometryEquiv.toLinearMap
        (LinearMap.id (R := ℂ) (M := Qubit))
        (twoOutcome.toMeasurementData.input i ⊗ₜ[ℂ] t) =
      twoOutcome.toMeasurementData.output i ⊗ₜ[ℂ] t :=
  twoOutcome.unitaryExtension.map_prepared_with_spectator i t

end Everett.Measurement.Examples
