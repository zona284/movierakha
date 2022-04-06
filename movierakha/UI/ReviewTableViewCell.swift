//
//  ReviewTableViewCell.swift
//  movierakha
//
//  Created by LIMA 1 on 06/04/22.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var lblContent: UILabel!
    @IBOutlet var lblPostDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
