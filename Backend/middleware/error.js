const ErrorHandler = require('./ErrorHandler');

const errorMiddleware = (err,req,res,next) => {
    err.message = err.message || 'Internal Server Error';
    err.statusCode = err.statusCode || 500;

    if(err.name === "CastError"){
        const message = "Resource not found. Invalid: " + err.path;
        err = new ErrorHandeler(message,400);
    }

    if(err.code === 11000){
        const message = 'Duplicate' + Object.keys(err.keyValue) + 'entered';
        err = new ErrorHandeler(message,400);
    }

    if(err.name === "JsonWebTokenError"){
        const message = 'JSON web token is invalid, try again , try again';
        err = new ErrorHandeler(message,400);
    }

    if(err.name === "TokenExpiredError"){
        const message = "JSON web token is expired , try again";
        err = new ErrorHandeler(message,400);
    }

    return res.status(err.statusCode).json({
        success: false,
        message: err.message
    });
};

module.exports = errorMiddleware;