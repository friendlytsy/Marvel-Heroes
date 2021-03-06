//
//  CharacterTableViewCell.swift
//  Marvel Heroes
//
//  Created by Alexander Tsygankov on 09.09.2021.
//

import UIKit
import Kingfisher

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
    
    func configureCharacter(withViewModel viewModel: CharacterDataModel) {

        if let url = URL( string: viewModel.thumbnail ?? "" ) {
            DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url, placeholder: UIImage(systemName: "person"))
            }
        }

        itemNameLabel.text = viewModel.name
        if viewModel.charDescription == "" {
            itemDescriptionLabel.text = "Sorry, there is no description here :("
        } else {
            itemDescriptionLabel.text = viewModel.charDescription
        }

        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
    
    func configureComic(withViewModel viewModel: ComicDataModel) {

        if let url = URL( string: viewModel.thumbnail ?? "" ) {
            DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url, placeholder: UIImage(systemName: "book"))
            }
        }
        itemNameLabel.text = viewModel.title
        if viewModel.comicDescription == "" {
            itemDescriptionLabel.text = "Sorry, there is no description here :("
        } else {
            itemDescriptionLabel.text = viewModel.comicDescription
        }

        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
}
