let https = require('https');
let firebase = require('firebase');
let fs = require('fs')

let config = JSON.parse(fs.readFileSync('config.json', 'utf8'));


firebase.initializeApp({
  serviceAccount: "serviceAccountCredentials.json",
  databaseURL: config.databaseUrl
})

let db = firebase.database();
let ref = db.ref()

ref.once("value", function(snapshot) {
  const numChildren = snapshot.numChildren();
  let counter = 0;
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
  let postData = JSON.stringify({
      "to": "/topics/test",
      "priority" : "high",
      "content_available": true,
      "notification" : {
          "body" : "おしらせ",
          "badge": "1"
      }
  });

  let options = {
      hostname: 'fcm.googleapis.com',
      path: '/fcm/send',
      method: 'POST',
      headers: {
          "Content-Type": "application/json",
          "Authorization" : `key=${config.apiKey}`
      }
  };

  let req = https.request(options, (res) => {
      console.log("OK");
  });

  req.on('error', (e) => {
      console.error(`problem with request: ${e.message}`);
  });

  req.write(postData);
  req.end();
}
