// required packages for the API

require('dotenv').config();
const express = require('express');
var pg = require('pg');
const Client = require('pg').Client;
pg.defaults.ssl = true;
const bodyParser = require('body-parser');



console.log(process.env.DATABASE_URL);


const client = new Client({
	connectionString: process.env.DATABASE_URL,
	database: , // please add your own
	host: , // please add your own
	user: , // please add your own
	password: , // please add your own
	port: 5432,
	ssl: { 
        rejectUnauthorized: false 
    } 
});

const pool = new pg.Pool(client);
const app = express();

app.use(express.json());

app.get('/', function(req, res) {
    res.send("Hello and welcome to the satellite API, add a year onto the URL to return the year that you would like to see");
})

// this route will return all of the test satellites
app.get('/allSatellites', function (req, res) {
    pool.connect(function (err, client, done) {
        if (err) {
            console.log("not able to get a connection " + err) 
            res.status(400).send(err);
        }

        // want to return just 10 of the rows to test to see if it works

        var query = "select * from satellite_population.test;"
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
app.get('/:year', function (req, res) {
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


app.listen(process.env.PORT || 3000, () => 
	console.log("Listening on PORT " + process.env.PORT)
);

module.exports = app;
