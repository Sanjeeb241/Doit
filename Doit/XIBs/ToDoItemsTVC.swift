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
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var timeBtn : UIButton!
    @IBOutlet weak var flagBtn: UIButton!
    @IBOutlet weak var categoryBtn : UIButton!
    @IBOutlet weak var repeatBtn: UIButton!
    @IBOutlet weak var noteHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateBtn.layer.cornerRadius = 5
        timeBtn.layer.cornerRadius = 5
        repeatBtn.layer.cornerRadius = 5
        
        dateBtn.backgroundColor = .systemGray4.withAlphaComponent(0.7)
        timeBtn.backgroundColor = .systemGray4.withAlphaComponent(0.7)
        repeatBtn.backgroundColor = .systemGray4.withAlphaComponent(0.7)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
