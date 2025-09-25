const mongoose = require("mongoose");
const validator = require("validator");

const applicationSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please provide your name!"],
    minLength: [3, "at least 3 len"],
    maxLength: [30, "at most 30 len"],
  },
  email: {
    type: String,
    validator: [validator.isEmail, "Please provide a valid email"],
    required: [true, "Please provide your email"],
  },
  coverLetter: {
    type: String,
    required: [true, "please provide your cover letter"],
  },
  phone: {
    type: Number,
    required: [true, "Please provide your Phone Number"],
  },
  address: {
    type: String,
    required: [true, "Please provide your address"],
  },
  applicantID: {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    role: {
      type: String,
      enum: ["Student"],
      required: true,
    },
  },
  facultyID: {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    role: {
      type: String,
      enum: ["Faculty"],
      required: true,
    },
  },
  projectId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  branch: {
    type: String,
    required: true,
  },
  cgpa: {
    type: Number,
    required: true,
    min: [4.0, "CGPA must be at least 4.0"],
    max: [10.0, "CGPA must be at most 10.0"],
  },
});

const Application = mongoose.model("Application", applicationSchema);

module.exports = { Application };