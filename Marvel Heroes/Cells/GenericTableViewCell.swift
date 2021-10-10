//
//  CharacterTableViewCell.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit

class GenericTableViewCell: UITableViewCell {

    @IBOutlet private weak var itemImage: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withViewModel viewModel: CharacterModel) {
        itemImage.image = viewModel.characterImage
        itemNameLabel.text = viewModel.characterName
        itemDescriptionLabel.text = viewModel.characterDescription
        
        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
}
