//
//  SampleCell.swift
//  Hemocytometer Cell Counter
//
//  Created by Bryan Zhang on 8/2/16.
//  Copyright © 2016 Bryan Zhang. All rights reserved.
//

import UIKit

class SampleCell: UITableViewCell {

    @IBOutlet weak var CellName: UILabel!
    
    @IBOutlet weak var CellCount: UILabel!
    
    @IBOutlet weak var NumCells: UILabel!
    
    @IBOutlet weak var CellVolume: UILabel!
    
    @IBOutlet weak var Date: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
