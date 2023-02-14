//
//  ProfileViewModel.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.01.2023.
//

import UIKit

struct ProfileViewModel {
    let image: UIImage?
    let fullName: String
    let loginName: String
    let description: String
}

extension ProfileViewModel {
    init(from model: Profile) {
        image = UIImage(named: model.image)
        fullName = model.fullName
        loginName = model.loginName
        description = model.description
    }
}
