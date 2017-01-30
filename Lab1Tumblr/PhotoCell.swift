//
//  PhotoCell.swift
//  Lab1Tumblr
//
//  Created by Sarah Gemperle on 1/19/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AFNetworking



class PhotoCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    var imgURL: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
