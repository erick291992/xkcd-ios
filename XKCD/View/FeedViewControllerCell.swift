//
//  FeedViewControllerCell.swift
//  XKCD
//
//  Created by Erick Manrique on 2/9/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import UIKit
import Kingfisher


protocol FeedViewControllerCellDelegate: class {
    func favoriteComic(isFavorite: Bool, cell:FeedViewControllerCell)
}

class FeedViewControllerCell: UICollectionViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    let viewModel = FeedViewControllerCellViewModel()

    weak var delegate: FeedViewControllerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func bindViewModel() {
        guard let image = viewModel.comic?.img else { return }
        let url = URL(string: image)
        comicImageView.kf.setImage(with: url)
        
        if let month = viewModel.comic?.month, let day = viewModel.comic?.day, let year = viewModel.comic?.year, let num = viewModel.comic?.num {
            infoLabel.text = "#\(num) • \(month)/\(day)/\(year)"
        }
        titleLabel.text = viewModel.comic?.safe_title
        altLabel.text = viewModel.comic?.alt
        
        if viewModel.isFavorited {
            favoriteButton.alpha = 1.0
        } else {
            favoriteButton.alpha = 0.25
        }
        
    }

    
    @IBAction func favoriteComic(_ sender: UIButton) {
//        guard let comicId = viewModel.comic?.num else { return }
        
        if viewModel.isFavorited {
            favoriteButton.alpha = 0.25
            viewModel.isFavorited = false
        } else {
            favoriteButton.alpha = 1.0
            viewModel.isFavorited = true
        }
        delegate?.favoriteComic(isFavorite: viewModel.isFavorited, cell: self)
    }
    
    
}
