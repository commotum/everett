module

public import Everett.Measurement.Core

/-!
# Prepared maps, isometries, unitary extensions, and linearity rules

Each strength level has a distinct bundled type. Conversions in this file only
go from stronger structure to weaker structure unless a theorem constructs the
additional evidence.
-/

@[expose] public section

namespace Everett.Measurement

open scoped TensorProduct

/-- A finite superposition is carried termwise by any linear map. -/
theorem linearMap_superposition {κ A B : Type*} [Fintype κ]
    [AddCommMonoid A] [Module ℂ A] [AddCommMonoid B] [Module ℂ B]
    (L : A →ₗ[ℂ] B) (a : κ → ℂ) (v : κ → A) :
    L (∑ i, a i • v i) = ∑ i, a i • L (v i) := by
  simp

/-- Two successive linear interactions act termwise on the same superposition. -/
theorem linearMap_superposition_comp {κ A B C : Type*} [Fintype κ]
    [AddCommMonoid A] [Module ℂ A] [AddCommMonoid B] [Module ℂ B]
    [AddCommMonoid C] [Module ℂ C]
    (L : A →ₗ[ℂ] B) (M : B →ₗ[ℂ] C) (a : κ → ℂ) (v : κ → A) :
    M (L (∑ i, a i • v i)) = ∑ i, a i • M (L (v i)) := by
  simp

variable {ι S R : Type*} [Fintype ι]
  [NormedAddCommGroup S] [InnerProductSpace ℂ S] [FiniteDimensional ℂ S]
  [NormedAddCommGroup R] [InnerProductSpace ℂ R] [FiniteDimensional ℂ R]

abbrev Composite (S R : Type*) [AddCommMonoid S] [AddCommMonoid R]
    [Module ℂ S] [Module ℂ R] := S ⊗[ℂ] R

/-- A linear map whose domain is exactly the prepared-input subspace. -/
structure PreparedSpanMap (m : IdealData (ι := ι) (S := S) (R := R)) where
  toLinearMap : m.preparedSubspace →ₗ[ℂ] Composite S R
  map_prepared : ∀ i, toLinearMap (m.preparedInput i) = m.toMeasurementData.output i

/-- An isometry from the prepared-input subspace into the full composite. -/
structure PreparedIsometry (m : IdealData (ι := ι) (S := S) (R := R)) where
  toLinearIsometry : m.preparedSubspace →ₗᵢ[ℂ] Composite S R
  map_prepared : ∀ i, toLinearIsometry (m.preparedInput i) = m.toMeasurementData.output i

/-- A unitary operator on the full finite-dimensional composite. -/
structure FullUnitary (m : IdealData (ι := ι) (S := S) (R := R)) where
  toLinearIsometryEquiv : Composite S R ≃ₗᵢ[ℂ] Composite S R
  map_prepared : ∀ i,
    toLinearIsometryEquiv (m.toMeasurementData.input i) = m.toMeasurementData.output i

namespace PreparedIsometry

/-- Forget norm preservation while retaining the actual prepared-subspace domain. -/
def toPreparedSpanMap {m : IdealData (ι := ι) (S := S) (R := R)}
    (L : PreparedIsometry m) : PreparedSpanMap m where
  toLinearMap := L.toLinearIsometry.toLinearMap
  map_prepared := L.map_prepared

end PreparedIsometry

namespace FullUnitary

/-- Restrict a full unitary to the actual prepared-input subspace. -/
noncomputable def toPreparedIsometry {m : IdealData (ι := ι) (S := S) (R := R)}
    (U : FullUnitary m) : PreparedIsometry m where
  toLinearIsometry :=
    U.toLinearIsometryEquiv.toLinearIsometry.comp m.preparedSubspace.subtypeₗᵢ
  map_prepared i := by
    change U.toLinearIsometryEquiv (m.toMeasurementData.input i) = _
    exact U.map_prepared i

/-- Forget a full unitary down to a linear prepared-subspace map. -/
noncomputable def toPreparedSpanMap {m : IdealData (ι := ι) (S := S) (R := R)}
    (U : FullUnitary m) : PreparedSpanMap m :=
  U.toPreparedIsometry.toPreparedSpanMap

end FullUnitary

namespace IdealData

/-- Canonical isometry from the prepared subspace to correlated outputs. -/
noncomputable def canonicalPreparedIsometry
    (m : IdealData (ι := ι) (S := S) (R := R)) : PreparedIsometry m where
  toLinearIsometry :=
    m.correlateIsometry.comp m.prepareIsometry.equivRange.symm.toLinearIsometry
  map_prepared i := by
    change m.correlateIsometry
      (m.prepareIsometry.equivRange.symm (m.preparedInput i)) = _
    have hinput : m.preparedInput i = m.prepareIsometry.equivRange (m.systemBasis i) := by
      apply Subtype.ext
      rfl
    rw [hinput, LinearIsometryEquiv.symm_apply_apply]
    exact m.correlateIsometry_basis i

/--
Finite-dimensional unitary extension of the canonical prepared isometry.
Surjectivity is proved from finite-dimensional injectivity, not assumed.
-/
noncomputable def unitaryExtension
    (m : IdealData (ι := ι) (S := S) (R := R)) : FullUnitary m := by
  let L := m.canonicalPreparedIsometry.toLinearIsometry
  let E : Composite S R →ₗᵢ[ℂ] Composite S R := L.extend
  have hsurj : Function.Surjective E :=
    E.toLinearMap.surjective_of_injective E.injective
  refine
    { toLinearIsometryEquiv := LinearIsometryEquiv.ofSurjective E hsurj
      map_prepared := ?_ }
  intro i
  change E (m.preparedInput i) = m.toMeasurementData.output i
  rw [LinearIsometry.extend_apply]
  exact m.canonicalPreparedIsometry.map_prepared i

end IdealData

namespace PreparedSpanMap

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- Everett's correlated-superposition rule follows from linearity on the span. -/
theorem map_superposition {m : IdealData (ι := ι) (S := S) (R := R)}
    (L : PreparedSpanMap m) (a : ι → ℂ) :
    L.toLinearMap (∑ i, a i • m.preparedInput i) =
      ∑ i, a i • m.toMeasurementData.output i := by
  simp only [map_sum, map_smul, L.map_prepared]

end PreparedSpanMap

namespace FullUnitary

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- The full-space version of the correlated-superposition rule. -/
theorem map_superposition {m : IdealData (ι := ι) (S := S) (R := R)}
    (U : FullUnitary m) (a : ι → ℂ) :
    U.toLinearIsometryEquiv (∑ i, a i • m.toMeasurementData.input i) =
      ∑ i, a i • m.toMeasurementData.output i := by
  simp only [map_sum, map_smul, U.map_prepared]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- A spectator tensor factor is unchanged when the measurement acts on the composite factor. -/
theorem map_prepared_with_spectator {m : IdealData (ι := ι) (S := S) (R := R)}
    (U : FullUnitary m) {T : Type*} [AddCommMonoid T] [Module ℂ T]
    (i : ι) (t : T) :
    TensorProduct.map U.toLinearIsometryEquiv.toLinearMap (LinearMap.id (R := ℂ) (M := T))
        (m.toMeasurementData.input i ⊗ₜ[ℂ] t) =
      m.toMeasurementData.output i ⊗ₜ[ℂ] t := by
  simp [U.map_prepared]

omit [FiniteDimensional ℂ S] [FiniteDimensional ℂ R] in
/-- The bundled ideal behavior is nondemolition on each measured eigenstate. -/
theorem preserves_system_eigenstate {m : IdealData (ι := ι) (S := S) (R := R)}
    (U : FullUnitary m) (i : ι) :
    U.toLinearIsometryEquiv (m.toMeasurementData.input i) =
      m.systemBasis i ⊗ₜ[ℂ] m.record i :=
  U.map_prepared i

end FullUnitary

end Everett.Measurement
