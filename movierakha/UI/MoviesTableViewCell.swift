//
//  MoviesTableViewCell.swift
//  movierakha
//
//  Created by LIMA 1 on 05/04/22.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    @IBOutlet var imgMovie: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReleaseDate: UILabel!
    @IBOutlet var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        imgMovie.image = nil
    }
    
}
