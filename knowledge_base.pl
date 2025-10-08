%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MEDICAL KNOWLEDGE BASE
%
% Logical facts and rules for a medical diagnosis system.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------------------------------------------------------------------
% SECTION 1: FACTS - Symptom-Disease Mappings
%-------------------------------------------------------------------------------

% -- Common Respiratory Illnesses --
symptom(common_cold, cough).
symptom(common_cold, sore_throat).
symptom(common_cold, runny_nose).
symptom(common_cold, sneezing).

symptom(flu, fever).
symptom(flu, body_aches).
symptom(flu, cough).
symptom(flu, headache).
symptom(flu, severe_fatigue).

symptom(covid19, fever).
symptom(covid19, cough).
symptom(covid19, loss_of_smell).
symptom(covid19, fatigue).
symptom(covid19, shortness_of_breath).

% -- Bacterial Infections --
symptom(strep_throat, severe_sore_throat).
symptom(strep_throat, fever).
symptom(strep_throat, swollen_tonsils).
symptom(strep_throat, white_spots_on_tonsils).

% -- Head and Sinus Conditions --
symptom(sinusitis, facial_pain).
symptom(sinusitis, nasal_congestion).
symptom(sinusitis, headache).
symptom(sinusitis, thick_nasal_mucus).

symptom(migraine, severe_headache).
symptom(migraine, nausea).
symptom(migraine, sensitivity_to_light).
symptom(migraine, vomiting).

%-------------------------------------------------------------------------------
% SECTION 2: DIAGNOSTIC RULES
%-------------------------------------------------------------------------------

% Full Match Diagnosis:
% The patient must have *all* symptoms of a disease.
diagnose_exact(Patient, Disease) :-
    symptom(Disease, _),
    \+ (symptom(Disease, Symptom), \+ has_symptom(Patient, Symptom)).

% Partial Match Diagnosis:
% A disease can be suggested if the patient has *at least two* of its symptoms.
diagnose_partial(Patient, Disease) :-
    findall(Symptom,
        (has_symptom(Patient, Symptom), symptom(Disease, Symptom)),
        MatchingSymptoms),
    length(MatchingSymptoms, Count),
    Count >= 2.

% Combined diagnostic rule:
% First try to find exact matches; if none exist, suggest partial matches.
diagnose(Patient, Disease) :-
    diagnose_exact(Patient, Disease).
diagnose(Patient, Disease) :-
    \+ diagnose_exact(Patient, _),
    diagnose_partial(Patient, Disease).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of Knowledge Base
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
