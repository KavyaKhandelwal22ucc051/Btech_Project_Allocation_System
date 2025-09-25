const express = require('express');
const app = express();
const cors = require('cors');
const {config} = require('dotenv');
const {dbConnection} = require('./dbConnection.js');
const userRoutes = require('./routes/user.js');
const excpress = require('express');
const errorMiddleware = require('./middleware/error');
const projectRoutes = require('./routes/project.js');
const applicationRoutes = require('./routes/application.js');

module.exports = app;

config({path: ".env"});

app.use(cors({
    origin: true,
    credentials:false,
    methods: ['GET','POST','PUT','DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization','X-Requested-With']
}));

app.use(express.json());
app.use(express.urlencoded({extended: true}));



app.use("/api/v1/user",userRoutes);
app.use("/api/v1/project",projectRoutes);
app.use("/api/v1/application",applicationRoutes);

dbConnection();

app.use(errorMiddleware);

module.exports = app;