module

import Everett.API

/-!
# Principal-export axiom audit

Building this leaf prints the logical axioms used by representative public
theorems spanning every core claim. No declaration is introduced here.
-/

#print axioms Everett.RelativeState.inner_conditional
#print axioms Everett.RelativeState.normalizedConditional_unique
#print axioms Everett.RelativeState.reconstruction
#print axioms Everett.Measurement.IdealData.unitaryExtension
#print axioms Everett.Measurement.FullUnitary.map_superposition
#print axioms Everett.Measurement.RepeatStepData.repeatIsometry_input
#print axioms Everett.Records.Independent.iteratedState_eq_sum
#print axioms Everett.Weights.additive_eq_mul
#print axioms Everett.Weights.sequenceWeight_eq_prod
#print axioms Everett.Probability.exceptionalFrequencyMass_le
#print axioms Everett.Probability.exceptionalFrequencyMass_tendsto_zero
#print axioms Everett.Records.Encoding.copyIsometry_basis
#print axioms Everett.Measurement.disagreement_possible
#print axioms Everett.Measurement.local_maps_commute
#print axioms Everett.Comparison.FiniteProjectiveExperiment.sameOutcomeMasses
#print axioms Everett.Comparison.FiniteProjectiveExperiment.sameNonzeroConditionals
#print axioms Everett.Comparison.FiniteProjectiveExperiment.sameSequenceMasses
