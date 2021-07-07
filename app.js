// // the aim is to be able to set up an API that can returna geoJSON in a file
// // once this is complete, can i return a file by its specific name?

// // install required modules
// var express = require('express');
// var path = require('path');
// var app = express();
// var fs = require('fs');

// // create a http server for the files
// var http = require('http'); var https = require('https');
// const { ppid } = require('process');

// // var httpServer = http.createServer(app);

// const PORT = process.env.PORT || 3000;
// app.listen(PORT, () => {
//     console.log(`Our app is running on port ${ PORT }`);
// });

// app.use(function(req, res, next) {
// 	res.setHeader("Access-Control-Allow-Origin", "*");
// 	res.setHeader("Access-Control-Allow-Headers", "X-Requested-With");
// 	res.setHeader('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
// 	next();
// });

// app.get('/',function (req, res) {
// 	res.send("Hello world from the data API on port"+PORT)
// });

// app.use(function(req,res,next) {
// 	var filename = path.basename(req.url);
// 	var extension = path.extname(filename);
// 	console.log("The file "+filename+" was requested.");
// 	next(); // this is what i could have been missing
// })


// app.get('/test', function(req, res) {
// 	res.send({
// 		"array": [
// 		  1,
// 		  2,
// 		  3
// 		],
// 		"boolean": true,
// 		"color": "gold",
// 		"null": null,
// 		"number": 123,
// 		"object": {
// 		  "a": "b",
// 		  "c": "d"
// 		},
// 		"string": "Hello World"
// 	  })
// });


// // app.get('/:date', function(req, res) {
// // 	var date = req.params.date;
// // 	var d = date.toString();
// // 	const file = d.concat('.json');
// // 	console.log(file);
// // 	res.sendFile(path.join(__dirname, '/', file));
// // })



// const geoJSON = require('./routes/geoJSON');
// app.use('/', geoJSON);

// const bodyParser = require('body-parser');
// //crud.use(bodyParser.urlencoded({extended:true}));

require('dotenv').config();
const express = require('express');
//const cors = require('cors');
var pg = require('pg');
const Client = require('pg').Client;
pg.defaults.ssl = true;


console.log(process.env.DATABASE_URL);


const client = new Client({
	connectionString: process.env.DATABASE_URL,
	database: "d6v2ejscl1vh5e", 
	host: "ec2-34-254-69-72.eu-west-1.compute.amazonaws.com",
	user: "gucinuctgseutr", 
	password: "1b05716bb6382fc7e2ab5aa56ae1693b8fd62ec361f063a7ff2427e1be4047ac", 
	port: 5432,
	ssl: { 
        rejectUnauthorized: false 
    } 
});

const app = express();

app.use(express.json());
//app.use(cors());

app.get('/allSatellites', function (req, res) {
    client.connect(function (err, client, done) {
        if (err) {
            console.log("not able to get a connection " + err) 
            res.status(400).send(err);
        }

        // want to return just 10 of the rows to test to see if it works

        var query = "select * from satellite_population.test;"
        console.log(query);

        
        client.query(query, function (err, result) {
            client.end();
            if (err) {
                res.status(400).send(err)
            }
            res.status(200).send(result.rows);
        });
    });
});


app.listen(process.env.PORT || 3000, () => 
	console.log("Listening on PORT " + process.env.PORT)
);

module.exports = app;