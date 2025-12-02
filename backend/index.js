const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');

// Import Models
const Student = require('./models/student');
const CheckIn = require('./models/checkin');

const app = express();
const PORT = 3000; // Your server will run on this port

// Middleware
app.use(cors()); // Allow Flutter to access this
app.use(bodyParser.json()); // Parse JSON data sent from Flutter

// --- 1. CONNECT TO MONGODB ---
// Replace 'student_checkin_db' with your preferred database name.
// If you are using MongoDB Atlas (Cloud), paste your connection string here.
mongoose.connect('mongodb://127.0.0.1:27017/student_checkin_db')
    .then(() => console.log('MongoDB Connected Successfully'))
    .catch(err => console.log('MongoDB Connection Error:', err));


// --- 2. API ROUTES (As requested in PDF) ---

// A. POST /students -> Add a new student
app.post('/students', async (req, res) => {
    try {
        const { name, email, studentId } = req.body;
        
        // Create new student
        const newStudent = new Student({ name, email, studentId });
        await newStudent.save();
        
        res.status(201).json({ message: "Student added successfully", student: newStudent });
    } catch (error) {
        // Handle duplicate ID or validation errors
        res.status(400).json({ error: error.message });
    }
});

// B. GET /students -> Get all students (for Home Screen)
app.get('/students', async (req, res) => {
    try {
        const students = await Student.find();
        res.status(200).json(students);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// C. POST /checkin -> Record a check-in
app.post('/checkin', async (req, res) => {
    try {
        const { studentId } = req.body;
        
        // Check if student exists first
        const studentExists = await Student.findOne({ studentId });
        if (!studentExists) {
            return res.status(404).json({ message: "Student ID not found" });
        }

        const newCheckIn = new CheckIn({ studentId });
        await newCheckIn.save();

        res.status(201).json({ message: "Check-in successful", checkIn: newCheckIn });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// D. GET /checkins -> Get check-in history
app.get('/checkins', async (req, res) => {
    try {
        // Sort by newest first
        const checkins = await CheckIn.find().sort({ checkInTime: -1 });
        res.status(200).json(checkins);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// --- 3. START SERVER ---
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});