//
//  ToDoItems.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import Foundation

final class ToDoItems : NSObject {
    var title : String
    var isCompleted : Bool
    var note : String
    var isRepeat : Bool
    var location : String
    var date : String
    var time : String
    var isReminder : Bool
    var priority: Priority = .low
    var isPinned: Bool
    
    init(title: String, isCompleted: Bool, note: String, isRepeat: Bool, location: String, date: String, time: String, isReminder: Bool, priority: Priority, isPinned: Bool) {
        self.title = title
        self.isCompleted = isCompleted
        self.note = note
        self.isRepeat = isRepeat
        self.location = location
        self.date = date
        self.time = time
        self.isReminder = isReminder
        self.priority = priority
        self.isPinned = isPinned
    }
}


enum Priority: Int {
    case low = 0
    case medium = 1
    case high = 2
}
