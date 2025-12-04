const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken'); 
const Student = require('./models/student');
const CheckIn = require('./models/checkin');
const Admin = require('./models/admin'); 

const app = express();
const PORT = 3000;
const SECRET_KEY = "my_secret_key_123"; 

app.use(cors());
app.use(bodyParser.json());


mongoose.connect('mongodb://127.0.0.1:27017/student_checkin_db')
    .then(async () => {
        console.log('MongoDB Connected');
        
        const adminCount = await Admin.countDocuments();
        if (adminCount === 0) {
            await new Admin({ username: "admin", password: "admin123" }).save();
            console.log("👑 Admin Account Created: (User: admin, Pass: admin123)");
        }
    })
    .catch(err => console.log('❌ DB Error:', err));


app.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;
        
       
        const admin = await Admin.findOne({ username, password });
        
        if (!admin) {
            return res.status(401).json({ message: "Invalid Credentials" });
        }

       
        const token = jwt.sign({ id: admin._id }, SECRET_KEY, { expiresIn: '1h' });

        res.status(200).json({ message: "Login Successful", token });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.post('/students', async (req, res) => {
    try {
        const { name, email, studentId, pincode, district, state, country } = req.body;
        const newStudent = new Student({ name, email, studentId, pincode, district, state, country });
        await newStudent.save();
        res.status(201).json({ message: "Student added successfully" });
    } catch (error) {
        if (error.code === 11000) return res.status(400).json({ message: "Error: Student ID already exists!" });
        res.status(400).json({ message: error.message });
    }
});


app.get('/students', async (req, res) => {
    try {
        const students = await Student.find();
        res.status(200).json(students);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.post('/checkin', async (req, res) => {
    try {
        const { studentId } = req.body;
        const student = await Student.findOne({ studentId });
        if (!student) return res.status(404).json({ message: "Student ID not found" });

        const newCheckIn = new CheckIn({ studentId: student.studentId, studentName: student.name });
        await newCheckIn.save();
        res.status(201).json({ message: "Check-in successful" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


app.get('/checkins', async (req, res) => {
    try {
        const checkins = await CheckIn.find().sort({ checkInTime: -1 });
        res.status(200).json(checkins);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));