const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true,
        match: [/.+\@.+\..+/, 'Please fill a valid email address'] 
    },
    studentId: {
        type: String,
        required: true,
        unique: true 
    }
});

module.exports = mongoose.model('Student', studentSchema);