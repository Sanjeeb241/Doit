//
//  ViewAllTVC.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 24/10/23.
//

import UIKit

class ViewAllTVC: UITableViewCell {
    
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
