var http = require('http'),
    httpProxy = require('http-proxy');

//
// Create a proxy server with custom application logic
//
const RPC_HOST = process.env.RPC_HOST || 'localhost:8554';
const RPC_AUTH = process.env.RPC_AUTH || null;
if (!process.env.RPC_HOST || !process.env.RPC_AUTH) {
  console.log('Warning: RPC_HOST and/or RPC_AUTH not defined as environment variable.');
  console.log('Expected format of RPC_HOST is ip_address:port and expected format of RPC_AUTH is username:password');
}
var proxy = httpProxy.createProxyServer({ auth: RPC_AUTH });

//
// Create your custom server and just call `proxy.web()` to proxy
// a web request to the target passed in the options
// also you can use `proxy.ws()` to proxy a websockets request
//
var server = http.createServer(function(req, res) {
  // You can define here your custom logic to handle the request
  // and then proxy the request.
  if (req.method === 'OPTIONS') {
    res.writeHead(204, { 'Access-Control-Allow-Methods': 'POST, GET, OPTIONS, DELETE',
                         'Access-Control-Max-Age': '86400',
                         'Access-Control-Allow-Headers': req.headers['access-control-request-headers'] || 'content-type',
                         'Access-Control-Allow-Origin': req.headers['origin'] });
    res.end();
  } else {
    res.setHeader('Access-Control-Allow-Origin', '*');
    try {
      proxy.web(req, res, { target: 'http://' + RPC_HOST });
    } catch (err) {
      res.writeHead(500);
      res.write(err);
      res.end();
    }
  }
});

console.log("listening on port 5001")
server.listen(5001);