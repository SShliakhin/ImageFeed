//
//  SplashInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashInteractor: ISplashInteractorInput {
    weak var output: ISplashInteractorOutput?
    private let storage: ITokenStorage
    
    init(storage: ITokenStorage) {
        self.storage = storage
    }
    
    func hasToken() -> Bool {
        storage.token != nil
    }
}
