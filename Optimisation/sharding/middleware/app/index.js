/*   Dependecies   */ 
const express = require("express");
const {Client, Pool} = require('pg');
const crypto = require('crypto');
const HashRing = require('hashring');

/* Déclaration des besoins */
const app = express();
const hr = new HashRing();

hr.add('5432');
hr.add('5433');
hr.add('5434');


const clients = {
    "5432":new Client({
        "host":"localhost",
        "port":"5432",
        "user":"root",
        "password":"test",
        "database":"shards"
    }),
    "5433":new Client({
        "host":"localhost",
        "port":"5433",
        "user":"root",
        "password":"test",
        "database":"shards"
    }),
    "5434":new Client({
        "host":"localhost",
        "port":"5434",
        "user":"root",
        "password":"test",
        "database":"shards"
    })
}
connect();
async function connect() {
    await clients['5432'].connect();
    await clients['5433'].connect();
    await clients['5434'].connect();
}


app.get('/:brand',async (req,res)=>{
    try {
        const {brand} = req.params;
        
        const hash = crypto.createHash("sha256").update(brand.toLowerCase()).digest("base64");
        const server = hr.get(hash);
        
        const resu = await clients[server].query("SELECT * FROM CARS WHERE brand = $1",[brand.toLowerCase()]);
        
        if (resu.rowsCount == 0){
            res.sendStatus(404);
            return;
        }

        res.send({
                "car":brand,
                "data":resu.rows,
                server
            });

    } catch (err) {
        console.error("Database connection error:", err);
    } 
})

app.post('/',async (req,res)=>{
try{
    const {brand} = req.query
    
    const hash = crypto.createHash("sha256").update(brand.toLowerCase()).digest("base64");

    const server = hr.get(hash);

    await clients[server].query("INSERT INTO CARS (brand) VALUES ($1)",[brand]);

    res.send({brand,hash,server});
}
catch(err){
    console.log(err);
}
});


app.listen(8888,()=>{console.log("Listening to port 8888")});