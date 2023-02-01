import {Request, Response} from 'express';

function getDistanceFromLatLonInKm(lat1 :number, lon1:number, lat2:number, lon2:number) {
    //console.log(lat1);
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1); 
    var a = 
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
      Math.sin(dLon/2) * Math.sin(dLon/2)
      ; 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d.toFixed(2);
  }
  function deg2rad(deg:number) {
    return deg * (Math.PI/180)
  }

const calculateDistance = async (req: Request, res: Response) => {

    var player_lat:number = parseFloat(req.body.player_lat);
   // console.log(re);
    var player_lon:number = parseFloat(req.body.player_lon);
    var facility_lat:number = parseFloat(req.body.facility_lat);
    var facility_lon:number = parseFloat(req.body.facility_lon);

    try {
        
        res.status(200).json({d:getDistanceFromLatLonInKm(player_lat,player_lon,facility_lat,facility_lon)});
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}
//console.log(getDistanceFromLatLonInKm(59.3293371,13.4877472,59.3225525,13.4619422));

module.exports = {calculateDistance};


