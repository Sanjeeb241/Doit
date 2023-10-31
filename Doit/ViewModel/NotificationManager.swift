//
//  NotificationManager.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 31/10/23.
//

import Foundation
import UIKit
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    var permissionStatus : Bool = false
    
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { status, error in
            if status {
                self.permissionStatus = true
            } else if let error = error {
                self.permissionStatus = false
                print("There is an error while getting notification permission : \(error.localizedDescription)")
            }
        }
    }
    
    
    func scheduleLocalNotificationsForToDoItems(todoItem: ToDoItem) {
        
        let content = UNMutableNotificationContent()
        let localDate = getUTCDateInLocalString(date: todoItem.taskDate)
        let localTime = getUTCTimeInLocalString(date: todoItem.time)
        content.title = todoItem.title
        content.body = todoItem.note
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "reminder"))
        
        // Set the time at which you want to trigger the notification
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: localDate ?? Date())
        let timeComponents = calendar.dateComponents([.hour, .minute], from: localTime ?? Date())
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: combinedComponents, repeats: todoItem.isRepeat)
        
        let request = UNNotificationRequest(identifier: todoItem.timeStamp, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    
}
