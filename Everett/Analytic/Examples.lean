module

import Everett.Analytic.ControlledShift

/-!
# Finite controlled-shift diagnostics
-/

namespace Everett.Analytic.Examples

open Everett.Analytic
open scoped TensorProduct

abbrev Cycle3 := ZMod 3

/-- Explicit cyclic wraparound: apparatus coordinate `2` shifted by system
coordinate `2` becomes `1` modulo `3`. -/
example :
    controlledShift
        (coordinateBasis (G := Cycle3) 2 ⊗ₜ[ℂ]
          coordinateBasis (G := Cycle3) 2) =
      coordinateBasis (G := Cycle3) 2 ⊗ₜ[ℂ]
        coordinateBasis (G := Cycle3) 1 := by
  rw [controlledShift_basis]
  congr 1

example (a : Cycle3 → ℂ) :
    controlledShift (preparedState a) = correlatedState a :=
  controlledShift_superposition a

example (a : Cycle3 → ℂ) :
    Everett.RelativeState.conditional (coordinateBasis (G := Cycle3) 1)
        (correlatedState a) =
      a 1 • coordinateBasis (G := Cycle3) 1 :=
  conditional_correlatedState a 1

end Everett.Analytic.Examples
