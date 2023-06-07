/* eslint-disable eol-last */
/* eslint-disable indent */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnFieldChange =
    functions.firestore.document("Users/{userID}")
    .onUpdate((change, context) => {
        const newData = change.after.data();
        const previousData = change.before.data();

        // Check if the "notification" field has changed to a string value
        if (newData.notification &&
            typeof newData.notification === "string" &&
            previousData.notification !== newData.notification) {
            const userID = context.params.userID;

            // Retrieve the user's FCM token from Firestore
            const userRef = admin.firestore().collection("Users").doc(userID);
            return userRef.get()
                .then((userDoc) => {
                    const fcmToken = userDoc.data().fcmToken;
                    // Construct the notification message
                    const message = {
                        token: fcmToken,
                        notification: {
                            title: "WAV",
                            body: newData.notification,
                        },
                    };

                    // Send the notification using the Firebase Admin SDK
                    return admin.messaging().send(message);
                })
                .catch((error) => {
                    console.error("Error retrieving FCM token:", error);
                });
        }

        return null;
    });