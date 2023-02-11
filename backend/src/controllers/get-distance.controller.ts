import {Request, Response} from 'express';

function getDistanceFromLatLonInKm(lat1 :number, long1 :number, lat2 :number, long2 :number) {
    const EARTH_RADIUS = 6371; // Radius of the earth in km
    let dLat = deg2rad(lat2 - lat1);  // deg2rad below
    let dLon = deg2rad(long2 - long1);
    let a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2);
    let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    let d = EARTH_RADIUS * c; // Distance in km
    return d.toFixed(2);
  }
  function deg2rad(deg: number) {
    return deg * (Math.PI/180)
  }

const calculateDistance = async (req: Request, res: Response) => {
    let playerLat: number = parseFloat(req.body.player_lat);
    let playerLong: number = parseFloat(req.body.player_lon);
    let facilityLat: number = parseFloat(req.body.facility_lat);
    let facilityLong: number = parseFloat(req.body.facility_lon);
    try {
        res.status(200).json({d: getDistanceFromLatLonInKm(playerLat, playerLong, facilityLat, facilityLong)});
    }
    catch (error) {
        res.status(400).json({ message: error.message });
    }
}

module.exports = {calculateDistance};
