//
//  FeedViewControllerCellViewModel.swift
//  XKCD
//
//  Created by Erick Manrique on 2/13/19.
//  Copyright © 2019 homeapps. All rights reserved.
//

import Foundation

class FeedViewControllerCellViewModel {
    
    var comic:Comic?
    var isFavorited: Bool
    
    init() {
        isFavorited = false
    }
}
