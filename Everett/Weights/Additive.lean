module

public import Mathlib.Analysis.Normed.Module.Basic
public import Mathlib.Analysis.Complex.Basic
public import Mathlib.Topology.Instances.RealVectorSpace

/-!
# Additive radial weights

The classification theorem uses an additive map on all reals and states the
nonnegativity condition that rules out pathological additive maps.
-/

@[expose] public section

namespace Everett.Weights

open Set

/-- An additive real map is nonnegative on its intended nonnegative domain. -/
def NonnegativeOnNonnegative (g : ℝ →+ ℝ) : Prop :=
  ∀ x, 0 ≤ x → 0 ≤ g x

/-- Nonnegativity on nonnegative inputs makes an additive map monotone. -/
theorem monotone_of_nonnegativeOnNonnegative (g : ℝ →+ ℝ)
    (hg : NonnegativeOnNonnegative g) : Monotone g := by
  intro x y hxy
  rw [← sub_nonneg, ← g.map_sub]
  exact hg (y - x) (sub_nonneg.mpr hxy)

/-- The same condition supplies the local boundedness needed for continuity. -/
theorem continuous_of_nonnegativeOnNonnegative (g : ℝ →+ ℝ)
    (hg : NonnegativeOnNonnegative g) : Continuous g := by
  have hmono := monotone_of_nonnegativeOnNonnegative g hg
  apply g.continuous_of_isBounded_nhds_zero
    (s := Set.Icc (-1 : ℝ) 1) (Icc_mem_nhds (by norm_num) (by norm_num))
  refine (Metric.isBounded_Icc (g (-1)) (g 1)).subset ?_
  rintro y ⟨x, hx, rfl⟩
  exact ⟨hmono hx.1, hmono hx.2⟩

/-- Corrected additive classification: `g(x) = g(1) x`. -/
theorem additive_eq_mul (g : ℝ →+ ℝ) (hg : NonnegativeOnNonnegative g) (x : ℝ) :
    g x = g 1 * x := by
  have hlin := map_real_smul g (continuous_of_nonnegativeOnNonnegative g hg) x 1
  simpa [smul_eq_mul, mul_comm] using hlin

/-- Square-amplitude candidate obtained by applying `g` to a complex norm square. -/
noncomputable def radialWeight (g : ℝ →+ ℝ) (z : ℂ) : ℝ :=
  g (‖z‖ ^ 2)

/-- The additive radial candidate is necessarily a constant times squared modulus. -/
theorem radialWeight_eq (g : ℝ →+ ℝ) (hg : NonnegativeOnNonnegative g) (z : ℂ) :
    radialWeight g z = g 1 * ‖z‖ ^ 2 :=
  additive_eq_mul g hg _

/-- The resulting weight is invariant under multiplication by a unit-modulus phase. -/
theorem radialWeight_unit_phase (g : ℝ →+ ℝ) (c z : ℂ) (hc : ‖c‖ = 1) :
    radialWeight g (c * z) = radialWeight g z := by
  simp [radialWeight, hc]

/-- The resulting weight is nonnegative on every complex amplitude. -/
theorem radialWeight_nonnegative (g : ℝ →+ ℝ) (hg : NonnegativeOnNonnegative g) (z : ℂ) :
    0 ≤ radialWeight g z :=
  hg _ (sq_nonneg _)

end Everett.Weights
