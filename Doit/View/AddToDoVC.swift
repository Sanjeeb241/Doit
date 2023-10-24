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
    @IBOutlet weak var priorityBackView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    private var isDateView : Bool = false // Show/Hide date view
    private var isTimeView : Bool = false // Show/Hide time view

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
        
        addNotePlaceholder()
    }
    
    @IBAction func selectDateTime(_ sender: UISwitch) {
        if sender == dateSwitchBtn {
            isDateView = !isDateView
            isTimeView = false
        } else {
            isTimeView = !isTimeView
            isDateView = false
        }
        dateSwitchBtn.setOn(isDateView, animated: true)
        timeSwitchBtn.setOn(isTimeView, animated: true)
        self.datePickerView.isHidden = !self.isDateView
        self.timePickerView.isHidden = !self.isTimeView

    }
    
    
    @objc func clickToDone() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

}

extension AddToDoVC : UITextFieldDelegate, UITextViewDelegate {
    
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
    
    func addNotePlaceholder() {
        let label = UILabel()
        label.text = "Notes"
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
