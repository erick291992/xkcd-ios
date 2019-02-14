//
//  ComicService.swift
//  XKCD
//
//  Created by Erick Manrique on 2/12/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import Foundation

class ComicService {
    
    let networkService = NetworkService()
    
    func getComic(with comicNumber:Int = 1, completion:@escaping(GenericCompletion<Comic>)) {
        let url = Api.xkcdApi.home.url + "\(comicNumber)"
        networkService.requestData(url: url, method: .get, completion: completion)
    }
    
    func getFavoriteComicIds( completion:@escaping(GenericCompletion<Set<String>>)) {
        let url = Api.xkcdCustomApi.favoriteComicIds.url
        networkService.requestData(url: url, method: .get, completion: completion)
    }
    
    func getFavoriteComics( completion:@escaping(GenericCompletion<[Comic]>)) {
        let url = Api.xkcdCustomApi.favoriteComics.url
        networkService.requestData(url: url, method: .get, completion: completion)
    }
    
    
    func addFavorite(with comic:Comic, completion:@escaping(EmptyRequestCompletion)) {
        let url = Api.xkcdCustomApi.addFavorite.url
        var parameters = [String: Any]()
        parameters["month"] = comic.month
        parameters["num"] = comic.num
        parameters["link"] = comic.link
        parameters["year"] = comic.year
        parameters["news"] = comic.news
        parameters["safe_title"] = comic.safe_title
        parameters["transcript"] = comic.transcript
        parameters["alt"] = comic.alt
        parameters["img"] = comic.img
        parameters["title"] = comic.title
        parameters["day"] = comic.day
        parameters["imgRetina"] = comic.imgRetina

        networkService.requestEmpty(url: url, parameters: parameters, method: .post, completion: completion)
    }
    
    func removeFavorite(with comic:Comic, completion:@escaping(EmptyRequestCompletion)) {
        var url = Api.xkcdCustomApi.deleteComic.url
        if let comicNum = comic.num {
            url = url + "/\(comicNum)"
        }

        networkService.requestEmpty(url: url, method: .delete, completion: completion)
    }
    
}
