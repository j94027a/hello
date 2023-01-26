const appguard = require('@extrinsec/appguard');
const axios = require('axios');

exports.demo_nodejs = (req, res) => {
  axios.get("https://www.google.com");
  let message = req.query.message || req.body.message || "Go Appguard!!";
  res.status(200).send(message);
};
