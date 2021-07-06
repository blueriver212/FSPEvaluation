// the aim is to be able to set up an API that can returna geoJSON in a file
// once this is complete, can i return a file by its specific name?

// install required modules
var express = require('express');
var path = require('path');
var app = express();
var fs = require('fs');

// create a http server for the files
var http = require('http'); var https = require('https');
const { ppid } = require('process');

// var httpServer = http.createServer(app);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Our app is running on port ${ PORT }`);
});

app.use(function(req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "*");
	res.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
	res.setHeader('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
	next();
});

app.get('/',function (req, res) {
	res.send("Hello world from the data API on port"+PORT)
});

app.get('/test', function(req, res) {
	res.send({
		"array": [
		  1,
		  2,
		  3
		],
		"boolean": true,
		"color": "gold",
		"null": null,
		"number": 123,
		"object": {
		  "a": "b",
		  "c": "d"
		},
		"string": "Hello World"
	  })
});


app.get('/:date', function(req, res) {
	var date = req.params.date;
	var d = date.toString();
	const file = d.concat('.json');
	console.log(file);
	res.sendFile(path.join(__dirname, '/', file));
})