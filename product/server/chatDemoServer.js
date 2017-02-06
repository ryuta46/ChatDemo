var https = require('https');
var firebase = require('firebase');
var fs = require('fs')

var config = JSON.parse(fs.readFileSync('config.json', 'utf8'));


firebase.initializeApp({
  serviceAccount: "serviceAccountCredentials.json",
  databaseURL: config.databaseUrl
})

var db = firebase.database();
var ref = db.ref()

ref.once("value", function(snapshot) {
  const numChildren = snapshot.numChildren();
  var counter = 0;
  ref.on("child_added", function(addedSnapshot) {
      if( counter < numChildren ){
          // skip data before the server launched.
          counter++;
          return;
      }
      // notifies new message.
      sendNotification();
  });
});


function sendNotification(){
  var postData = JSON.stringify({
      "to": "/topics/test",
      "priority" : "high",
      "content_available": true,
      "notification" : {
          "body" : "おしらせ",
          "badge": "1"
      }
  });

  var options = {
      hostname: 'fcm.googleapis.com',
      path: '/fcm/send',
      method: 'POST',
      headers: {
          "Content-Type": "application/json",
          "Authorization" : "key=" + config.apiKey
      }
  };

  var req = https.request(options, (res) => {
      console.log("OK");
  });

  req.on('error', (e) => {
      console.error("problem with request: " + e.message);
  });

  req.write(postData);
  req.end();
}
