module

public import Mathlib.Analysis.InnerProductSpace.PiL2
public import Mathlib.Analysis.InnerProductSpace.TensorProduct

/-!
# Ideal measurement data and prepared subspaces

This leaf distinguishes raw basis prescriptions from normalized,
distinguishable-record ideal data.
-/

@[expose] public section

namespace Everett.Measurement

open scoped InnerProduct TensorProduct

variable {ι S R : Type*} [Fintype ι]
  [NormedAddCommGroup S] [InnerProductSpace ℂ S] [FiniteDimensional ℂ S]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R] [FiniteDimensional ℂ R]

/-- Unconstrained data for a nondemolition prepared-family prescription. -/
structure MeasurementData where
  systemBasis : OrthonormalBasis ι ℂ S
  ready : R
  record : ι → R

namespace MeasurementData

/-- Prepared eigenstate with the ready record. -/
noncomputable def input (m : MeasurementData (ι := ι) (S := S) (R := R)) (i : ι) :
    S ⊗[ℂ] R :=
  m.systemBasis i ⊗ₜ[ℂ] m.ready

/-- Nondemolition output eigenstate correlated with its outcome record. -/
noncomputable def output (m : MeasurementData (ι := ι) (S := S) (R := R)) (i : ι) :
    S ⊗[ℂ] R :=
  m.systemBasis i ⊗ₜ[ℂ] m.record i

/-- The basis prescription preserves inner products on the prepared family. -/
def PrescriptionInnerPreserving (m : MeasurementData (ι := ι) (S := S) (R := R)) : Prop :=
  ∀ i j, inner ℂ (m.input i) (m.input j) = inner ℂ (m.output i) (m.output j)

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- Equal record/ready norms are sufficient for the composite prescription to be isometric. -/
theorem prescriptionInnerPreserving_of_record_norm
    (m : MeasurementData (ι := ι) (S := S) (R := R))
    (h : ∀ i, ‖m.record i‖ = ‖m.ready‖) : m.PrescriptionInnerPreserving := by
  classical
  intro i j
  by_cases hij : i = j
  · subst j
    simp [input, output, inner_self_eq_norm_sq_to_K, h]
  · simp [input, output, m.systemBasis.inner_eq_zero hij]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- For the nondemolition basis prescription, equal record/ready norms are also necessary. -/
theorem prescriptionInnerPreserving_iff_record_norm
    (m : MeasurementData (ι := ι) (S := S) (R := R)) :
    m.PrescriptionInnerPreserving ↔ ∀ i, ‖m.record i‖ = ‖m.ready‖ := by
  constructor
  · intro hp i
    have hinner := hp i i
    have hsquare : ‖m.input i‖ ^ 2 = ‖m.output i‖ ^ 2 := by
      rw [@norm_sq_eq_re_inner ℂ (S ⊗[ℂ] R),
        @norm_sq_eq_re_inner ℂ (S ⊗[ℂ] R)]
      exact congrArg Complex.re hinner
    have hnorm : ‖m.input i‖ = ‖m.output i‖ :=
      (sq_eq_sq₀ (norm_nonneg _) (norm_nonneg _)).mp hsquare
    simpa [input, output] using hnorm.symm
  · exact m.prescriptionInnerPreserving_of_record_norm

/-- Linear preparation map `ψ ↦ ψ ⊗ ready`. -/
noncomputable def prepareMap (m : MeasurementData (ι := ι) (S := S) (R := R)) :
    S →ₗ[ℂ] S ⊗[ℂ] R :=
  (TensorProduct.mk ℂ S R).flip m.ready

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem prepareMap_apply (m : MeasurementData (ι := ι) (S := S) (R := R)) (ψ : S) :
    m.prepareMap ψ = ψ ⊗ₜ[ℂ] m.ready := rfl

/-- Linear correlated-superposition map determined by the output family. -/
noncomputable def correlateMap (m : MeasurementData (ι := ι) (S := S) (R := R)) :
    S →ₗ[ℂ] S ⊗[ℂ] R where
  toFun ψ := ∑ i, m.systemBasis.repr ψ i • m.output i
  map_add' ψ φ := by simp [map_add, add_smul, Finset.sum_add_distrib]
  map_smul' c ψ := by simp [map_smul, smul_smul, Finset.smul_sum]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem correlateMap_basis (m : MeasurementData (ι := ι) (S := S) (R := R)) (i : ι) :
    m.correlateMap (m.systemBasis i) = m.output i := by
  classical
  simp [correlateMap, m.systemBasis.repr_apply_apply, m.systemBasis.inner_eq_ite]

end MeasurementData

/--
Ideal prepared measurement data: normalized ready state and mutually
orthonormal, hence exactly distinguishable, outcome record states.
-/
structure IdealData extends MeasurementData (ι := ι) (S := S) (R := R) where
  ready_norm : ‖ready‖ = 1
  record_orthonormal : Orthonormal ℂ record

namespace IdealData

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem record_norm (m : IdealData (ι := ι) (S := S) (R := R)) (i : ι) :
    ‖m.record i‖ = 1 :=
  m.record_orthonormal.norm_eq_one i

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
theorem prescriptionInnerPreserving (m : IdealData (ι := ι) (S := S) (R := R)) :
    m.toMeasurementData.PrescriptionInnerPreserving := by
  apply MeasurementData.prescriptionInnerPreserving_of_record_norm
  intro i
  rw [m.record_norm, m.ready_norm]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- Composite output branches are orthonormal. -/
theorem output_orthonormal (m : IdealData (ι := ι) (S := S) (R := R)) :
    Orthonormal ℂ m.toMeasurementData.output := by
  constructor
  · intro i
    simp [MeasurementData.output, m.record_norm]
  · intro i j hij
    simp [MeasurementData.output, m.systemBasis.inner_eq_zero hij]

/-- The normalized ready-state preparation is a linear isometry. -/
noncomputable def prepareIsometry (m : IdealData (ι := ι) (S := S) (R := R)) :
    S →ₗᵢ[ℂ] S ⊗[ℂ] R where
  toLinearMap := m.toMeasurementData.prepareMap
  norm_map' ψ := by simp [m.ready_norm]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem prepareIsometry_apply (m : IdealData (ι := ι) (S := S) (R := R)) (ψ : S) :
    m.prepareIsometry ψ = ψ ⊗ₜ[ℂ] m.ready := rfl

/-- The correlated output map is a linear isometry. -/
noncomputable def correlateIsometry (m : IdealData (ι := ι) (S := S) (R := R)) :
    S →ₗᵢ[ℂ] S ⊗[ℂ] R :=
  m.toMeasurementData.correlateMap.isometryOfOrthonormal
    (v := m.systemBasis.toBasis) m.systemBasis.orthonormal (by
      have heq :
          (m.toMeasurementData.correlateMap ∘ m.systemBasis.toBasis :
            ι → S ⊗[ℂ] R) = m.toMeasurementData.output := by
        funext i
        exact m.toMeasurementData.correlateMap_basis i
      rw [heq]
      exact m.output_orthonormal)

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem correlateIsometry_basis (m : IdealData (ι := ι) (S := S) (R := R)) (i : ι) :
    m.correlateIsometry (m.systemBasis i) = m.toMeasurementData.output i := by
  change m.toMeasurementData.correlateMap (m.systemBasis i) = _
  exact m.toMeasurementData.correlateMap_basis i

/-- The actual subspace of composite inputs with the record prepared in `ready`. -/
noncomputable def preparedSubspace (m : IdealData (ι := ι) (S := S) (R := R)) :
    Submodule ℂ (S ⊗[ℂ] R) :=
  LinearMap.range m.prepareIsometry.toLinearMap

/-- A basis prepared input, bundled as an element of the prepared subspace. -/
noncomputable def preparedInput (m : IdealData (ι := ι) (S := S) (R := R)) (i : ι) :
    m.preparedSubspace :=
  ⟨m.toMeasurementData.input i, ⟨m.systemBasis i, rfl⟩⟩

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
@[simp]
theorem preparedInput_coe (m : IdealData (ι := ι) (S := S) (R := R)) (i : ι) :
    (m.preparedInput i : S ⊗[ℂ] R) = m.toMeasurementData.input i := rfl

end IdealData

end Everett.Measurement
