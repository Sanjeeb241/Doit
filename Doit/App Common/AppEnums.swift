//
//  AppEnums.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import Foundation


// MARK: Table View Cells
enum TABLEVIEW_CELLS: String {
    case ToDoItemsTVC, ViewAllTVC
}

// MARK: - Collection View Cells
enum COLLECTIONVIEW_CELLS : String {
    case CategoryIconsCV
}

// MARK: Prioity
enum Priority: Int {
    case none = 0
    case normal = 1
    case high = 2
}

enum TASK_KEYS : String {
    case PINNED = "PINNED"
    case TODAY = "TODAY"
    case TOMORROW = "TOMORROW"
    case OVERDUE = "OVERDUE"
    case ALL = "ALL"
}

enum DateComparison : String {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case week
    case other
}

