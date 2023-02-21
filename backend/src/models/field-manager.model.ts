import mongoose from 'mongoose';

const fieldManagerSchema = new mongoose.Schema({
    email: {
        type: String,
        required: true,
        unique:true
    },
    mobileNumber:{
        type:String,
        required:true
    },
    name:{
        type:String,
        required:true
    },
    sportCenterName:{
        type:String,
        required:true
    }
    
}, { collection: 'FieldManager' }
);

module.exports = mongoose.model('FieldManager', fieldManagerSchema);