//
//  HomeVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit
import Realm
import RealmSwift

class HomeVC: UIViewController {
    
    // OUTLETS
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var plusBtn: UIButton!
    
//    private var pinnedTasks : Results<ToDoItems>!
//    private var todayTasks : Results<ToDoItems>!
//    private var tomorrowTasks : Results<ToDoItems>!
//    private var allTasks : Results<ToDoItems>!
//    private var overdueTasks : Results<ToDoItems>!
//    private var todoItems : [[String : Results<ToDoItems>]]!
    
    private var todoItems : Results<ToDoItem>!
    var notificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notificationToken = todoItems.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tblView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.performBatchUpdates({
                    // Always apply updates in the following order: deletions, insertions, then modifications.
                    // Handling insertions before deletions may result in unexpected behavior.
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .left)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                }, completion: { finished in
                    // ...
                })
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        })
    }
    
    func setupConfig(){
        plusBtn.layer.cornerRadius = 25
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue)
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ViewAllTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue)
        todoItems = DataBaseManager.shared.realm.objects(ToDoItem.self)
        
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension HomeVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listInfo = todoItems[indexPath.row]
        
        let categoryCell = tblView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue, for: indexPath) as! ViewAllTVC
        categoryCell.iconImage.isHidden = true
        categoryCell.selectionStyle = .none
        
        let taskCell = tblView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue, for: indexPath) as! ToDoItemsTVC
        taskCell.checkBtn.tag = indexPath.row

//        if var sectionItems = sectionInfo.first?.value {
//            sectionItems.sort {
//                if let firstTaskDate = $0.taskDate, let secondTaskDate = $1.taskDate {
//                    return firstTaskDate < secondTaskDate
//                } else if $0.taskDate != nil {
//                    return true
//                } else if $1.taskDate != nil {
//                    return false
//                } else {
//                    // Handle cases where both items have no taskDate
//                    if let firstTaskTime = $0.time, let secondTaskTime = $1.time {
//                        return firstTaskTime < secondTaskTime
//                    } else if $0.time != nil {
//                        return true
//                    } else if $1.time != nil {
//                        return false
//                    } else {
//                        return $0.priority.rawValue < $1.priority.rawValue
//                    }
//                }
//            }
        
        taskCell.descLbl.isHidden = (listInfo.note == "")
        taskCell.dateBtn.isHidden = (listInfo.taskDate == nil)
        taskCell.timeBtn.isHidden = (listInfo.taskDate == nil || listInfo.time == nil)
        
        if listInfo.time == nil {
            taskCell.repeatBtn.isHidden = true
        } else if listInfo.time != nil {
            taskCell.repeatBtn.isHidden = !listInfo.isRepeat
        }
        
        
        taskCell.titleLbl.text = listInfo.title
        taskCell.descLbl.text = listInfo.note
        
        taskCell.dateBtn.setTitle(getDayOrDateString(from: listInfo.taskDate ?? nil), for: .normal)
        taskCell.timeBtn.setTitle(getTaskTime(time: listInfo.time ?? nil), for: .normal)
        
        taskCell.flagBtn.tintColor = (listInfo.priority == .high || listInfo.isPinned) ? .red : .link
        taskCell.categoryBtn.setImage(UIImage(systemName: listInfo.categoryIcon), for: .normal)
        
        if listInfo.isPinned {
            taskCell.flagBtn.isHidden = false
            taskCell.flagBtn.setImage(UIImage(systemName: "pin.fill"), for: .normal)
            
        } else {
            switch listInfo.priority {
            case .none:
                taskCell.flagBtn.isHidden = true
            case .normal:
                taskCell.flagBtn.setImage(UIImage(systemName: "flag"), for: .normal)
                break
            case .high:
                taskCell.flagBtn.setImage(UIImage(systemName: "flag.fill"), for: .normal)
                break
            }
        }
        
        taskCell.repeatBtn.setImage(listInfo.isRepeat ? UIImage(systemName: "repeat") : UIImage(systemName: "repeat"), for: .normal)
        taskCell.checkBtn.setImage(listInfo.isCompleted ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle"), for: .normal)
        
        taskCell.checkBtn.addTapGesture {
            listInfo.isCompleted = !listInfo.isCompleted
            self.tblView.reloadData()
        }
        
        taskCell.selectionStyle = .none
        return taskCell
        
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        // Define the action
//        
//        let sectionInfo = todoItems[indexPath.section]
//        let listInfo = sectionInfo.first?.value[indexPath.row]
//        let itemsCount = sectionInfo.first?.value.count
//        
//        if let itemsCount = itemsCount {
//            if itemsCount > 5 && (indexPath.row == itemsCount - 1){
//                return nil
//            } else {
//                let pinAction = UIContextualAction(style: .normal, title: "Pin") { (action, view, completionHandler) in
//                    if let listInfo = listInfo {
//                        listInfo.isPinned = !listInfo.isPinned
//                        if listInfo.isPinned {
//                            if let pinnedIndex = self.todoItems.firstIndex(where: { $0.keys.contains(TASK_KEYS.PINNED.rawValue) }) {
//                                
//                                // Add the item to the .PINNED section.
//                                self.todoItems[pinnedIndex][TASK_KEYS.PINNED.rawValue]?.append(listInfo)
//                                
//                                // Remove the item from the current category section.
//                                switch sectionInfo.keys.first {
//                                case TASK_KEYS.TODAY.rawValue :
//                                    self.todoItems[indexPath.section][TASK_KEYS.TODAY.rawValue]?.remove(at: indexPath.row)
//                                    break
//                                case TASK_KEYS.TOMORROW.rawValue :
//                                    self.todoItems[indexPath.section][TASK_KEYS.TOMORROW.rawValue]?.remove(at: indexPath.row)
//                                    break
//                                case TASK_KEYS.OVERDUE.rawValue :
//                                    self.todoItems[indexPath.section][TASK_KEYS.OVERDUE.rawValue]?.remove(at: indexPath.row)
//                                case TASK_KEYS.ALL.rawValue:
//                                    self.todoItems[indexPath.section][TASK_KEYS.ALL.rawValue]?.remove(at: indexPath.row)
//                                    break
//                                default:
//                                    break
//                                }
//                                
//                            }
//                            
//                        } else {
//                            
//                            if let pinnedIndex = self.todoItems.firstIndex(where: { $0.keys.contains(TASK_KEYS.PINNED.rawValue) }) {
//                                
//                                // Determine the destination section based on taskDate.
//                                var destinationSection: TASK_KEYS
//                                switch checkDate(listInfo.taskDate) {
//                                case .today:
//                                    destinationSection = .TODAY
//                                case .tomorrow:
//                                    destinationSection = .TOMORROW
//                                case .other, .week:
//                                    destinationSection = .ALL
//                                }
//                                
//                                if let index = self.todoItems.firstIndex(where: { $0.keys.contains(destinationSection.rawValue) }) {
//                                    // Key already exists, append the new task to the array
//                                    self.todoItems[index][destinationSection.rawValue]?.append(listInfo)
//                                } else {
//                                    // Key doesn't exist, create a new dictionary
//                                    self.todoItems.append([destinationSection.rawValue: [listInfo]])
//                                }
//                                
//                                // Remove the item from the .PINNED section.
//                                self.todoItems[pinnedIndex][TASK_KEYS.PINNED.rawValue]?.remove(at: indexPath.row)
//                                
//                            }
//                            
//                            
//                        }
//                    }
//                    
//                    
//                    self.view.animate()
//                    self.tblView.reloadData()
//                    completionHandler(true)
//                }
//                let pinActionText = listInfo!.isPinned ? "Unpin" : "Pin"
//                let iconName = listInfo!.isPinned ?  "pin.slash.fill" : "pin.fill"
//                
//                // Customize the appearance of the delete action (optional)
//                pinAction.image = swipeLayout(icon: iconName, text: pinActionText, size: 20)
//                pinAction.backgroundColor = .link
//                
//                // Create a configuration with the delete action
//                let swipeConfiguration = UISwipeActionsConfiguration(actions: [pinAction])
//                swipeConfiguration.performsFirstActionWithFullSwipe = false
//                
//                return swipeConfiguration
//            }
//            
//            
//        }
//        return UISwipeActionsConfiguration()
//        
//    }
    
}

