//
//  AddCategoryVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 25/10/23.
//

import UIKit


protocol NewCategoryAddDelegate {
    func didAddNewCategory(name: String, icon: String)
}
class AddCategoryVC: UIViewController {
    
    
    @IBOutlet weak var titleBackView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var iconsCV: UICollectionView!
    @IBOutlet weak var iconsCVHeight: NSLayoutConstraint!
    
    
    private let categoryIcons = ["person","briefcase","house","cart","bag","creditcard","heart",
                         "book","airplane","wineglass","gamecontroller","sportscourt","paintbrush","film","music.note","book","person.2","calendar","gift","checkmark","bolt.circle","leaf","car","folder",
                         "laptopcomputer","paintpalette","sun.max","figure.child","hammer","flame","trash","dollarsign.square",
                         "gift","dollarsign.circle","pills","mouth","staroflife","percent","tray","hand.raised","envelope",
                         "calendar.badge.clock"
    ]
    
    var categoryIconData : [[String: Any]] = []
    var selectedIcon : String = ""
    var delegate: NewCategoryAddDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTxt.becomeFirstResponder()
    }
    func setupUI() {
        title = "New Category"
        titleBackView.layer.cornerRadius = 10
        iconsCV.layer.cornerRadius = 10
        iconsCV.register(UINib(nibName: COLLECTIONVIEW_CELLS.CategoryIconsCV.rawValue, bundle: nil), forCellWithReuseIdentifier: COLLECTIONVIEW_CELLS.CategoryIconsCV.rawValue)
        
        for icon in categoryIcons {
            categoryIconData.append(["isSelected": false, "name": icon])
        }
        
        // Add border width, will need for Empty warning animation
        titleBackView.layer.borderWidth = 1
        iconsCV.layer.borderWidth = 1
        updateIconsCVHeight()
    }
    
    
    @IBAction func clickToDone(_ sender: Any) {
        self.view.endEditing(true)
        guard let name = nameTxt.text else { return }
        if name.isEmpty {
            addEmptyWarning(isName: true)
        } else if self.selectedIcon.isEmpty {
            addEmptyWarning(isName: false)
        } else {
            self.delegate?.didAddNewCategory(name: name, icon: selectedIcon)
            self.navigationController?.popViewController(animated: true)
        }
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

extension AddCategoryVC {
    func addEmptyWarning(isName: Bool) {
        
        // Create a CABasicAnimation for the border color
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = UIColor.red.cgColor
        borderColorAnimation.toValue = isName ? titleBackView.layer.borderColor : iconsCV.layer.borderColor
        borderColorAnimation.duration = 0.25
        borderColorAnimation.autoreverses = true
        borderColorAnimation.repeatCount = 2 // Blink thrice
        borderColorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        // Apply the animation to the view's layer
        if isName {
            titleBackView.layer.add(borderColorAnimation, forKey: "borderColorAnimation")
        }else{
            iconsCV.layer.add(borderColorAnimation, forKey: "borderColorAnimation")
        }
    }

}
