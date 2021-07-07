// required packages for the API

require('dotenv').config();
const express = require('express');
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

// this route will return all of the test satellites
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