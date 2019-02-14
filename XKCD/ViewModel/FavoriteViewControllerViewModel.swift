//
//  FavoriteViewControllerViewModel.swift
//  XKCD
//
//  Created by Erick Manrique on 2/14/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import Foundation

class FavoriteViewControllerViewModel {
    
    let comicService:ComicService
    var comics: [Comic]
    var finishedRetrievingComics: (()->())?
    
    
    init() {
        self.comicService = ComicService()
        self.comics = [Comic]()
    }
    func getFavoriteComics() {
        
        comicService.getFavoriteComics { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let comics, _, _):
                strongSelf.comics = comics
                strongSelf.finishedRetrievingComics?()
            case .failure(_):
                print("failed tp get favorite comics")
            }
        }
    }
    
}
