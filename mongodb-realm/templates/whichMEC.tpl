// This function is the endpoint's request handler.
exports = async function({ query, headers, body}, response) {
    // Query params, e.g. '?arg1=hello&arg2=world' => {arg1: "hello", arg2: "world"}
    //const {ipAddr} = query;
    
    //const ipAddr = headers["X-Forwarded-For"][0];
    var ipAddr = "174.204.128.102";

    console.log("Using IP: " + ipAddr);
    var appKey = ${appKey};
    var secretKey = ${secretKey};
    var serviceEndpointsId = ${serviceEndpoints};
    
    const axios = require('axios').default;
    const qs = require("qs");
    
    try {
      var tokenresponse = await axios.request(
        { 
          url: "https://5gedge.verizon.com/api/ts/v1/oauth2/token",
          method: 'post',
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          data: qs.stringify({"grant_type" : "client_credentials"}),
          auth: {"username": appKey, "password": secretKey}
        }
      );
      console.log(tokenresponse.data.access_token);
    } catch(ex) {
      console.log(ex);
    }
    
    try {
      var mecresponse = await axios.request(
        { 
          url: "https://5gedge.verizon.com/api/mec/eds/serviceendpoints?serviceEndpointsIds="+serviceEndpointsId+"&UEIdentityType=IPAddress&UEIdentity="+ipAddr,
          method: 'get',
          headers: {"Content-Type": "application/x-www-form-urlencoded", "Authorization": "Bearer "+tokenresponse.data.access_token},
          data: qs.stringify({"grant_type" : "client_credentials"})
        }
      );
      console.log(JSON.stringify(mecresponse.data));
      //console.log(mecresponse.data.serviceEndpoints[0].serviceEndpoint.IPv4Address, data.serviceEndpoints[0].serviceEndpoint.FQDN)
    } catch(ex) {
      console.log(ex);
    }
    
};
