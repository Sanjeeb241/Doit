//
//  DatebaseManager.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 28/10/23.
//

import Foundation
import Realm
import RealmSwift

final class DataBaseManager {
    static let shared  = DataBaseManager()
    
    let realm = try! Realm()
    
    
    func add<T : Object>(_ object : T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("There is an error while adding object : \(error)")
        }
    }
    
    func delete<T : Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print("There is an error while deleting object : \(error)")
        }
        
    }
    
    func updateToDoItem(_ oldItem: ToDoItem, newItem: ToDoItem){
        do {
            try realm.write {
                oldItem.key = newItem.key
                oldItem.title = newItem.title
                oldItem.taskDate = newItem.taskDate
                oldItem.time = newItem.time
                oldItem.isRepeat = newItem.isRepeat
                oldItem.taskPriority = newItem.taskPriority
                oldItem.categoryIcon = newItem.categoryIcon
                oldItem.categoryName = newItem.categoryName
                oldItem.categoryId = newItem.categoryId
                oldItem.isCompleted = newItem.isCompleted
                oldItem.note = newItem.note
            }
        } catch {
            print("There is an error while updating task : \(error)")
        }
    }
    
    func markAsCompleted(_ item : ToDoItem) {
        do {
            try realm.write {
                item.isCompleted = true
                if item.isRepeat {
                    item.isCompleted = false
                    item.taskDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                }
            }
        }catch {
            print("There is an error while completing task : \(error)")
        }
    }
    
    
    
    func updateCategory(_ oldCategory : Category, newCategory: Category){
        do {
            try realm.write {
                oldCategory.name = newCategory.name
                oldCategory.icon = newCategory.icon
            }
        } catch {
            print("There is an error while updating category : \(error)")
        }
    }
    
    func getURL() -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL
    }

}
