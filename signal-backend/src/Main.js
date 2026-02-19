export const sendToWs = (ws) => (msg) => () => {
  ws.send(JSON.stringify({ type: "qrcode", url: msg }));
};

export const serveWithWsImpl = (options) => {
  const server = Bun.serve({
    port: options.port,
    hostname: options.host,
    fetch(req, server) {
      if (server.upgrade(req)) return undefined;
      return new Response("Signal Backend", { status: 200 });
    },
    websocket: {
      open(ws) {
        options.wsOpen(ws);
      },
      message(ws, msg) {
        options.wsMessage(ws, msg);
      },
      close(ws, code) {
        options.wsClose(ws, code);
      },
    },
  });
  return server;
};
