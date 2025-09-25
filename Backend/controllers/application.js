const catchAsyncErrors = require("../middleware/catchAsyncError");
const ErrorHandler = require("../middleware/ErrorHandler");
const { Application } = require("../modules/application");
const { Project } = require("../modules/project");

const postApplication = catchAsyncErrors(async (req, res, next) => {
  const { role } = req.user;
  if (role === "Faculty") {
    return next(
      new ErrorHandler("Faculty not allowed to access this resource.", 400)
    );
  }

  const { name, email, coverLetter, phone, address, projectId, cgpa } =
    req.body;
  const applicantID = {
    user: req.user._id,
    role: "Student",
  };
  if (!projectId) {
    return next(new ErrorHandler("Project not found!", 404));
  }
  //const stu = await User.findById(req.user._id);
  const branch = "ECE";
  const projectDetails = await Project.findById(projectId);
  if (!projectDetails) {
    return next(new ErrorHandler("Project not found!", 404));
  }

  const facultyID = {
    user: projectDetails.postedBy,
    role: "Faculty",
  };
  if (
    !name ||
    !email ||
    !coverLetter ||
    !phone ||
    !address ||
    !applicantID ||
    !facultyID ||
    !projectId
  ) {
    return next(new ErrorHandler("Please fill all fields.", 400));
  }
  const application = await Application.create({
    name,
    email,
    coverLetter,
    phone,
    address,
    applicantID,
    facultyID,
    projectId,
    branch,
    cgpa,
  });

  res.status(200).json({
    success: true,
    message: "Application Submitted!",
    application,
  });
});

const facultyGetAllApplications = catchAsyncErrors(
  async (req, res, next) => {
    const { role } = req.user;
    if (role === "Student") {
      return next(
        new ErrorHandler("Student not allowed to access this resource.", 400)
      );
    }
    const { _id } = req.user;
    const applications = await Application.find({ "facultyID.user": _id });
    res.status(200).json({
      success: true,
      applications,
    });
  }
);

const studentGetAllApplications = catchAsyncErrors(
  async (req, res, next) => {
    const { role } = req.user;
    // if (role === "Faculty") {
    //   return next(
    //     new ErrorHandler("Faculty not allowed to access this resource.", 400)
    //   );
    // }
    const { _id } = req.user;
    const applications = await Application.find({ "applicantID.user": _id });
    res.status(200).json({
      success: true,
      applications,
    });
  }
);

const studentGetSingleApplication = catchAsyncErrors(
  async (req, res, next) => {
    const { id } = req.params;
    const application = await Application.findById(id);
    if (!application) {
      new ErrorHandler("Application Not found", 400);
    }

    res.status(200).json({
      success: true,
      application,
    });
  }
);

const studentDeleteApplication = catchAsyncErrors(
  async (req, res, next) => {
    // const { role } = req.user;
    // if (role === "Faculty") {
    //   return next(
    //     new ErrorHandler("Faculty not allowed to access this resource.", 400)
    //   );
    // }
    const { id } = req.params;
    const application = await Application.findById(id);
    if (!application) {
      return next(new ErrorHandler("Application not found!", 404));
    }
    await application.deleteOne();
    res.status(200).json({
      success: true,
      message: "Application Deleted!",
    });
  }
);

module.exports = {
  postApplication,
  facultyGetAllApplications,
  studentGetAllApplications,
  studentGetSingleApplication,
  studentDeleteApplication
};