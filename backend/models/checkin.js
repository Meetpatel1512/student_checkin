const mongoose = require('mongoose');

const checkInSchema = new mongoose.Schema({
    studentId: {
        type: String,
        required: true
    },
    studentName: { // <--- Add this field
        type: String,
        required: true
    },
    checkInTime: {
        type: Date,
        default: Date.now 
    }
});

module.exports = mongoose.model('CheckIn', checkInSchema);