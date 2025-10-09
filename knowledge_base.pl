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

%-------------------------------------------------------------------------------
% EXTENSIONS: Symptom Severity, Duration, Patient Attributes, and Explanations
%-------------------------------------------------------------------------------

% Symptom severity levels: mild, moderate, high
symptom_severity(common_cold, cough, mild).
symptom_severity(common_cold, sore_throat, mild).
symptom_severity(common_cold, runny_nose, mild).
symptom_severity(common_cold, sneezing, mild).

symptom_severity(flu, fever, high).
symptom_severity(flu, body_aches, moderate).
symptom_severity(flu, cough, moderate).
symptom_severity(flu, headache, moderate).
symptom_severity(flu, severe_fatigue, high).

symptom_severity(covid19, fever, high).
symptom_severity(covid19, cough, moderate).
symptom_severity(covid19, loss_of_smell, high).
symptom_severity(covid19, fatigue, moderate).
symptom_severity(covid19, shortness_of_breath, high).

% Symptom duration: short, medium, long
symptom_duration(common_cold, cough, short).
symptom_duration(common_cold, sore_throat, short).
symptom_duration(common_cold, runny_nose, short).
symptom_duration(common_cold, sneezing, short).

symptom_duration(flu, fever, medium).
symptom_duration(flu, body_aches, medium).
symptom_duration(flu, cough, medium).
symptom_duration(flu, headache, medium).
symptom_duration(flu, severe_fatigue, medium).

symptom_duration(covid19, fever, medium).
symptom_duration(covid19, cough, medium).
symptom_duration(covid19, loss_of_smell, long).
symptom_duration(covid19, fatigue, medium).
symptom_duration(covid19, shortness_of_breath, medium).

% Patient attributes (examples)
% patient_age(Patient, Age).
% patient_condition(Patient, Condition).

% Extended diagnostic rules considering severity and duration
diagnose_exact_extended(Patient, Disease) :-
    symptom(Disease, _),
    \+ (symptom(Disease, Symptom),
        \+ has_symptom(Patient, Symptom)),
    \+ (symptom_severity(Disease, Symptom, Severity),
        \+ has_symptom_severity(Patient, Symptom, Severity)),
    \+ (symptom_duration(Disease, Symptom, Duration),
        \+ has_symptom_duration(Patient, Symptom, Duration)).

diagnose_partial_extended(Patient, Disease) :-
    findall(Symptom,
        (has_symptom(Patient, Symptom), symptom(Disease, Symptom)),
        MatchingSymptoms),
    length(MatchingSymptoms, Count),
    Count >= 2.

diagnose_extended(Patient, Disease) :-
    diagnose_exact_extended(Patient, Disease).
diagnose_extended(Patient, Disease) :-
    \+ diagnose_exact_extended(Patient, _),
    diagnose_partial_extended(Patient, Disease).

% Explanations for diseases
explanation(common_cold, 'Common cold is characterized by mild respiratory symptoms like cough and runny nose.').
explanation(flu, 'Flu typically presents with high fever, body aches, and fatigue.').
explanation(covid19, 'COVID-19 symptoms include fever, cough, loss of smell, and shortness of breath.').
explanation(strep_throat, 'Strep throat involves severe sore throat, swollen tonsils, and white spots.').
explanation(sinusitis, 'Sinusitis causes facial pain, nasal congestion, and thick nasal mucus.').
explanation(migraine, 'Migraine is characterized by severe headache, nausea, and sensitivity to light.').

