//
//  SplashPresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.02.2023.
//

import Foundation

final class SplashPresenter: ISplashViewOutput {
	weak var view: (ISplashViewInput & ILoadWithProgressHUD)?
    private let interactor: ISplashInteractorInput
    private let router: MainRouting
    
    init(interactor: ISplashInteractorInput, router: MainRouting) {
        self.interactor = interactor
        self.router = router
    }
    
	func viewDidLoad() {
		if interactor.hasToken {
			view?.startIndicator()
			interactor.fetchProfile()
		} else {
			let emptyCode = ""
			router.navigate(.toAuth(emptyCode))
		}
	}
}

extension SplashPresenter: ISplashInteractorOutput {
	func didFetchProfileSuccess(profile: ProfileResult) {
		view?.stopIndicator()
		self.router.navigate(.toMainModule(profile))
	}
	
	func didFetchProfileFailure(error: APIError) {
		view?.stopIndicator()
		print(error.description)
	}
}
