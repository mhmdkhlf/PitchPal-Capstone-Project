import axios from "axios";
export const api = "http://localhost:5000/api/";
export function isLoggedIn() {
  if (sessionStorage.getItem("user")) {
    return true;
  }
  return false;
}
export async function isPlayerAuthenticated(requestedPlayerID) {
  let isPlayer = await axios.get(
    "http://localhost:5000/api/getPlayerByEmail/" +
      sessionStorage.getItem("user")
  );
  if (!isPlayer.data) {
    return false;
  }
  if (!isPlayer.data.playerID !== requestedPlayerID) {
    return false;
  }
  return true;
}
export async function isManagerAuthenticated(requestedManagerEmail) {
  let isManager = await axios.get(
    "http://localhost:5000/api/getManager/" + sessionStorage.getItem("user")
  );
  if (!isManager.data) {
    return false;
  }
  if (!isManager.data.email !== requestedManagerEmail) {
    return false;
  }
  return true;
}
