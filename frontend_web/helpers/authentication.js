import axios from "axios";
export const api = "http://localhost:5000/api/";
export function isLoggedIn() {
  if (sessionStorage.getItem("user")) {
    return true;
  }
  return false;
}
export async function isPlayerAuthenticated(requestedPlayerID) {
  if (!isLoggedIn()) {
    return false;
  }
  let isPlayer = await axios.get(
    "http://localhost:5000/api/getPlayerByEmail/" +
      sessionStorage.getItem("user")
  );
  if (!isPlayer.data) {
    return false;
  }
  if (isPlayer.data.playerID !== requestedPlayerID) {
    return false;
  }
  return true;
}
export async function isManagerAuthenticated(requestedManagerEmail) {
  if (!isLoggedIn()) {
    return false;
  }
  let isManager = await axios.get(
    "http://localhost:5000/api/getManager/" + sessionStorage.getItem("user")
  );
  if (!isManager.data) {
    return false;
  }
  if (isManager.data.email !== requestedManagerEmail) {
    return false;
  }
  return true;
}
export async function isTeamAuthenticated(requestedName) {
  if (!isLoggedIn()) {
    return false;
  }
  let playerEmail = sessionStorage.getItem("user");
  let isPlayer = await axios.get(
    "http://localhost:5000/api/getPlayerByEmail/" + playerEmail
  );
  if (!isPlayer.data) {
    return false;
  }
  let teams = await axios.get(
    "http://localhost:5000/api/getTeamsByCaptain/" + isPlayer.data.playerID
  );
  for (let i = 0; i < teams.data.length; i++) {
    if (teams.data[i].name === requestedName) {
      return true;
    }
  }
  return false;
}
export async function isSportCenterAuthenticated(sportCenterName) {
  let one = isManagerAuthenticated(sessionStorage.getItem("user"));
  const Request = await axios.post(
    "http://localhost:5000/api/isManagerForSportCenter",
    {
      email: sessionStorage.getItem("user"),
      sportCenterName: sportCenterName,
    }
  );
  let data = Request.data;
  if (isLoggedIn() && data.result && one) {
    return true;
  }
  return false;
}
