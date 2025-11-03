importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyB4yq-rdrZPjf6-2YhL0tsP53gkP0rD6Gw",
  authDomain: "dhahar-id.firebaseapp.com",
  databaseURL: "https://dhahar-id-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "dhahar-id",
  storageBucket: "dhahar-id.firebasestorage.app",
  messagingSenderId: "1063100312311",
  appId: "1:1063100312311:android:26a5d07ba79c159406c1f2",
  measurementId: "G-1M4JERDWCG"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});