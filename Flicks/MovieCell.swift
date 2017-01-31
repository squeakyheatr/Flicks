//
//  MovieCell.swift
//  Flicks
//
//  Created by Robert Mitchell on 1/30/17.
//  Copyright © 2017 Robert Mitchell. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var OverViewLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
