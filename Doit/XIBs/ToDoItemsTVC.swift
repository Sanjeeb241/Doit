//
//  ToDoItemsTVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit

class ToDoItemsTVC: UITableViewCell {
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var descLbl: UILabel!
    
//    @IBOutlet weak var dateBtn: UIButton!
//    
//    @IBOutlet weak var reminderBtn: UIButton!
//    
//    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var flagImg: UIImageView!
    
    @IBOutlet weak var repeatBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        dateBtn.layer.cornerRadius = 5
//        dateBtn.layer.backgroundColor = UIColor.systemTeal.cgColor
//        reminderBtn.layer.cornerRadius = 5
//        reminderBtn.layer.backgroundColor = UIColor.systemTeal.cgColor
//        locationBtn.layer.cornerRadius = 5
//        locationBtn.layer.backgroundColor = UIColor.systemTeal.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
