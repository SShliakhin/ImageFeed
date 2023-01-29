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
    
    init(profileLoader: ProfileLoading) {
        self.profileLoader = profileLoader
    }
    
    func obtainProfile() {
        let profile = profileLoader.loadProfile()
        output?.didObtainProfile(profile: profile)
    }
}
