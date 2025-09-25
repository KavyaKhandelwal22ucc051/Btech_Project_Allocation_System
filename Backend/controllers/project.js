const catchAsyncErrors = require("../middleware/catchAsyncError");
const ErrorHandler = require("../middleware/ErrorHandler");
const {Project} = require("../modules/project");
const {User} = require("../modules/user");



// TO SEE ALL PROJECTS THAT HAVE NOT BEEN EXPIRED (OR STILL AVAILABLE)
 const getAllProjects = catchAsyncErrors(async (req, res, next) => {
    const projects = await Project.find({ expired: false });
    res.status(200).json({
      success: true,
      projects,
    });
  });
  
  
  
  
 const postProject = catchAsyncErrors(async (req, res, next) => {
    const { role } = req.user;
    const lowerRole = role.toLowerCase();
    if (lowerRole === "student") {
      return next(
        new ErrorHandler("Student not allowed to access this resource.", 400)
      );
    }
    const {
      title,
      description,
      category,
      country,
      duration,
      cgpa,
      salaryFrom,
      salaryTo,
    } = req.body;
  
    if (!title || !description || !category || !country || !cgpa || !duration) {
      return next(new ErrorHandler("Please provide full project details.", 400));
    }
  
    const postedBy = req.user._id;
  
    let facultyUser = await User.findById(postedBy);
    let facultyName = facultyUser.name;
    let facultyDepartment = facultyUser.branch;
    let total = facultyUser.totalprojects;
    total = total + 1;
    facultyUser = await User.findByIdAndUpdate(
      postedBy,
      { totalprojects: total },
      { new: true, runValidators: true }
    );
  
    let curr = facultyUser.currprojects;
    curr = curr + 1;
    facultyUser = await User.findByIdAndUpdate(
      postedBy,
      { currprojects: curr },
      { new: true, runValidators: true }
    );
    const project = await Project.create({
      title,
      description,
      category,
      country,
  
      salaryFrom,
      salaryTo,
      postedBy,
      facultyName,
      cgpa,
      facultyDepartment,
      duration,
    });
    res.status(200).json({
      success: true,
      message: "Project Posted Successfully!",
      project,
    });
  });
  
  
  
  
 const getMyProjects = catchAsyncErrors(async (req, res, next) => {
    const { role } = req.user;
    if (role === "Student") {
      return next(
        new ErrorHandler("Student not allowed to access this resource.", 400)
      );
    }
    const myProjects = await Project.find({ postedBy: req.user._id });
    res.status(200).json({
      success: true,
      myProjects,
    });
  });
  
  
  
  
  
 const updateProject = catchAsyncErrors(async (req, res, next) => {
    const { role } = req.user;
    if (role === "Student") {
      return next(
        new ErrorHandler("Student not allowed to access this resource.", 400)
      );
    }
    const { id } = req.params;
    let project = await Project.findById(id);
  
    if (!project) {
      return next(new ErrorHandler("OOPS! Project not found.", 404));
    }
    project = await Project.findByIdAndUpdate(id, req.body, {
      new: true,
      runValidators: true,
      useFindAndModify: false,
    });
    res.status(200).json({
      success: true,
      message: "Project Updated!",
    });
  });
  
  
  
  
  
 const deleteProject = catchAsyncErrors(async (req, res, next) => {
    const { role } = req.user;
     if (role === "Student") {
       return next(
    new ErrorHandler("Student not allowed to access this resource.", 400)
      );
     }
    const { id } = req.params;
    const project = await Project.findById(id);
    const postedas = project.postedBy;
    let facultyUser = await User.findById(postedas);
    let curr = facultyUser.currprojects;
    curr = curr - 1;
    facultyUser = await User.findByIdAndUpdate(
      postedas,
      { currprojects: curr },
      { new: true, runValidators: true }
    );
  
    if (project) {
      res.status(200).json({
        success: true,
        message: "Project Deleted!",
      });
    }
    if (!project) {
      await project.deleteOne();
      res.status(200).json({
        success: true,
        message: "Project was already deleted before we deleted !",
      });
    }
  });
  
  
  
  
  //when user wants one project
 const getSingleProject = catchAsyncErrors(async (req, res, next) => {
    // whatever is send form frontedn in url path is extracted from req.params fuction
    const { id } = req.params;
    try {
      const project = await Project.findById(id);
      if (!project) {
        return next(new ErrorHandler("Project not found.", 404));
      }
      res.status(200).json({
        success: true,
        project,
      });
    } catch (error) {
      return next(new ErrorHandler(`Invalid ID / CastError`, 404));
    }
  });

  module.exports = {getAllProjects, postProject, getMyProjects, updateProject, deleteProject, getSingleProject};