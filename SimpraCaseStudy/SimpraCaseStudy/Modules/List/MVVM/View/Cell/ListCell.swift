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
    
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var nameValueLabel: UILabel!
    @IBOutlet private weak var ratingTitleLabel: UILabel!
    @IBOutlet private weak var ratingValueLabel: UILabel!
    @IBOutlet private weak var releasedTitleLabel: UILabel!
    @IBOutlet private weak var releasedValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with model : ListCellModel){
        contentImageView.kf.setImage(with: URL.init(string: model.background_image))
        nameValueLabel.text = model.name
        ratingValueLabel.text = String(describing: model.rating)
        releasedValueLabel.text = model.released
    }

}

private extension ListCell{
    private func setupUI(){
        nameTitleLabel.text = "Name"
        ratingTitleLabel.text = "Rating"
        releasedTitleLabel.text = "Released"
    }
}

struct ListCellModel{
    let background_image: String
    let name: String
    let rating: Double
    let released: String
}


