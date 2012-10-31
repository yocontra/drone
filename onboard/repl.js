arDrone = require('ar-drone');
client  = arDrone.createClient({ip:'localhost'});
client.createRepl();