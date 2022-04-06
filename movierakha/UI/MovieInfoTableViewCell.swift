//
//  MovieInfoTableViewCell.swift
//  movierakha
//
//  Created by LIMA 1 on 06/04/22.
//

import UIKit

class MovieInfoTableViewCell: UITableViewCell {
    @IBOutlet var imgMovie: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnFav: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
