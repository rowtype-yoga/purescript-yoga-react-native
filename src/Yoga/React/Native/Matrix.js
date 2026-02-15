const mkAff = (promise) => (onError, onSuccess) => {
  promise.then(onSuccess, onError);
  return (cancelError, onCancelerError, onCancelerSuccess) => onCancelerSuccess();
};

const jsonPost = (url, body, token) =>
  fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...(token ? { Authorization: "Bearer " + token } : {}) },
    body: JSON.stringify(body),
  }).then((r) => r.json());

const jsonPut = (url, body, token) =>
  fetch(url, {
    method: "PUT",
    headers: { "Content-Type": "application/json", Authorization: "Bearer " + token },
    body: JSON.stringify(body),
  }).then((r) => r.json());

const jsonGet = (url, token) =>
  fetch(url, {
    method: "GET",
    headers: { Authorization: "Bearer " + token },
  }).then((r) => r.json());

export const loginImpl = (homeserver) => (user) => (password) =>
  mkAff(jsonPost(homeserver + "/_matrix/client/v3/login", { type: "m.login.password", identifier: { type: "m.id.user", user }, password }));

export const syncImpl = (homeserver) => (accessToken) => (since) => (timeout) =>
  mkAff(jsonGet(homeserver + "/_matrix/client/v3/sync?timeout=" + timeout + (since ? "&since=" + since : ""), accessToken));

export const sendMessageImpl = (homeserver) => (accessToken) => (roomId) => (txnId) => (body) =>
  mkAff(jsonPut(homeserver + "/_matrix/client/v3/rooms/" + encodeURIComponent(roomId) + "/send/m.room.message/" + encodeURIComponent(txnId), { msgtype: "m.text", body }, accessToken));

export const joinedRoomsImpl = (homeserver) => (accessToken) =>
  mkAff(jsonGet(homeserver + "/_matrix/client/v3/joined_rooms", accessToken));

export const roomNameImpl = (homeserver) => (accessToken) => (roomId) =>
  mkAff(jsonGet(homeserver + "/_matrix/client/v3/rooms/" + encodeURIComponent(roomId) + "/state/m.room.name", accessToken).then((r) => r.name || "").catch(() => ""));

export const roomMembersImpl = (homeserver) => (accessToken) => (roomId) =>
  mkAff(jsonGet(homeserver + "/_matrix/client/v3/rooms/" + encodeURIComponent(roomId) + "/joined_members", accessToken).then((r) => Object.entries(r.joined || {}).map(([uid, info]) => ({ user_id: uid, displayname: info.display_name || uid }))));

export const genTxnId = () => "m" + Date.now() + "." + Math.random().toString(36).slice(2);

export const getJoinedRoomIds = (resp) => resp.joined_rooms || [];

export const getSyncNextBatch = (resp) => resp.next_batch || "";

export const getSyncJoinedRoomIds = (resp) => {
  const join = resp.rooms && resp.rooms.join;
  return join ? Object.keys(join) : [];
};

export const getSyncTimelineEvents = (resp) => (roomId) => {
  const join = resp.rooms && resp.rooms.join;
  const room = join && join[roomId];
  const timeline = room && room.timeline;
  return timeline && timeline.events ? timeline.events : [];
};

export const getEventType = (ev) => ev.type || "";
export const getEventSender = (ev) => ev.sender || "";
export const getEventBody = (ev) => (ev.content && ev.content.body) || "";
export const getEventMsgType = (ev) => (ev.content && ev.content.msgtype) || "";
export const getEventId = (ev) => ev.event_id || "";
export const getEventTs = (ev) => ev.origin_server_ts || 0;
export const getEventImageUrl = (ev) => (ev.content && ev.content.url) || "";

export const parseJsonImpl = (str) => {
  try { return JSON.parse(str); }
  catch (_) { return null; }
};

export const stringifyJson = (obj) => JSON.stringify(obj);
