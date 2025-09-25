const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const validator = require('validator');

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Please enter your name'],
        maxLength: [30, 'Your name cannot exceed 30 characters'],
        minLength: [4, 'Your name must be at least 4 characters long']
    },
    email: {
        type: String,
        required: [true, 'Please enter your email'],
        unique: true,
        validate: [validator.isEmail, 'Please enter a valid email address']
    },
    password: {
        type: String,
        required: [true, 'Please enter your password'],
        minLength: [8, 'Your password must be at least 8 characters long'],
        select: false
    },phoneNumber: {
        type: String,
        required: [true, 'Please enter your phone number']
    },
    role: {
        type: String,
        required: [true, 'Please enter your role'],
        enum: {
            values: ['student', 'faculty']
        }
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    currProjects:{
        type:  Number,
        default: 0  
    },totalProjects:{
        type: Number,
        default: 0
    },branch:{
        type: String,
        required: [true, 'Please enter your branch']
    }
});

userSchema.pre('save', async function(next)
    {
        if(!this.isModified('password')){
            return next();
        }

        this.password = await bcrypt.hash(this.password, 10);
});

userSchema.methods.comparedPassword = async function(enteredPassword){
    return await bcrypt.compare(enteredPassword,this.password);
};

userSchema.methods.getJwtToken = function(){
    return jwt.sign({id: this._id}, process.env.JWT_SECRET_KEY, {
        expiresIn: process.env.JWT_SECRET_EXPIRES_TIME
    }
    );
};

const User = mongoose.model('User', userSchema);

module.exports = {User};