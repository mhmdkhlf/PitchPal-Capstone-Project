import { Request, Response } from "express";
const CoordParser = require("google-maps-coordinate-parser");

function helper(googleMapsLink: string) {
  if (!googleMapsLink.startsWith("https://www.google.com/maps/place/"))
    throw Error(
      "Invalid google maps link. Link should start with 'https://www.google.com/maps/place/' " +
        "(your sport-center should be registered as a place in google maps)"
    );
  const coordinates = CoordParser.parse(googleMapsLink);
  if (coordinates.longitude === 0 && coordinates.latitude === 0)
    throw Error("Link is not complete");
  return coordinates;
}

async function getCoordinatesFromGoogleMapsLink(req: Request, res: Response) {
  try {
    const coordinates = helper(req.body.link);
    res.status(200).json(coordinates);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

module.exports = { getCoordinatesFromGoogleMapsLink };