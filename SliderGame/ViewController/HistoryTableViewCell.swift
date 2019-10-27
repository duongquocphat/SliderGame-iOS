//
//  HistoryTableViewCell.swift
//  SliderGame
//
//  Created by Shakutara on 10/23/19.
//  Copyright © 2019 Shakutara. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    //MARK: Initialization
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
