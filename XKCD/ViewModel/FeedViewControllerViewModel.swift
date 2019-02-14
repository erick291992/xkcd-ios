//
//  FeedViewControllerViewModel.swift
//  XKCD
//
//  Created by Erick Manrique on 2/12/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import Foundation

class FeedViewControllerViewModel {
    
    let comicService:ComicService
    
    var comics: [Comic]
    var favoriteComicIds: Set<String>
    var finishedRetrievingComic: (()->())?
    
    init() {
        self.comicService = ComicService()
        self.comics = [Comic]()
        self.favoriteComicIds = Set<String>()
    }
    
    func changeFavoriteComicStatus(to isFavorite:Bool , at position:Int) {
        let comic = comics[position]
        guard let comicId = comic.num else { return }
        if isFavorite {
            comicService.addFavorite(with: comic) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(_, headers: _):
                    strongSelf.favoriteComicIds.insert("\(comicId)")
                    strongSelf.finishedRetrievingComic?()
                case .failure(_):
                    print("failed to favorite")
                }
            }
        } else {
            comicService.removeFavorite(with: comic) { [weak self] (result) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(_, headers: _):
                    strongSelf.favoriteComicIds.remove("\(comicId)")
                    strongSelf.finishedRetrievingComic?()
                case .failure(_):
                    print("failed to favorite")
                }
            }
        }
        
    }
    
    func getComic(for rowNumber:Int = 0) {
        let comicNumber = rowNumber + 1
        
        comicService.getComic(with: comicNumber) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let comic, _, headers: _):
                strongSelf.comics.append(comic)
                strongSelf.finishedRetrievingComic?()
            case .failure(_):
                print("failed tp get comic")
            }
        }
    }
    
    func requestData() {
        
        let comicNumber:Int = 1
        
        var requestedComic: Comic?
        var requestedFavoriteComicIds: Set<String>?
        var requestedReason: FailureReason?
        var errorOccured = false
        
        let groupDispatch = DispatchGroup()
        
        groupDispatch.enter()
        comicService.getComic(with: comicNumber) { [weak self] (result) in
            guard self != nil else {
                errorOccured = true
                groupDispatch.leave()
                return
            }
            
            switch result {
            case .success(let comic, _, headers: _):
                requestedComic = comic
            case .failure(let reason):
                if requestedReason == nil {
                    requestedReason = reason
                }
                errorOccured = true
            }
            groupDispatch.leave()
        }
        
        groupDispatch.enter()
        comicService.getFavoriteComicIds { [weak self] (result) in
            guard self != nil else {
                errorOccured = true
                groupDispatch.leave()
                return
            }
            
            switch result {
            case .success(let comicIds, _, _):
                print(comicIds)
                requestedFavoriteComicIds = comicIds
            case .failure(let reason):
                if requestedReason == nil {
                    requestedReason = reason
                }
                errorOccured = true
            }
            groupDispatch.leave()
        }
        
        
        groupDispatch.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            
            if errorOccured {
//                guard let reason = requestedReason else {
//                    let alert = self.generataAlert(alertTitle: "", statusCodeMessage: "")
//                    self.onShowError?(alert)
//                    return
//                }
//                print("failed", requestedReason)
            } else {
                guard let comic = requestedComic , let comicIds = requestedFavoriteComicIds else {
                    return
                }
                strongSelf.comics.append(comic)
                strongSelf.favoriteComicIds = comicIds
                strongSelf.finishedRetrievingComic?()
            }
            
        }
        
        
    }
}
