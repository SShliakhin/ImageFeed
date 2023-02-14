//
//  SingleImagePresenter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 29.01.2023.
//

import UIKit

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
        guard let vc = view as? UIViewController else { return }
        if vc.modalPresentationStyle == .fullScreen {
            vc.dismiss(animated: true)
            return
        }
        if let navigationVC = vc.navigationController {
            navigationVC.popViewController(animated: true)
        } else {
            router.navigate(.toMainModule)
        }
    }
}

extension SingleImagePresenter: ISingleImageInteractorOutput {
}
