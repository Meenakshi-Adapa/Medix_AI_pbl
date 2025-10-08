const express = require('express');
const cors = require('cors');
const path = require('path');
const { spawn } = require('child_process');

const app = express();
const PORT = 3000;

// --- Middleware ---
// Enable Cross-Origin Resource Sharing for all routes
app.use(cors());
// Enable parsing of JSON request bodies
app.use(express.json());

// --- API Endpoint for Diagnosis ---
app.post('/diagnose', (req, res) => {
    // 1. Get symptoms from the request body
    const { symptoms } = req.body;
    if (!symptoms || !Array.isArray(symptoms) || symptoms.length === 0) {
        return res.status(400).json({ error: 'Symptoms must be a non-empty array.' });
    }

    // 2. Define the path to the Python script and format the symptoms
    const scriptPath = path.join(__dirname, '..', 'inference.py');
    const symptomsString = symptoms.join(',');

    // 3. Spawn a child process to execute the Python script
    const pythonProcess = spawn('python', [scriptPath, symptomsString]);

    let resultData = '';
    let errorData = '';

    // 4. Listen for data output from the script's standard output
    pythonProcess.stdout.on('data', (data) => {
        resultData += data.toString();
    });

    // 5. Listen for any errors from the script's standard error
    pythonProcess.stderr.on('data', (data) => {
        errorData += data.toString();
    });

    // 6. Handle the script's completion
    pythonProcess.on('close', (code) => {
        if (code !== 0 || errorData) {
            console.error(`Python script error: ${errorData}`);
            return res.status(500).json({ error: 'An error occurred during diagnosis.', details: errorData });
        }
        try {
            // Robustly find the start of the JSON object to avoid parsing errors
            const jsonStartIndex = resultData.indexOf('{');
            if (jsonStartIndex === -1) {
                throw new Error("No JSON object found in Python script output.");
            }
            const jsonString = resultData.substring(jsonStartIndex);
            const result = JSON.parse(jsonString);
            res.json(result);
        } catch (e) {
            console.error(`JSON Parse Error: ${e.message}`);
            res.status(500).json({ error: 'Failed to parse the diagnosis result.' });
        }
    });
});

// --- Serve the Frontend HTML File ---
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// --- Start the Server ---
app.listen(PORT, () => {
    console.log(`Diagnosis server is running on http://localhost:${PORT}`);
});

