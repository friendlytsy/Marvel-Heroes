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
    
    // - SOMETHING TO IMPROVE
    func configureCharacterSearchResult(result character: Character) {
        let url = URL(string: (character.thumbnail?.url?.absoluteString)!)
        DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url)
            }
            //DispatchQueue.async(self.itemImage.kf.setImage(with: url))
        itemNameLabel.text = character.name
        itemDescriptionLabel.text = character.description
        
        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
    
    func configureComicSearchResult(result comic: Comic) {
        let url = URL(string: (comic.thumbnail?.url?.absoluteString)!)
        DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url)
            }
            //DispatchQueue.async(self.itemImage.kf.setImage(with: url))
        itemNameLabel.text = comic.title
        itemDescriptionLabel.text = comic.description
        
        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
    
    func configureCharacter(withViewModel viewModel: CharacterDataModel) {

        if let url = URL( string: viewModel.thumbnail ?? "" ) {
            DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url)
            }
            //DispatchQueue.async(self.itemImage.kf.setImage(with: url))
        }
        
        itemNameLabel.text = viewModel.name
        itemDescriptionLabel.text = viewModel.charDescription

        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
    
    func configureComic(withViewModel viewModel: ComicDataModel) {

        if let url = URL( string: viewModel.thumbnail ?? "" ) {
            DispatchQueue.main.async {
                self.itemImage.kf.setImage(with: url)
            }
        }
        itemNameLabel.text = viewModel.title
        itemDescriptionLabel.text = viewModel.comicDescription

        itemNameLabel.font = UIFont.regular
        itemDescriptionLabel.font = UIFont.light
    }
}
