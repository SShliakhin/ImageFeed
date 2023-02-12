//
//  SplashPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashPresenter: ISplashViewOutput {
    weak var view: ISplashViewInput?
    private let interactor: ISplashInteractorInput
    private let router: MainRouting
    
    init(interactor: ISplashInteractorInput, router: MainRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.activityIndicatorStart()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [weak self] in
            guard let self = self else { return }
            self.view?.activityIndicatorStop()

            if self.interactor.hasToken() {
                self.router.navigate(.toMainModule)
            } else {
                let emptyCode = ""
                self.router.navigate(.toAuth(emptyCode))
            }
        }
    }
}

extension SplashPresenter: ISplashInteractorOutput {}
