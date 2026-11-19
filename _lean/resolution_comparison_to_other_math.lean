import Mathlib

/-!
# Resolution and five classical model-theoretic constructions

This file is an abstract interface comparing the Resolution property with
standard model-theoretic results. It does not prove Herbrand's theorem,
the Tarski--Vaught criterion, forcing theorems, or Lowenheim--Skolem theorems.

`Embeds M₀ M₁` is intended to assert a *proper first-order structure
embedding*, not merely an injection of underlying sets. `Sat M T` expresses
satisfaction of the *same* theory `T` in structure `M`.

The classical results are represented by explicit hypotheses where needed.
-/

namespace ResolutionRelationships

universe u v

variable {Model : Type u} {Theory : Type v}
variable (Sat : Model → Theory → Prop)
variable (Embeds : Model → Model → Prop)

/-- The Resolution property holds when a fixed theory fails in the source
    structure and holds in a proper structural extension. -/
def Resolves (M₀ M₁ : Model) (T : Theory) : Prop :=
  Embeds M₀ M₁ ∧ ¬ Sat M₀ T ∧ Sat M₁ T

/-- Agreement on satisfaction of every theory. This abstracts the
    sentence-level consequence of an elementary embedding; full elementarity
    also concerns formulas with parameters. -/
def Elementary (M₀ M₁ : Model) : Prop :=
  ∀ T : Theory, Sat M₀ T ↔ Sat M₁ T

section PreservationTheorems

/-- Upward preservation of a fixed theory along proper embeddings. -/
def UpwardPreserved (T : Theory) : Prop :=
  ∀ M₀ M₁, Embeds M₀ M₁ → Sat M₀ T → Sat M₁ T

/-- Downward reflection of a fixed theory along proper embeddings. -/
def DownwardReflected (T : Theory) : Prop :=
  ∀ M₀ M₁, Embeds M₀ M₁ → Sat M₁ T → Sat M₀ T

/-- Downward reflection excludes the Resolution property for that theory. -/
theorem downward_reflection_excludes_resolution
    {T : Theory} (h : DownwardReflected Sat Embeds T)
    {M₀ M₁ : Model} :
    ¬ Resolves Sat Embeds M₀ M₁ T := by
  intro ⟨he, hn, hs⟩
  exact hn (h M₀ M₁ he hs)

/-- When the Resolution property holds, the source does not satisfy T.
    Upward preservation alone does not contradict this fact. -/
theorem resolution_source_is_not_satisfied
    {T : Theory} {M₀ M₁ : Model}
    (h : Resolves Sat Embeds M₀ M₁ T) :
    ¬ Sat M₀ T := h.2.1

/-- The Resolution property rules out downward reflection for its fixed theory. -/
theorem resolution_implies_not_downward_reflected
    {T : Theory} {M₀ M₁ : Model}
    (h : Resolves Sat Embeds M₀ M₁ T) :
    ¬ DownwardReflected Sat Embeds T := by
  intro href
  exact h.2.1 (href M₀ M₁ h.1 h.2.2)

end PreservationTheorems

section Herbrand

variable (GroundCondition : Theory → Prop)

/-- Under an assumed Herbrand-style characterization, target satisfaction
    implies the corresponding ground-instance condition. The characterization
    is not asserted for arbitrary theories or arbitrary individual models. -/
theorem herbrand_target
    {T : Theory} {M₀ M₁ : Model}
    (hres : Resolves Sat Embeds M₀ M₁ T)
    (hHerbrand : Sat M₁ T ↔ GroundCondition T) :
    GroundCondition T :=
  hHerbrand.mp hres.2.2

/-- If the ground-instance condition characterizes target satisfaction,
    and the other conditions hold, the Resolution property holds. -/
theorem herbrand_with_extension
    {T : Theory} {M₀ M₁ : Model}
    (he : Embeds M₀ M₁)
    (hn : ¬ Sat M₀ T)
    (hHerbrand : Sat M₁ T ↔ GroundCondition T)
    (hg : GroundCondition T) :
    Resolves Sat Embeds M₀ M₁ T :=
  ⟨he, hn, hHerbrand.mpr hg⟩

end Herbrand

section TarskiVaught

/-- Sentence-level agreement excludes the Resolution property. -/
theorem elementary_excludes_resolution
    {M₀ M₁ : Model} (helem : Elementary Sat M₀ M₁)
    (T : Theory) :
    ¬ Resolves Sat Embeds M₀ M₁ T := by
  intro ⟨_, hn, hs⟩
  exact hn ((helem T).mpr hs)

/-- If the Tarski--Vaught criterion establishes elementarity for a pair,
    the Resolution property does not hold for that pair. -/
theorem tarski_vaught_elementary_excludes_resolution
    {M₀ M₁ : Model}
    (tarskiVaughtConclusion : Elementary Sat M₀ M₁)
    (T : Theory) :
    ¬ Resolves Sat Embeds M₀ M₁ T :=
  elementary_excludes_resolution Sat Embeds tarskiVaughtConclusion T

/-- If the Resolution property holds, sentence-level elementarity fails;
    therefore the full Tarski--Vaught criterion cannot hold for that pair. -/
theorem resolution_implies_not_elementary
    {M₀ M₁ : Model} {T : Theory}
    (hres : Resolves Sat Embeds M₀ M₁ T) :
    ¬ Elementary Sat M₀ M₁ := by
  intro helem
  exact (elementary_excludes_resolution Sat Embeds helem T) hres

/-- Non-elementarity alone does not imply Resolution for a *particular*
    fixed theory. With the required satisfaction change, Resolution holds. -/
theorem non_elementary_extension_with_truth_change
    {M₀ M₁ : Model} {T : Theory}
    (he : Embeds M₀ M₁)
    (hn : ¬ Sat M₀ T)
    (hs : Sat M₁ T) :
    Resolves Sat Embeds M₀ M₁ T :=
  ⟨he, hn, hs⟩

end TarskiVaught

section CohenForcingAndLifts

/-- A forcing extension or lift satisfies the Resolution property if it
    supplies a proper embedding and the required change in satisfaction.
    Neither follows from the word 'forcing' alone. -/
theorem forcing_extension_if_truth_changes
    {M₀ M₁ : Model} {T : Theory}
    (properEmbedding : Embeds M₀ M₁)
    (groundFails : ¬ Sat M₀ T)
    (extensionSucceeds : Sat M₁ T) :
    Resolves Sat Embeds M₀ M₁ T :=
  ⟨properEmbedding, groundFails, extensionSucceeds⟩

/-- An elementary lift cannot satisfy the Resolution property. -/
theorem elementary_lift_cannot_resolve
    {M₀ M₁ : Model} (helem : Elementary Sat M₀ M₁)
    (T : Theory) :
    ¬ Resolves Sat Embeds M₀ M₁ T :=
  elementary_excludes_resolution Sat Embeds helem T

end CohenForcingAndLifts

section LowenheimSkolem

/-- The elementary pairs supplied by the usual Lowenheim--Skolem results
    cannot satisfy the Resolution property, irrespective of cardinality. -/
theorem lowenheim_skolem_elementary_pair_cannot_resolve
    {M₀ M₁ : Model}
    (elementaryPair : Elementary Sat M₀ M₁)
    (T : Theory) :
    ¬ Resolves Sat Embeds M₀ M₁ T :=
  elementary_excludes_resolution Sat Embeds elementaryPair T

end LowenheimSkolem

end ResolutionRelationships
