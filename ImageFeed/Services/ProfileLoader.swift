//
//  ProfileLoader.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 28.01.2023.
//

import Foundation

protocol ProfileLoading {
    func loadProfile() -> Profile
}

struct ProfileLoader: ProfileLoading {
    func loadProfile() -> Profile {
        MockProvider.profile
    }
}
