//
//  HomeVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit
import Realm
import RealmSwift
import UserNotifications

class HomeVC: UIViewController {
    
    // OUTLETS
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var plusBtn: UIButton!
    
    private var todoItems : Results<ToDoItem>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    func setupConfig(){
        plusBtn.layer.cornerRadius = 25
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue)
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ViewAllTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue)

        todoItems = DataBaseManager.shared.realm.objects(ToDoItem.self)
        
        notificationToken = todoItems.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tblView else { return }
            self!.view.setupEmptyView(text: "Relax! Nothing to do.", isShow: self!.todoItems.isEmpty)
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
        
        NotificationManager.shared.requestAuthorization()

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
            
            UIView.animate(withDuration: 0.35) {
                DataBaseManager.shared.markAsCompleted(listInfo)
                taskCell.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }completion: { _ in
                taskCell.contentView.transform = .identity
            }
            
            if !listInfo.isRepeat {
                NotificationManager.shared.center.removePendingNotificationRequests(withIdentifiers: [listInfo.timeStamp])
                DataBaseManager.shared.delete(listInfo)
                
            }
            
        }
        
        taskCell.descLbl.numberOfLines = 0
        taskCell.noteHeight.constant = taskCell.descLbl.getHeight()
        
        taskCell.selectionStyle = .none
        return taskCell
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let listInfo = todoItems[indexPath.row]
        let vc : AddToDoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddToDoVC") as! AddToDoVC
        
        let editAction = UIContextualAction(style: .normal, title: "") { action, view, completionHandler in
            vc.isEdit = true
            vc.todoItem = listInfo
            self.navigationController?.pushViewController(vc, animated: true)
            completionHandler(true)
        }
        
        editAction.image = swipeLayout(icon: "pencil", text: "Edit", size: 20)
        editAction.backgroundColor = .link
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let listInfo = todoItems[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            NotificationManager.shared.center.removePendingNotificationRequests(withIdentifiers: [listInfo.timeStamp])
            DataBaseManager.shared.delete(listInfo)
            completionHandler(true)
        }
        
        deleteAction.image = swipeLayout(icon: "trash.fill", text: "Delete", size: 20)
        deleteAction.backgroundColor = .red
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
}
