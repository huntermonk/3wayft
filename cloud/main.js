
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

require('cloud/user.js');

var opentok = require('cloud/opentok/opentok.js').createOpenTokSDK('45454712', '3b1897f750d50fb5383f98cefea181d93783cb69');

// Example function that creates a session
Parse.Cloud.define("opentokNewSession", function(request, response) {
  // The first parameter is an optional set of properties,
  // similar to http://www.tokbox.com/opentok/api/tools/documentation/api/server_side_libraries.html#create_session
  opentok.createSession(request.params, function(err, sessionId) {
    if (err) return response.error(err.message);
    response.success(sessionId);
    return;
  });
});

// Example function that generates a token
Parse.Cloud.define("opentokGenerateToken", function(request, response) {
  // The second parameter is an optional set of properties
  // similar to http://www.tokbox.com/opentok/api/tools/documentation/api/server_side_libraries.html#generate_token
  var token = opentok.generateToken(request.params.sessionId || '', request.params.options);
  if (token) return response.success(token);
  return response.error("You must specify a sessionId to generate a token");
});