const {User} = require("../modules/user");
const {sendToken} = require("../utils/jwtToken");
const catchAsyncError = require("../middleware/catchAsyncError");
const ErrorHandler = require("../middleware/ErrorHandler");
const bcrypt = require("bcryptjs");


function isLnmiitEmail (email) {
    const emailIsRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    const domain  = "lnmiit.ac.in";

    if(!emailIsRegex.test(email)){
        return false;
    }

    const lowerCaseEmail = email.toLowerCase();

    if(!lowerCaseEmail.endsWith(domain)){
        return false;
    }

    return true;
}

//Register a user

const register = catchAsyncError(async (req , res , next) => {
    const {name, email,password,phoneNumber,role,branch} = req.body;
    if(!name || !email || !password || !phoneNumber || !role || !branch
    ){
        return next(new ErrorHandler("Please enter all fields",400));
    }

    const isEmail = await User.findOne({email});
    if(isEmail){
        return next (new ErrorHandler("Email already exists",400));
    }

    if(!isLnmiitEmail(email)){
        return next(new ErrorHandler("Please enter a valid lnmiit email",400));
    }

    const totalProjects = 0;
    const currProjects = 0;

    const lowerRole = role.toLowerCase();

    const user = await User.create({
        name,
        email,
        password,
        phoneNumber,
        role: lowerRole,
        totalProjects,
        currProjects,
        branch
        
    });

    sendToken(user,201,res,"Registered Successfully");
});

//Login User

const login = catchAsyncError(async (req,res,next) => {
    const {email,password,role}  = req.body;

    if(!email || !password){
        return next(new ErrorHandler("Please enter email and password",400));
    }

    const user = await User.findOne({email});

    if(!user){
        return next(new ErrorHandler("Invalid email or password",401));
    }

    const userWithPassword = await User.findById(user._id).select("+password");

    const isPasswordMatched = await bcrypt.compare(password,userWithPassword.password);

    if(!isPasswordMatched){
        return next(new ErrorHandler("Invalid email or password",401));
    }

    const lowerRole = role.toLowerCase();

    if(user.role != lowerRole){
        return next(new ErrorHandler("Please select the correct role",400));
    }
    
    sendToken(user,200,res,"Logged in Successfully");

});

const logout = catchAsyncError(async (req,res,next) => {
    res.status(200).json({
        success: true,
        message: "Logged out Successfully"
    })
});

const getUser = catchAsyncError(async (req,res,next)=> {
    const user = req.user;
    res.status(200).json({
        success: true,
        user
    });
});

const getUserDetails = catchAsyncError(async (req,res,next) => {
    const {email} = req.params;
    const {password} = req.body;

    if(!email || !password){
        return next(new ErrorHandler("Please enter email and password",400));
    }

    const user = await User.findOne({email}).select("+password");

    if(!user){
        return next(new ErrorHandler("Invalid email or password",400));
    }

    const isPasswordMatched = await bcrypt.compare(password,user.password);

    if(!isPasswordMatched){
        return next(new ErrorHandler("Invalid email or password",400));
    }

    //remove password from user object
    const {password:_ ,...userWithoutPassword} = user.toObject();

    res.status(200).json({
        success : true,
        user: userWithoutPassword
    });
});

const getAllFaculty = catchAsyncError(async (req,res,next) => {
    const allFaculty  = await User.find({role:"Faculty"});

    res.status(200).json({
        success: true,
        allFaculty
    });
})

module.exports = {
    register,
    login,
    logout,
    getUser,
    getUserDetails,
    getAllFaculty
};









