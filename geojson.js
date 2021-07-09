var express = require('express');
var pg = require('pg');
var geoJSON = require('express').Router();
var fs = require('fs');

var config = {
    	connectionString: process.env.DATABASE_URL,
    	database: "d6v2ejscl1vh5e", // please add your own
    	host: "ec2-34-254-69-72.eu-west-1.compute.amazonaws.com", // please add your own
    	user: "gucinuctgseutr", // please add your own
    	password: "1b05716bb6382fc7e2ab5aa56ae1693b8fd62ec361f063a7ff2427e1be4047ac", // please add your own
    	port: 5432,
    	ssl: { 
            rejectUnauthorized: false 
        } 
    }

var pool = new pg.Pool(config);
console.log(config);

const bodyParser = require('body-parser');

geoJSON.use(bodyParser.urlencoded({ extended: true }));

geoJSON.get('/allSatellites', function (req, res) {
    pool.connect(function (err, client, done) {
        if (err) {
            console.log("not able to get a connection " + err) 
            res.status(400).send(err);
        }

        // want to return just 10 of the rows to test to see if it works

        var query = "select * from satellite_population.test limit 10;"
        console.log(query);

        
        client.query(query, function (err, result) {
            done();
            if (err) {
                res.status(400).send(err)
            }
            res.status(200).send(result.rows);
        });
    });
});


// create a route that should take the year, and will return the year 
// geoJSON.get('/:year', function (req, res) {
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


module.exports = geoJSON;
