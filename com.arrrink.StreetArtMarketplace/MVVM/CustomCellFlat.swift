//
//  CustomCellFlat.swift
//  com.arrrink.StreetArtMarketplace
//
//  Created by Арина Нефёдова on 07.12.2020.
//  Copyright © 2020 Арина Нефёдова. All rights reserved.
//

import UIKit

class CustomCellFlat: UITableViewCell {


    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var cessionLabel: UILabel!
    
    @IBOutlet weak var typeViewBG: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var cessionViewBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowColor = UIColor.gray.cgColor
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize(width: 5, height: 2)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.cornerRadius = 10
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
