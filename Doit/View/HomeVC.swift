//
//  HomeVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit

class HomeVC: UIViewController {
    
    // OUTLETS
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var plusBtn: UIButton!

    private var todoItems : [[String : [ToDoItems]]] = [["TODAY'S TASKS":
                                                        [ToDoItems(title: "Work", isCompleted: false, note: "Work is painful", isRepeat: false, location: "Bhadrak, India", date: "22/10/2024", time: "10:00", isReminder: false, priority: .high, isPinned: true),
                                                         ToDoItems(title: "Take a nap", isCompleted: false, note: "A short nap increase sleep health", isRepeat: false, location: "Dhamara, India", date: "23/10/2024", time: "13:00", isReminder: false, priority: .medium, isPinned: false),
                                                         ToDoItems(title: "Eat", isCompleted: false, note: "Eat is painful", isRepeat: false, location: "Gangtok, India", date: "24/10/2024", time: "14:00", isReminder: false, priority: .low, isPinned: false),
                                                         ToDoItems(title: "Sleep", isCompleted: false, note: "", isRepeat: false, location: "Gangtok, India", date: "25/10/2024", time: "15:00", isReminder: false, priority: .high, isPinned: false)]],
                                                      ["TOMORROW'S TASKS":
                                                        [ToDoItems(title: "Work", isCompleted: false, note: "Work is painful", isRepeat: false, location: "Bhadrak, India", date: "22/10/2024", time: "10:00", isReminder: false, priority: .high, isPinned: true),
                                                         ToDoItems(title: "Take a nap", isCompleted: false, note: "A short nap increase sleep health", isRepeat: false, location: "Dhamara, India", date: "23/10/2024", time: "13:00", isReminder: false, priority: .medium, isPinned: false),
                                                         ToDoItems(title: "Eat", isCompleted: false, note: "Eat is painful", isRepeat: false, location: "Gangtok, India", date: "24/10/2024", time: "14:00", isReminder: false, priority: .low, isPinned: false),
                                                         ToDoItems(title: "Sleep", isCompleted: false, note: "", isRepeat: false, location: "Gangtok, India", date: "25/10/2024", time: "15:00", isReminder: false, priority: .high, isPinned: false)]],
                                                      ["CATEGORIES":
                                                        [ToDoItems(title: "Work", isCompleted: false, note: "Work is painful", isRepeat: false, location: "Bhadrak, India", date: "22/10/2024", time: "10:00", isReminder: false, priority: .high, isPinned: true),
                                                         ToDoItems(title: "Take a nap", isCompleted: false, note: "A short nap increase sleep health", isRepeat: false, location: "Dhamara, India", date: "23/10/2024", time: "13:00", isReminder: false, priority: .medium, isPinned: false),
                                                         ToDoItems(title: "Eat", isCompleted: false, note: "Eat is painful", isRepeat: false, location: "Gangtok, India", date: "24/10/2024", time: "14:00", isReminder: false, priority: .low, isPinned: false),
                                                         ToDoItems(title: "Sleep", isCompleted: false, note: "", isRepeat: false, location: "Gangtok, India", date: "25/10/2024", time: "15:00", isReminder: false, priority: .high, isPinned: false)]]
                                                      
    ]
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    func setupConfig(){
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue)
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ViewAllTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue)
        plusBtn.layer.cornerRadius = 25
    }
}


extension HomeVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return todoItems[section].keys.first
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = todoItems[section]
        return sectionInfo.first?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row <= 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ToDoItemsTVC.rawValue, for: indexPath) as! ToDoItemsTVC
            if let listInfo = todoItems[indexPath.section].first?.value[indexPath.row] {
                
                cell.titleLbl.text = listInfo.title
                cell.descLbl.isHidden = listInfo.note == ""
                cell.descLbl.text = listInfo.note
        //        cell.dateBtn.setTitle(todoItems[indexPath.row].date, for: .normal)
        //        cell.reminderBtn.setTitle(todoItems[indexPath.row].time, for: .normal)
        //        cell.locationBtn.setTitle(todoItems[indexPath.row].location, for: .normal)
                switch listInfo.priority {
                case .low:
                    cell.flagImg.tintColor = UIColor.blue
                    break
                case .medium:
                    cell.flagImg.tintColor = UIColor.orange
                    break
                case .high:
                    cell.flagImg.tintColor = UIColor.red
                    break
                }
                cell.repeatBtn.setImage(listInfo.isRepeat ? UIImage(systemName: "repeat") : UIImage(systemName: "repeat"), for: .normal)
                cell.checkBtn.setImage(listInfo.isCompleted ? UIImage(systemName: "checkmark.fill") : UIImage(systemName: "circle"), for: .normal)
                cell.selectionStyle = .none
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue, for: indexPath) as! ViewAllTVC
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
}

