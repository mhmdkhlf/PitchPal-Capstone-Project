import express from 'express';
const fieldController = require('../controllers/field.controller.ts');

const router = express.Router();

router.post('/newField', fieldController.newField);
router.get('/getFields/:sportCenterName',fieldController.getFieldsBySportCenterName)

module.exports = router;