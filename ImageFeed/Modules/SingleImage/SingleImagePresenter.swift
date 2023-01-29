//
//  SingleImagePresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import Foundation

final class SingleImagePresenter: ISingleImageViewOutput {
    weak var view: ISingleImageViewInput?
    private let interactor: ISingleImageInteractorInput
    private let router: ISingleImageRouter
    
    init(interactor: ISingleImageInteractorInput, router: ISingleImageRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showImage()
    }
    
    func didTapBack() {
        router.exit()
    }
}

extension SingleImagePresenter: ISingleImageInteractorOutput {
}
