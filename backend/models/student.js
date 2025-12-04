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
    },
    pincode: { type: String },
    district: { type: String },
    state: { type: String },
    country: { type: String }
});

module.exports = mongoose.model('Student', studentSchema);