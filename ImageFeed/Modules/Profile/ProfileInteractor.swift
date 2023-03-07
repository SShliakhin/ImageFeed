//
//  ProfileInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ProfileInteractor: IProfileInteractorInput {
    weak var output: IProfileInteractorOutput?
    private let storage: ITokenStorage
    
    init(storage: ITokenStorage) {
        self.storage = storage
    }
    
    func cleanUpStorage() {
        storage.removeToken()
        output?.didCleanUpStorage()
    }
}
