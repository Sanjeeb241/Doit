//
//  ToDoItems.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import Foundation

import RealmSwift

class ToDoItem: Object {
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var key : String = ""
    @Persisted var title: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var note: String = ""
    @Persisted var isRepeat: Bool = false
    @Persisted var location: String = ""
    @Persisted var taskDate: Date?
    @Persisted var time: Date?
    @Persisted var taskPriority: Int = Priority.none.rawValue // Store the raw value as an Int
    @Persisted var isPinned: Bool = false
    @Persisted var categoryName : String = ""
    @Persisted var categoryIcon : String = ""
    @Persisted var categoryId : ObjectId
    @Persisted var isDetails : Bool = false
    @Persisted var timeStamp : String = ""

    var priority: Priority {
        get {
            return Priority(rawValue: taskPriority) ?? .none
        }
        set {
            taskPriority = newValue.rawValue
        }
    }
    
    convenience init(key: String, title: String, isCompleted: Bool, note: String, isRepeat: Bool, location: String, taskDate: Date? = nil, time: Date? = nil, taskPriority: Int, isPinned: Bool, categoryName: String, categoryIcon: String, categoryId: ObjectId, timeStamp: String) {
        self.init()
        self.key = key
        self.title = title
        self.isCompleted = isCompleted
        self.note = note
        self.isRepeat = isRepeat
        self.location = location
        self.taskDate = taskDate
        self.time = time
        self.taskPriority = taskPriority
        self.isPinned = isPinned
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
        self.categoryId = categoryId
        self.timeStamp = timeStamp
    }
}

class Category: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var icon: String = ""

    convenience init(name: String, icon: String) {
        self.init()
        self.name = name
        self.icon = icon
    }
}


