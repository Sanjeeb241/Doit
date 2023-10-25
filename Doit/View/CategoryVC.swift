//
//  CategoryVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 25/10/23.
//

import UIKit

protocol CategorySelectionDelegate {
    func didCategorySelect(name: String, icon: String)
}

class CategoryVC: UIViewController {
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var categories: [String: String] = [
        "Home": "house",
        "Work": "briefcase",
        "Personal": "person"
    ]

    
    var delegate: CategorySelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        title = "Categories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickToAdd))
        tblView.register(UINib(nibName: TABLEVIEW_CELLS.ViewAllTVC.rawValue, bundle: nil), forCellReuseIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue)
    }
    
    @objc func clickToAdd(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension CategoryVC: NewCategoryAddDelegate {
    func didAddNewCategory(name: String, icon: String) {
        self.categories[name] = icon
        self.tblView.reloadData()
    }
}


extension CategoryVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELLS.ViewAllTVC.rawValue, for: indexPath) as! ViewAllTVC
        let listInfo = categories.keys.sorted()
        let name = listInfo[indexPath.row]
        
        cell.nameLbl.text = name
        cell.iconImage.image = UIImage(systemName: categories[name] ?? "")
        cell.arrowBtn.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories.keys.sorted()
        let name = category[indexPath.row]
        self.delegate?.didCategorySelect(name: name, icon: categories[name]!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
