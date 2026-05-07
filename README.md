# MEDex AI – Disease Prediction Expert System

## Overview
MEDex AI is a simple AI-based medical expert system developed using Prolog for logical inference and HTML/CSS for the frontend interface.

The system predicts possible diseases based on symptoms entered by the user using rule-based reasoning techniques.

This project demonstrates the implementation of Artificial Intelligence concepts such as:
- Expert Systems
- Knowledge Representation
- Rule-Based Inference

---

## Features
- Symptom-based disease prediction
- Rule-based inference using Prolog
- Simple frontend interface
- Fast diagnosis suggestions
- Beginner-friendly AI project

---

## Technologies Used

### Frontend
- HTML
- CSS
- JavaScript

### AI Logic
- Prolog

---

## How the System Works

1. User enters symptoms.
2. Symptoms are processed using Prolog rules.
3. The inference engine matches symptoms with diseases.
4. The predicted disease is displayed to the user.

---

## Sample Diseases Included
- Flu
- Cold
- Malaria
- Typhoid
- Viral Fever

---

## Project Structure

```text
MEDex-AI/
│
├── index.html
├── style.css
├── script.js
├── disease.pl
└── README.md
```

---

## Prolog Knowledge Base Example

```prolog
disease(flu) :-
    symptom(fever),
    symptom(cough),
    symptom(headache).

disease(cold) :-
    symptom(cough),
    symptom(sneezing).

disease(malaria) :-
    symptom(fever),
    symptom(chills),
    symptom(vomiting).
```

---

## Frontend Example

```html
<input type="text" placeholder="Enter Symptoms">
<button>Predict Disease</button>
```

---

## Objectives
- To understand expert systems
- To implement AI concepts using Prolog
- To build a basic healthcare diagnosis system
- To apply rule-based reasoning in real-world problems

---

## Advantages
- Easy to understand
- Lightweight project
- Simple AI implementation
- Quick symptom analysis

---

## Future Enhancements
- Add more diseases
- Improve user interface
- Add database support
- Integrate chatbot assistance
- Add machine learning predictions

---

## Conclusion
MEDex AI is a basic medical expert system that uses Prolog inference rules to predict diseases based on symptoms. It demonstrates the practical use of Artificial Intelligence concepts in healthcare applications.

---

## Contributors
- Adapa Meenakshi
- Padala Vivel vardhan
- Yamasani Rishik
- Abhiram Murthy

---

## License
This project is created for academic and educational purposes only.
