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
