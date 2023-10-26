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
    var priority: Priority = .none
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

struct Category : Codable {
    var id : String
    var name, icon: String
    
    init(id: String, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}
