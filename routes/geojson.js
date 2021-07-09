var express = require('express');
var pg = require('pg');
var geoJSON = require('express').Router();
var fs = require('fs');

var config = {
    	connectionString: process.env.DATABASE_URL,
    	database: "ddcd35b2sfr4q9", // please add your own
    	host: "ec2-54-155-87-214.eu-west-1.compute.amazonaws.com", // please add your own
    	user: "cmlrcklxedxpfi", // please add your own
    	password: "f16f4201d97ec6dba2e4410d2575c3dc4b783d8281a93b231bb1f16f1952bda0", // please add your own
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

        var query = "select * from satellite_population.fsp limit 10;"
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
geoJSON.get('/:year', function (req, res) {
    pool.connect(function (err, client, done) {
        if (err) {
            console.log("not able to get a connection " + err) 
            res.status(400).send(err);
        }

        var year = req.params.year;

        // want to return just 10 of the rows to test to see if it works

        var query = "select * from satellite_population.test";
        query = query + " where launch_date >= '"+year+"-01-01' AND  launch_date <=  '"+year+"-12-31';";

        
        client.query(query, function (err, result) {
            done();
            if (err) {
                res.status(400).send(err)
            }
            res.status(200).send(result.rows);
        });
    });
});


module.exports = geoJSON;
