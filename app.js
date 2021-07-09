// // required packages for the API

// require('dotenv').config();
// const express = require('express');
// var pg = require('pg');
// const Client = require('pg').Client;
// pg.defaults.ssl = true;
// const bodyParser = require('body-parser');

// var http = require('http'); var https = require('https');


// console.log(process.env.DATABASE_URL);


// const client = new Client({
// 	connectionString: process.env.DATABASE_URL,
// 	database: "d6v2ejscl1vh5e", // please add your own
// 	host: "ec2-34-254-69-72.eu-west-1.compute.amazonaws.com", // please add your own
// 	user: "gucinuctgseutr", // please add your own
// 	password: "1b05716bb6382fc7e2ab5aa56ae1693b8fd62ec361f063a7ff2427e1be4047ac", // please add your own
// 	port: 5432,
// 	ssl: { 
//         rejectUnauthorized: false 
//     } 
// });

// const pool = new pg.Pool(client);
// const app = express();

// var httpServer = http.createServer(app);

// app.use(express.json());

// app.get('/', function(req, res) {
//     res.send("Hello and welcome to the satellite API, add a year onto the URL to return the year that you would like to see");
// })

// // this route will return all of the test satellites
// // app.get('/allSatellites', function (req, res) {
// //     pool.connect(function (err, client, done) {
// //         if (err) {
// //             console.log("not able to get a connection " + err) 
// //             res.status(400).send(err);
// //         }

// //         // want to return just 10 of the rows to test to see if it works

// //         var query = "select * from satellite_population.test;"
// //         console.log(query);

        
// //         client.query(query, function (err, result) {
// //             done();
// //             if (err) {
// //                 res.status(400).send(err)
// //             }
// //             res.status(200).send(result.rows);
// //         });
// //     });
// // });

// // create a route that should take the year, and will return the year 
// app.get('/:year', function (req, res) {
//     pool.connect(function (err, client, done) {
//         if (err) {
//             console.log("not able to get a connection " + err) 
//             res.status(400).send(err);
//         }

//         var year = req.params.year;

//         // want to return just 10 of the rows to test to see if it works

//         var query = "select * from satellite_population.test";
//         query = query + " where launch_date >= '"+year+"-01-01' AND  launch_date <=  '"+year+"-12-31';";

        
//         client.query(query, function (err, result) {
//             done();
//             if (err) {
//                 res.status(400).send(err)
//             }
//             res.status(200).send(result.rows);
//         });
//     });
// });


// app.listen(process.env.PORT || 3000, () => 
// 	console.log("Listening on PORT " + process.env.PORT)
// );

// module.exports = app;


// building an app that is exactly like the one that was in class

var express = require('express');
var path = require('path');
var app = express();
var fs = require('fs');

// add an https servert to serve the files

var http = require('http'); var https = require('https');

var httpServer = http.createServer(app);

port = 4480;
httpServer.listen(port);

app.use(function(req, res, next) {
	res.setHeader("Access-Control-Allow-Origin", "*");
	res.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
	res.setHeader('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
	next();
});

app.get('/',function (req, res) {
	res.send("Hello world from the data API on port"+port)
});


app.use(function(req,res,next) {
	var filename = path.basename(req.url);
	var extension = path.extname(filename);
	console.log("The file "+filename+" was requested.");
	next(); // this is what i could have been missing
})

const geoJSON = require('./geojson.js');
app.use('/', geoJSON);

const bodyParser = require('body-parser');
