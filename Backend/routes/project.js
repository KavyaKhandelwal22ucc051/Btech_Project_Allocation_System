const express = require("express");
const router = express.Router();
const  isAuthenticatedUser  = require("../middleware/auth");
const {
  getAllProjects,
  postProject,
  getMyProjects,
  updateProject,
  deleteProject,
  getSingleProject,
} = require("../controllers/project");

// Route to get all projects that have not expired
router.get("/getAll", getAllProjects);

// Route to post a new project (only for Faculty and Admin)
router.post("/post", isAuthenticatedUser, postProject);

// Route to get projects posted by the authenticated user
router.get("/myprojects", isAuthenticatedUser, getMyProjects);

// Route to update a project (only for the project owner)
router.put("/update/:id", isAuthenticatedUser, updateProject);        

// Route to delete a project (only for the project owner)
router.delete("/:id", isAuthenticatedUser, deleteProject);

// Route to get a single project by ID
router.get("/getSingleProject/:id", getSingleProject);

module.exports = router;