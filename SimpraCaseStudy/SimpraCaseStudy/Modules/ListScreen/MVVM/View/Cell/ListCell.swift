//
//  ListCell.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import UIKit
import Kingfisher

class ListCell: UITableViewCell {
    
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet private weak var nameValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model : ListCellModel){
        contentImageView.kf.setImage(with: URL.init(string: model.background_image))
        nameValueLabel.text = model.name
    }

}

struct ListCellModel{
    let background_image: String
    let name: String
}



