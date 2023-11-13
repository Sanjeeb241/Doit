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
    @IBOutlet weak var categoryView: UIView!
    

    @IBOutlet weak var addBtn: UIButton!
    
    
    private var isDateView : Bool = false // Show/Hide date view
    private var isTimeView : Bool = false // Show/Hide time view
    
    private var taskDate : Date? = nil
    private var taskTime : Date? = nil
    private var isRepeat : Bool = false
    private var priority : Priority = .none
    private var category : Category = Category()
    private var isPinned : Bool = false
    var todoItem : ToDoItem = ToDoItem()
    
    var isEdit : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTxt.becomeFirstResponder()
    }
    
    
    func setupUI() {
        
        titleBackView.layer.cornerRadius = 10
        dateTimeBackView.layer.cornerRadius = 10
        priorityBackView.layer.cornerRadius = 10
        repeatView.layer.cornerRadius = 10
        
        noteTxtView.inputAccessoryView = view.addDismissButton(view: noteTxtView)
        
        datePickerView.minimumDate = Date()
        timePickerView.minimumDate = Date()
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        timeLbl.text = getTaskTime(time: taskTime)
        timePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        timePickerView.minuteInterval = 05


        dateHeaderView.addTapGesture {
            self.view.dismissKeyboard()
            if !self.dateSwitchBtn.isOn {
                return // Do nothing when Switch Button is off
            }else {
                self.datePickerView.isHidden = !self.datePickerView.isHidden
                self.timePickerView.isHidden = true
            }
            self.view.animate()

        }
        
        timeHeaderView.addTapGesture {
            self.view.dismissKeyboard()
            if !self.timeSwitchBtn.isOn {
                return
            } else {
                self.timePickerView.isHidden = !self.timePickerView.isHidden
                self.datePickerView.isHidden = true
            }
            self.view.animate()

        }
        
        if isEdit {
            title = "Edit Details"
            titleTxt.text = todoItem.title
            noteTxtView.text = todoItem.note
            if let taskDate = todoItem.taskDate {
                self.taskDate = taskDate
                datePickerView.date = taskDate
                dateLbl.isHidden = false
            }

            if let time = todoItem.time {
                taskTime = todoItem.time
                timeLbl.text = getTaskTime(time: todoItem.time)
                timePickerView.date = time
                timeSwitchBtn.setOn(true, animated: true)
                repeatView.isHidden = !todoItem.isRepeat
                repeatSwitchBtn.setOn(todoItem.isRepeat, animated: true)
            }
            priority = todoItem.priority
            priorityBtn.setTitle(getPriorityString(priority: todoItem.priority), for: .normal)
            category.id = todoItem.categoryId
            category.icon = todoItem.categoryIcon
            category.name = todoItem.categoryName
            categoryIcon.image = UIImage(systemName: todoItem.categoryIcon)
            categoryBtn.setTitle(todoItem.categoryName, for: .normal)
            
        } else {
            title = "Details"
            dateLbl.isHidden = true
            timeLbl.isHidden = true
            timePickerView.isHidden = true
            repeatView.isHidden = true
        }

        timePickerView.isHidden = true
        
        dateSwitchBtn.setOn(true, animated: true)
        isDateView = dateSwitchBtn.isOn
        selectDateTime(dateSwitchBtn)
        datePickerView.isHidden = true
        
        setupPriorityInteractionMenu()
        if !todoItem.note.isEmpty && isEdit {
            removePlaceHolder()
        } else {
            addNotePlaceholder()
        }
    }
    
    @objc func datePickerValueChanged(_ datePicker: UIDatePicker) {
        if datePicker == datePickerView {
            switch checkDate(datePicker.date) {
            case .today:
                self.dateLbl.text = "Today"
                self.timePickerView.minimumDate = Date()
                break
            case .tomorrow:
                self.dateLbl.text = "Tomorrow"
                self.timePickerView.minimumDate = nil
                break
            case .other, .week:
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                self.dateLbl.text = dateFormatter.string(from: datePicker.date)
                self.timePickerView.minimumDate = nil
                break
            }
            self.taskDate = datePicker.date
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            self.timeLbl.text = dateFormatter.string(from: timePickerView.date)
            self.taskTime = timePickerView.date
        }
    }

    
    @IBAction func selectDateTime(_ sender: UISwitch) {
        view.dismissKeyboard()
        self.setupDateTimeView(sender)
    }
    
    func setupDateTimeView(_ sender: UISwitch) {
        
        if sender == dateSwitchBtn {
            isDateView = dateSwitchBtn.isOn
            dateSwitchBtn.setOn(isDateView, animated: true)
            if !dateSwitchBtn.isOn {
                timeSwitchBtn.setOn(false, animated: true)
            }
            datePickerView.isHidden = !dateSwitchBtn.isOn
            timePickerView.isHidden = true
            taskDate = datePickerView.date
        } else {
            isTimeView = timeSwitchBtn.isOn
            timeSwitchBtn.setOn(isTimeView, animated: true)
            if timeSwitchBtn.isOn {
                dateSwitchBtn.setOn(true, animated: true)
            }
            timePickerView.isHidden = !timeSwitchBtn.isOn
            self.datePickerView.isHidden = true
            taskTime = timePickerView.date
            timeLbl.text = getTaskTime(time: taskTime)
        }
        
        self.dateLbl.isHidden = !dateSwitchBtn.isOn
        self.timeLbl.isHidden = !timeSwitchBtn.isOn
        self.repeatView.isHidden = !timeSwitchBtn.isOn
        self.view.animate()
    }
    
    @IBAction func clickToRepeat(_ sender: Any) {
        view.dismissKeyboard()
        isRepeat = !isRepeat
    }
    
    
    @IBAction func clickToAddCategory(_ sender: Any) {
        view.dismissKeyboard()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
        vc.delegate = self
        vc.isFromAddTask = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAdd(_ sender: Any) {
        view.dismissKeyboard()
        
        guard let name = titleTxt.text else { return }
        guard let note = noteTxtView.text else { return }
        
        let isRepeat = isRepeat
        let priority = priority
        let category = category
        
        
        if (name.isEmpty || name.count < 2){
            titleBackView.showEmptyWarning()
        } else if taskDate == nil {
            dateHeaderView.showEmptyWarning()
        } else if category.name.isEmpty {
            categoryView.showEmptyWarning()
        }  else {
            var key = TASK_KEYS.ALL
            switch checkDate(taskDate) {
            case .today:
                key = .TODAY
                break
            case .tomorrow:
                key = .TOMORROW
                break
            default:
                key = .ALL
                break
            }
            
            let timestamp = String(format: "%.0f", Date().timeIntervalSince1970)
            
            let todoItem = ToDoItem()
            todoItem.key = key.rawValue
            todoItem.title = name
            todoItem.isCompleted = false
            todoItem.note = note
            todoItem.isRepeat = isRepeat
            todoItem.taskDate = taskDate // getUTCDateInLocalString(date: taskDate) ?? taskDate
            todoItem.time = taskTime // getUTCTimeInLocalStringGenral(date: taskTime) ?? taskTime
            todoItem.priority = priority
            todoItem.isPinned = isPinned
            todoItem.categoryId = category.id
            todoItem.categoryIcon = category.icon
            todoItem.categoryName = category.name
            todoItem.timeStamp = timestamp
            
            if isEdit {
                DataBaseManager.shared.updateToDoItem(self.todoItem, newItem: todoItem)
                self.navigationController?.popViewController(animated: true)
            } else {
                DataBaseManager.shared.add(todoItem)
                if NotificationManager.shared.permissionStatus {
                    NotificationManager.shared.scheduleLocalNotificationsForToDoItems(todoItem: todoItem)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Notification for this Task can't be schedule as app does not have persmission.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                self.navigationController?.popViewController(animated: true)
            }
            

        }
        
        
    }
    

}

extension AddToDoVC : UITextFieldDelegate, UITextViewDelegate, CategorySelectionDelegate {
    
    func didCategorySelect(category : Category) {
        self.category = category
        self.categoryBtn.setTitle(category.name, for: .normal)
        self.categoryIcon.image = UIImage(systemName: category.icon)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.dismissKeyboard()
        return true
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
        
        noteTxtView.addTapGesture {
            self.noteTxtView.becomeFirstResponder()
            self.removePlaceHolder()
        }
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
        
        let normalAction = UIAction(title: "Normal", image: UIImage(systemName: "flag"), state: (self.priority == .normal) ? .on : .off) { _ in
            self.priorityBtn.setTitle("Normal", for: .normal)
            self.priority = .normal
            self.setupPriorityInteractionMenu()
        }
        
        let highAction = UIAction(title: "High", image: UIImage(systemName: "flag.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), state: (self.priority == .high) ? .on : .off) { _ in
            self.priorityBtn.setTitle("High", for: .normal)
            self.priority = .high
            self.setupPriorityInteractionMenu()
        }
        
        
        // create group of menus for separator. Make sure displayInline is selected, other wise it will create sub menu
        let priorityOptions = UIMenu(title: "",options: .displayInline, children: [normalAction, highAction])
        
        
        // place as per separator
        let menuItems = [noneAction, priorityOptions]
        let priorityOptionsMenu = UIMenu(title: "", children: menuItems)
        
        if #available(iOS 17.0, *) {
            self.priorityBtn.menu = priorityOptionsMenu
            self.priorityBtn.showsMenuAsPrimaryAction = true
            
        }
        
    }
    
}
