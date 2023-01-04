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
    private let data: ImagesListData
    
    private var didAnimateCells: [IndexPath: Bool] = [:]
    
    init(
        _ tableView: UITableView,
        _ delegate: ImagesListTableViewAdapterDelegate,
        _ data: ImagesListData
    ) {
        self.tableView = tableView
        self.delegate = delegate
        self.data = data
        super.init()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func shufflePictures() {
        data.shuffleItems()
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
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseID, for: indexPath)
        guard
            let imageListCell = cell as? ImagesListCell,
            let picture = data.itemAt(index: indexPath.row)
        else {
            return UITableViewCell()
        }
        
        let pictureViewModel = PictureViewModel.convert(picture)
        imageListCell.configure(with: pictureViewModel)
        imageListCell.didLikeTaped = { [weak self] in
            self?.data.toggleFavorite(at: indexPath.row)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let picture = data.itemAt(index: indexPath.row) else { return }
        delegate?.didSelectImage(self, didSelect: picture)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let picture = data.itemAt(index: indexPath.row) else { return 0 }
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
