//
//  ProfileInteractor.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class ProfileInteractor: IProfileInteractorInput {
    weak var output: IProfileInteractorOutput?
    private let profileLoader: ProfileLoading
    private let storage: ITokenStorage
    
    init(profileLoader: ProfileLoading, storage: ITokenStorage) {
        self.profileLoader = profileLoader
        self.storage = storage
    }
    
    func obtainProfile() {
        let profile = profileLoader.loadProfile()
        output?.didObtainProfile(profile: profile)
    }
    func cleanUpStorage() {
        storage.removeToken()
        output?.didCleanUpStorage()
    }
}
