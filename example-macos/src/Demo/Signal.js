export const createWebSocketImpl = (url, onOpen, onMessage, onClose, onError) => {
  var ws = new WebSocket(url);
  ws.onopen = () => onOpen();
  ws.onmessage = (e) => onMessage(e.data)();
  ws.onclose = () => onClose();
  ws.onerror = (e) => onError(e.message || "WebSocket error")();
  return ws;
};

export const closeWebSocket = (ws) => () => {
  ws.close();
};
