const express = require("express");
const router = express.Router();
const  isAuthenticatedUser  = require("../middleware/auth");
const {
  postApplication,
  facultyGetAllApplications,
  studentGetAllApplications,
  studentGetSingleApplication,
  studentDeleteApplication
} = require("../controllers/application");

// Route to post a new application (only for Students)
router.post("/post", isAuthenticatedUser, postApplication); 

// Route to get all applications (only for Faculty and Admin)
router.get("/getAll", isAuthenticatedUser, facultyGetAllApplications);

// Route to get all applications of the authenticated student
router.get("/myapplications", isAuthenticatedUser, studentGetAllApplications);

// Route to get a single application by ID (only for the applicant)
router.get("/:id", isAuthenticatedUser, studentGetSingleApplication);

// Route to delete an application by ID (only for the applicant)
router.delete("/delete/:id", isAuthenticatedUser, studentDeleteApplication);

module.exports = router;