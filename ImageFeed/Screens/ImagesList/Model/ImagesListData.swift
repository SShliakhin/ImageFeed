//
//  ImagesListData.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 04.01.2023.
//

import Foundation

final class ImagesListData {
    private var items: [Picture] = []
    var count: Int {
        items.count
    }
    
    init() {
        items = Picture.pictures
    }
    
    func toggleFavorite(at index: Int) {
        guard let _ = items[safe: index] else { return }
        items[index].isFavorite.toggle()
    }
    
    func itemAt(index: Int) -> Picture? {
        items[safe: index]
    }
    
    func shuffleItems() {
        items.shuffle()
    }
}
