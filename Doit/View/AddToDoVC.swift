//
//  AddToDoVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 24/10/23.
//

import UIKit

class AddToDoVC: UIViewController {
    
    
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var noteTxtView: UITextView!
    @IBOutlet weak var noteTxtViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dateTimeBackView: UIView!
    @IBOutlet weak var dateHeaderView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var dateSwitchBtn: UISwitch!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var timeHeaderView: UIView!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var timeSwitchBtn: UISwitch!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var repeatSwitchBtn: UISwitch!
    
    @IBOutlet weak var priorityBackView: UIView!
    @IBOutlet weak var priorityBtn: UIButton!
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryIcon: UIImageView!
    
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    private var isDateView : Bool = false // Show/Hide date view
    private var isTimeView : Bool = false // Show/Hide time view
    private var categories : [String] = []
    
    private var priority : Priority = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTxt.becomeFirstResponder()
    }
    
    func setupUI() {
        self.title = "Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickToDone))
        addBtn.addTarget(self, action: #selector(clickToDone), for: .touchUpInside)
        self.titleBackView.layer.cornerRadius = 10
        self.dateTimeBackView.layer.cornerRadius = 10
        self.priorityBackView.layer.cornerRadius = 10
        self.datePickerView.isHidden = true
        timePickerView.isHidden = true
        repeatView.isHidden = true
        timeLbl.isHidden = true
        dateLbl.isHidden = true
        self.dateHeaderView.addTapGesture {
            if !self.dateSwitchBtn.isOn {
                return
            }else {
                self.isDateView = !self.isDateView
                self.datePickerView.isHidden =  self.isDateView
                self.isTimeView = false
            }

        }
        
        self.timeHeaderView.addTapGesture {
            if !self.timeSwitchBtn.isOn {
                return
            } else {
                self.isTimeView = !self.isTimeView
                self.timePickerView.isHidden = self.isTimeView
                self.isDateView = false
            }

        }
        setupPriorityInteractionMenu()
        addNotePlaceholder()
    }
    
    @IBAction func selectDateTime(_ sender: UISwitch) {
        self.view.endEditing(true) // Pop down the keyboard
        if sender == dateSwitchBtn {
            isDateView = !isDateView
            isTimeView = false
        } else {
            isTimeView = !isTimeView
            isDateView = false
        }
        dateSwitchBtn.setOn(isDateView, animated: true)
        timeSwitchBtn.setOn(isTimeView, animated: true)
        self.dateLbl.isHidden = !self.isDateView
        self.datePickerView.isHidden = !self.isDateView
        self.timeLbl.isHidden = !self.isTimeView
        self.timePickerView.isHidden = !self.isTimeView
        self.repeatView.isHidden = !self.isTimeView

    }
    
    
    @objc func clickToDone() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddCategory(_ sender: Any) {
        self.view.endEditing(true)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension AddToDoVC : UITextFieldDelegate, UITextViewDelegate, CategorySelectionDelegate {
    
    func didCategorySelect(name: String, icon: String) {
        self.categoryBtn.setTitle(name, for: .normal)
        self.categoryIcon.image = UIImage(systemName: icon)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        removePlaceHolder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTxtView.text.isEmpty {
            addNotePlaceholder()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        noteTxtView.sizeToFit()
        noteTxtViewHeight.constant = noteTxtView.contentSize.height
    }
    
    // Placeholder text for Note Text View
    func addNotePlaceholder() {
        let label = UILabel()
        label.text = "Note"
        label.textColor = .placeholderText
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left  // Set horizontal alignment to leading
        
        label.numberOfLines = 1
        label.tag = 909

        self.noteTxtView.addSubview(label)
        label.centerYAnchor.constraint(equalTo: noteTxtView.centerYAnchor).isActive = true
        
        // Add a UITapGestureRecognizer to the noteTxtView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        noteTxtView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        noteTxtView.becomeFirstResponder() // When the user taps on noteTxtView, show the keyboard
    }
    
    func removePlaceHolder() {
        if let label = noteTxtView.viewWithTag(909) as? UILabel {
            label.removeFromSuperview()
        }
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension AddToDoVC {
        
    func setupPriorityInteractionMenu(){
        let noneAction = UIAction(title: "None", state: (self.priority == .none) ? .on : .off) { _ in
            self.priorityBtn.setTitle("None", for: .normal)
            self.priority = .none
            self.setupPriorityInteractionMenu()
        }
        
        let lowAction = UIAction(title: "Low", image: UIImage(systemName: "flag.fill")?.withTintColor(.blue, renderingMode: .alwaysOriginal), state: (self.priority == .low) ? .on : .off) { _ in
            self.priorityBtn.setTitle("Low", for: .normal)
            self.priority = .low
            self.setupPriorityInteractionMenu()
        }
        
        let mediumAction = UIAction(title: "Medium", image: UIImage(systemName: "flag.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal), state: (self.priority == .medium) ? .on : .off) { _ in
            self.priorityBtn.setTitle("Medium", for: .normal)
            self.priority = .medium
            self.setupPriorityInteractionMenu()
        }
        
        let highAction = UIAction(title: "High", image: UIImage(systemName: "flag.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), state: (self.priority == .high) ? .on : .off) { _ in
            self.priorityBtn.setTitle("High", for: .normal)
            self.priority = .high
            self.setupPriorityInteractionMenu()
        }
        
        
        
        // create group of menus for separator. Make sure displayInline is selected, other wise it will create sub menu
        let priorityOptions = UIMenu(title: "",options: .displayInline, children: [lowAction, mediumAction, highAction])
        
        
        // place as per separator
        let menuItems = [noneAction, priorityOptions]
        let priorityOptionsMenu = UIMenu(title: "", children: menuItems)
        
        if #available(iOS 17.0, *) {
            self.priorityBtn.menu = priorityOptionsMenu
            self.priorityBtn.showsMenuAsPrimaryAction = true
            
        }
        
    }
    
}
