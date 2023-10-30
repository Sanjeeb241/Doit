//
//  AddCategoryVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 25/10/23.
//

import UIKit
import Realm
import RealmSwift


class AddCategoryVC: UIViewController {
    
    
    @IBOutlet weak var titleBackView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var iconsCV: UICollectionView!
    @IBOutlet weak var iconsCVHeight: NSLayoutConstraint!
    
    
    private let categoryIcons = ["person","briefcase","house","cart","creditcard","heart",
                         "book","airplane","wineglass","gamecontroller","sportscourt","paintbrush","film","music.note","person.2",
                         "calendar","gift","checkmark","bolt.circle","leaf","car","folder",
                         "laptopcomputer","sun.max","figure.child","hammer","flame","trash",
                         "dollarsign.circle","pills","mouth","staroflife","percent","tray","hand.raised","envelope"
    ]
    
    var categoryIconData : [[String: Any]] = []
    var selectedIcon : String = ""
    var isEdit : Bool = false
    var category : Category = Category()
    var categories : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTxt.becomeFirstResponder()
    }
    
    func setupUI() {
        titleBackView.layer.cornerRadius = 10
        iconsCV.layer.cornerRadius = 10
        iconsCV.register(UINib(nibName: COLLECTIONVIEW_CELLS.CategoryIconsCV.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTIONVIEW_CELLS.CategoryIconsCV.rawValue)
        
        for icon in categoryIcons {
            categoryIconData.append(["isSelected": false, "name": icon])
        }
        
        if isEdit {
            title = "Edit Category"
            nameTxt.text = category.name
            // Loop through categoryIconData to find the selected item
            if let selectedItemIndex = categoryIconData.firstIndex(where: { $0["name"] as? String == category.icon }) {
                categoryIconData[selectedItemIndex]["isSelected"] = true
                self.selectedIcon = categoryIconData[selectedItemIndex]["name"] as? String ?? ""
            }
        } else {
            title = "New Category"
        }
        self.view.addTapGesture {
            self.view.endEditing(true)
        }
        updateIconsCVHeight()
    }
    
    
    @IBAction func clickToDone(_ sender: Any) {
        self.view.endEditing(true)
        guard let name = nameTxt.text else { return }
        if name.isEmpty || name.count < 2 {
            titleBackView.showEmptyWarning()
        } else if self.selectedIcon.isEmpty {
            iconsCV.showEmptyWarning()
        } else {
            let category = Category()
            category.name = name
            category.icon = selectedIcon
            
            // A category with the same name or icon already exists
            let alert = UIAlertController(title: "Duplicate Category", message: "A category with the same name or icon already exists.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Get all categories excluding current editing category for check
            let excludedCurrentCategories = categories.filter({ $0.id != self.category.id })
            
            if isEdit {
                if excludedCurrentCategories.first(where: { $0.name == name || $0.icon == selectedIcon }) != nil {
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if (name != self.category.name || selectedIcon != self.category.icon) {
                        category.id = self.category.id
                        DataBaseManager.shared.updateCategory(self.category, newCategory: category)
                    }
                    self.navigationController?.popViewController(animated: true)
                }

            } else {
                if categories.first(where: { $0.name == name || $0.icon == selectedIcon }) != nil {
                    self.present(alert, animated: true, completion: nil)
                } else {
                    DataBaseManager.shared.add(category)
                    self.navigationController?.popViewController(animated: true)
                }
            }

        }
    }
    
}

extension AddCategoryVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.dismissKeyboard()
        return true
    }
}


extension AddCategoryVC : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryIconData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = iconsCV.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEW_CELLS.CategoryIconsCV.rawValue, for: indexPath) as! CategoryIconsCV
        let listInfo = categoryIconData[indexPath.row]
        let iconName = listInfo["name"] as! String
        var iconSelected = listInfo["isSelected"] as! Bool
        self.categoryIconData[indexPath.row]["isSelected"] = false

        
        cell.iconBackView.layer.cornerRadius = cell.iconBackView.frame.height / 2
        cell.iconImage.image = UIImage(systemName: iconName)
        cell.iconImage.tintColor = iconSelected ? .white : .gray
        cell.iconBackView.backgroundColor = iconSelected ? .link : .systemGray4
        
        cell.iconBackView.addTapGesture {
            self.view.endEditing(true)
            iconSelected = !iconSelected
            self.categoryIconData[indexPath.row]["isSelected"] = iconSelected
            self.selectedIcon = iconSelected ? iconName : ""
            self.iconsCV.reloadData()
        }
        return cell
    }
    
    func updateIconsCVHeight() {
        iconsCVHeight.constant = CGFloat.greatestFiniteMagnitude
        iconsCV.reloadData()
        iconsCV.layoutIfNeeded()
        iconsCVHeight.constant = iconsCV.contentSize.height
    }
    
}
