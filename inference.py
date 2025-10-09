import json
import sys
import os
from pyswip import Prolog

# --- Silent debug (no prints to avoid JSON pollution) ---
def debug(msg):
    pass

# --- Setup Paths ---
script_dir = os.path.dirname(os.path.abspath(__file__))
kb_path = os.path.join(script_dir, "knowledge_base.pl")

# --- Initialize Prolog ---
prolog = Prolog()

try:
    prolog.consult(kb_path)
except Exception as e:
    print(json.dumps({"error": f"Failed to load knowledge base: {str(e)}"}))
    sys.exit(1)

# --- Fetch known facts (disease-symptom relationships) ---
try:
    facts = list(prolog.query("symptom(Disease, Symptom)"))
except Exception as e:
    print(json.dumps({"error": f"Error reading symptoms: {str(e)}"}))
    sys.exit(1)

# --- Read symptoms from CLI ---
if len(sys.argv) < 2:
    print(json.dumps({"error": "Please provide symptoms separated by commas."}))
    sys.exit(1)

symptoms_input = sys.argv[1]
symptoms = [s.strip().lower() for s in symptoms_input.split(",") if s.strip()]

if not symptoms:
    print(json.dumps({"error": "No valid symptoms provided."}))
    sys.exit(1)

# --- Assert patient symptoms ---
patient = "patient"
for symptom in symptoms:
    try:
        prolog.assertz(f"has_symptom({patient}, {symptom})")
    except Exception:
        pass

# --- Diagnose diseases ---
exact_matches = []
partial_matches = []
checked_diseases = set()

try:
    for result in prolog.query(f"diagnose({patient}, Disease)"):
        disease_str = str(result["Disease"])
        if not disease_str.startswith('_'):
            exact_matches.append(disease_str)
except Exception:
    pass

# --- Partial match analysis ---
for fact in facts:
    disease = str(fact["Disease"])
    if disease in checked_diseases:
        continue
    checked_diseases.add(disease)

    disease_symptoms = [str(f["Symptom"]) for f in facts if str(f["Disease"]) == disease]
    overlap = len(set(symptoms) & set(disease_symptoms))

    if 0 < overlap < len(disease_symptoms) and overlap >= 2:
        partial_matches.append({"disease": disease, "match_count": overlap})

# --- Cleanup patient facts ---
try:
    prolog.retractall(f"has_symptom({patient}, _)")
except Exception:
    pass

# --- Final diagnosis logic ---
final_diagnosis = list(set(exact_matches))
if not final_diagnosis:
    partial_matches.sort(key=lambda x: x["match_count"], reverse=True)
    final_diagnosis = [p["disease"] for p in partial_matches]

# --- Output clean JSON ---
result = {
    "exact": list(set(exact_matches)),
    "partial": partial_matches,
    "diagnose": final_diagnosis,
}

print(json.dumps(result))
