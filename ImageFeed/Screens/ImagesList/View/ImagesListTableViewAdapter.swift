//
//  ImagesListTableViewAdapter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 03.01.2023.
//

import UIKit

protocol ImagesListTableViewAdapterDelegate: AnyObject {
    func didSelectImage(_ adapter: ImagesListTableViewAdapter, didSelect item: Picture)
}

final class ImagesListTableViewAdapter: NSObject {
    private let tableView: UITableView
    private weak var delegate: ImagesListTableViewAdapterDelegate?
    private let dataSet: ImagesListData
    
    private var didAnimateCells: [IndexPath: Bool] = [:]
    
    init(
        _ tableView: UITableView,
        _ delegate: ImagesListTableViewAdapterDelegate,
        _ data: ImagesListData
    ) {
        self.tableView = tableView
        self.delegate = delegate
        self.dataSet = data
        super.init()
        
        tableView.register(models: [PictureViewModel.self])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func shufflePictures() {
        dataSet.shuffleItems()
        didAnimateCells = [:]
    }
    
    func reloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.performBatchUpdates {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let picture = dataSet.itemAt(index: indexPath.row) else { return UITableViewCell() }
        var model = PictureViewModel.convert(picture)
        model.callback = { [weak self] in
            self?.dataSet.toggleFavorite(at: indexPath.row)
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let picture = dataSet.itemAt(index: indexPath.row) else { return }
        delegate?.didSelectImage(self, didSelect: picture)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let picture = dataSet.itemAt(index: indexPath.row) else { return 0 }
        return PictureViewModel.getCellHeight(by: UIImage(named: picture.image))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard didAnimateCells[indexPath] == nil else { return }
        didAnimateCells[indexPath] = true
        
        cell.transform3DMakeRotation(
            degree: 90,
            x: 0, y: 1, z: 0,
            duration: 0.85,
            delay: 0.1
        )
    }
}
