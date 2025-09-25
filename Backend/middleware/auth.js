const {User} = require("../modules/user");
const ErrorHandler = require("./ErrorHandler");
const catchAsyncError = require("./catchAsyncError");
const jwt = require("jsonwebtoken");

const isAuthenticatedUser = catchAsyncError(async (req,res,next)=>{
    const authHeader = req.headers.authorization;

    if(!authHeader || !authHeader.startsWith("Bearer ")){
        return next(new ErrorHandler("Please login to access this resource",401));
    }

    const token =  authHeader.split(" ")[1];

    if(!token){
        return next(new ErrorHandler("Please login to access this resource",401));
    }

    const decodedData = jwt.verify(token, process.env.JWT_SECRET_KEY);

    const user = await User.findById(decodedData.id);

    if(!user){
        return next(new ErrorHandler("User not found",404));
    }

    req.user = user;
    next();

});

module.exports = isAuthenticatedUser;