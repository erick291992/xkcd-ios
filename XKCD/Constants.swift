//
//  Constants.swift
//  XKCD
//
//  Created by Erick Manrique on 2/12/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import Foundation


let appMode = AppMode.Debug

enum AppMode {
    case Debug
    case Release
}

enum Api {
    enum xkcdApi: String {
        case webAddress = "https://xkcd.now.sh"
        case home = "/"
        var url: String {
            return xkcdApi.webAddress.rawValue + self.rawValue
        }
    }
    enum xkcdCustomApi: String {
        case webAddress = "http://localhost:3000/api"
        case favoriteComicIds = "/favoriteComicIds"
        case favoriteComics = "/favoriteComics"
        case addFavorite = "/addFavorite"
        case deleteComic = "/deleteComic"
        var url: String {
            return xkcdCustomApi.webAddress.rawValue + self.rawValue
        }
    }
}
