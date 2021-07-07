// setting up a database connection
var express = require('express');
var pg = require('pg');
var geoJSON = require('express').Router();
var fs = require('fs');

// var configtext = ""+fs.readFileSync("postGISConnection.js");

// // now convert the configuration file into the correct format 
//  var configarray = configtext.split(",");
//  var config = {};
//  for (var i = 0; i < configarray.length; i++) {
//  var split = configarray[i].split(':');
//  config[split[0].trim()] = split[1].trim();
//  }
//  var pool = new pg.Pool(config);
//  console.log(config);



// const bodyParser = require('body-parser');

// geoJSON.use(bodyParser.urlencoded({ extended: true }));

// geoJSON.get('/allSatellites', function (req, res) {
//     pool.connect(function (err, client, done) {
//         if (err) {
//             console.log("not able to get a connection " + err) 
//             res.status(400).send(err);
//         }

//         // want to return just 10 of the rows to test to see if it works

//         var query = "select * from satellite_population.test limit 10;"
//         console.log(query);

        
//         client.query(query, function (err, result) {
//             done();
//             if (err) {
//                 res.status(400).send(err)
//             }
//             res.status(200).send(result.rows);
//         });
//     });
// });

// geoJSON.get('/geoJSONUserID/:user_id', function (req, res) {
// 	pool.connect(function(err, client, done) {
// 		if (err) {
// 			console.log("not able to get connection " + err);
// 			res.status(400).send(err);
// 		}

// 		// get the user's id
// 		// var user_id = req.body.user_id;
// 		// console.log('user id in req is ' + user_id);
// 		var user_id = req.params.user_id;

// 		// get the colnames
// 		var colnames = "id, question_title, question_text, answer_1,";
//         colnames = colnames + "answer_2, answer_3, answer_4, user_id, correct_answer";
//         console.log("colnames are " + colnames);

// 		// note that query needs to be a single string with no line breaks so built it up bit by bit
//          var querystring = " SELECT 'FeatureCollection' As type, array_to_json(array_agg(f)) As features  FROM ";
//           querystring += "(SELECT 'Feature' As type     , ST_AsGeoJSON(lg.location)::json As geometry, ";
//           querystring += "row_to_json((SELECT l FROM (SELECT "+colnames + " ) As l      )) As properties";
//           querystring += "   FROM cege0043.quizquestions As lg ";
//          querystring += " where user_id = $1 limit 100  ) As f ";

// 		console.log(user_id);
// 		client.query(querystring, [user_id], function (err, result) {
// 			done();
// 			if(err){
// 				res.status(400).send(err)
// 			}
// 			res.status(200).send(result.rows);
// 		});
// 	});
// });




// module.exports = geoJSON;

