//
//  dataCellWithLabelsButton.swift
//  DemoSPH
//
//  Created by Vaishu on 12/8/19.
//  Copyright © 2019 Vaishu. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {

    @IBOutlet var titleText: UILabel!
    @IBOutlet var detailText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)

        // Configure the view for the selected state
        
    }
    
}
