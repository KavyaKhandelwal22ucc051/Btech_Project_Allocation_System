const mongoose = require('mongoose');

 const dbConnection = () => {mongoose.connect(process.env.MONGO_URL ,{
    dbName : 'BTP-system'
}).then(() => {
    console.log('Database connected');
}).catch((err) => {
    console.log('Database connection failed');
});

};

module.exports = {dbConnection};
