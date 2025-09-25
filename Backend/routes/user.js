const express = require('express');
const isAuthenticatedUser = require("../middleware/auth");

const router = express.Router();
const {register, login, logout, getUser, getUserDetails, getAllFaculty} = require("../controllers/user");

router.post("/register", register);
router.post("/login", login);
router.get("/logout", logout);
router.get("/me", isAuthenticatedUser, getUser);
router.get("/getUserDetails/:email",isAuthenticatedUser, getUserDetails);
router.get("/getAllFaculty", getAllFaculty);
module.exports = router;