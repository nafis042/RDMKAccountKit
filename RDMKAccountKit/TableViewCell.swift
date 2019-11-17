//
//  BusTableViewCell.swift
//  maps-ios
//
//  Created by Nafis Islam on 8/4/18.
//  Copyright © 2018 Nafis Islam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{

    @IBOutlet var Phone: UILabel!
    
    @IBOutlet var AppName: UILabel!
    @IBOutlet var UserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}


