//
//  customCell.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/03/28.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit

class customCell: UITableViewCell {
    
    
    @IBOutlet weak var mylabel: UILabel!
    
    @IBOutlet weak var myitem: UIImageView!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // 枠線の色と角丸
        self.myitem.layer.borderColor = UIColor.blue.cgColor
        self.myitem.layer.borderWidth = 1
        
        self.myitem.layer.cornerRadius = 50
        
        self.myitem.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
