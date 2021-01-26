//
//  ReminderTableViewCell.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/25.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var thingLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
