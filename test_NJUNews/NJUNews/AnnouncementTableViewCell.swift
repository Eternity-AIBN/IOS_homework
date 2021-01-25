//
//  AnnouncementTableViewCell.swift
//  NJUNews
//
//  Created by CuiZihan on 2020/12/23.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {

    @IBOutlet weak var ContentLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
