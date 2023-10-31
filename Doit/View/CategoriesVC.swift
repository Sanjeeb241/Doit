//
//  CategoriesVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 28/10/23.
//

import UIKit
import Realm
import RealmSwift

protocol CategorySelectionDelegate {
    func didCategorySelect(category : Category)
}

class CategoriesVC: UIViewController {
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var categories : Results<Category>!
    var delegate: CategorySelectionDelegate?
    var isFromAddTask : Bool = false
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickToAdd))
        
        // Hide Bottom Plus Button if categories exceeds limit for better cell visibility
        if categories.count >= 10 || isFromAddTask{
            navigationItem.rightBarButtonItem = addButton
            self.addBtn.isHidden = true
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func setupConfig() {
        title = "Categories"
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ViewAllTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue)
        
        categories = DataBaseManager.shared.realm.objects(Category.self).sorted(byKeyPath: "name")
        
        notificationToken = categories.observe { [weak self ](changes: RealmCollectionChange) in
            guard let tableView = self?.tblView else { return }
            self!.view.setupEmptyView(text: "No Category to Show", isShow: self!.categories.isEmpty)
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
        }
    }
    
    @objc func clickToAdd(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        vc.isEdit = false
        vc.categories = self.categories
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func clickToAddCategory(_ sender: Any) {
        self.clickToAdd()
    }
    
    
}


extension CategoriesVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue, for: indexPath) as! ViewAllTVC
        let listInfo = categories[indexPath.row]
        cell.iconImage.image = UIImage(systemName: listInfo.icon)
        cell.nameLbl.text = listInfo.name + " "
        cell.arrowBtn.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromAddTask {
            let name = categories[indexPath.row].name
            let tempCategory = Category()
            tempCategory.name = name
            tempCategory.icon = categories[indexPath.row].icon
            self.delegate?.didCategorySelect(category: tempCategory)
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "") { action, view, completionhandler in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
            vc.category = self.categories[indexPath.row]
            vc.categories = self.categories
            vc.isEdit = true
            self.navigationController?.pushViewController(vc, animated: true)
            completionhandler(true)
        }
        editAction.image = swipeLayout(icon: "pencil", text: "Edit", size: 20)
        editAction.backgroundColor = .link
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionhandler in
            DataBaseManager.shared.delete(self.categories[indexPath.row])
            completionhandler(true)
        }
        
        deleteAction.image = swipeLayout(icon: "trash.fill", text: "Delete", size: 20)
        deleteAction.backgroundColor = .red
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        return swipeConfiguration
    }
    
    
}
