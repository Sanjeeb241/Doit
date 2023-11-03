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
        
        let localDate = getUTCTimeInLocalStringGenral(date: todoItem.taskDate)
        let localTime = getTaskTimeInLocale(time: getTaskTime(time: todoItem.time)) // (date: todoItem.time)
        
        let content = UNMutableNotificationContent()
        content.title = todoItem.title
        content.body = todoItem.note
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "reminder.m4r"))
        
        // Set the time at which you want to trigger the notification
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: todoItem.taskDate ?? Date())
    
        var notificationDateComponents = DateComponents()
        notificationDateComponents.calendar = calendar
        notificationDateComponents.timeZone = .current
        notificationDateComponents.day = dateComponents.day
        notificationDateComponents.hour = Int(getTaskTime(time: todoItem.time).components(separatedBy: ":")[0])
        notificationDateComponents.minute = Int(getTaskTime(time: todoItem.time).components(separatedBy: ":")[1])
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDateComponents, repeats: todoItem.isRepeat)
        
        
        let request = UNNotificationRequest(identifier: todoItem.timeStamp, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    
}
