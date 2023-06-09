//
//  AppDelegate.swift
//  wav
//
//  Created by Ilyes Djari on 02/05/2023.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "wav")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Register the device token with Firebase Cloud Messaging
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let userID = getUserIDFromCoreData() else {
            return
        }
        // Store the FCM token in Firestore
        let usersRef = Firestore.firestore().collection("Users")
        let userDocRef = usersRef.document(userID)
        userDocRef.setData(["fcmToken": fcmToken ?? ""], merge: true) { error in
            if let error {
                print("Error storing FCM token in Firestore: \(error)")
            } else {
                print("FCM token stored in Firestore")
            }
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Extract the notification content from the UNNotification object
            _ = notification.request.content
        // Update the notification field in Firestore to NSNull()
        if let userID = getUserIDFromCoreData() {
            let usersRef = Firestore.firestore().collection("Users")
            let userDocRef = usersRef.document(userID)
            userDocRef.updateData(["notification": NSNull()]) { error in
                if let error = error {
                    print("Error updating notification field in Firestore: \(error)")
                    // Handle the error accordingly
                } else {
                    print("Notification field updated successfully in Firestore")
                }
            }
        } else {
            print("User ID not found in Core Data")
        }
        // Customize the presentation options for the notification
        let presentationOptions: UNNotificationPresentationOptions = [.banner, .badge, .sound, .list]
        completionHandler(presentationOptions)
    }
}
