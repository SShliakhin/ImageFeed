//
//  ImagesListTableViewAdapter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 03.01.2023.
//

import UIKit

protocol ImagesListTableViewAdapterDelegate: AnyObject {
    func didSelectImage(_ adapter: ImagesListTableViewAdapter, didSelect item: PictureViewModel)
}

final class ImagesListTableViewAdapter: NSObject {
    private let tableView: UITableView
    private weak var delegate: ImagesListTableViewAdapterDelegate?
    private var pictures: [PictureViewModel]
    
    private var didAnimateCells: [IndexPath: Bool] = [:]
    
    init(
        _ tableView: UITableView,
        _ delegate: ImagesListTableViewAdapterDelegate,
        _ pictures: [PictureViewModel]
    ) {
        self.tableView = tableView
        self.delegate = delegate
        self.pictures = pictures
        super.init()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func getCellHeight(_ indexPath: IndexPath) -> CGFloat {
        guard let height = pictures[safe: indexPath.row]?.height else { return 0.0 }
        return height
    }
    
    func shufflePictures() {
        pictures.shuffle()
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
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseID, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let picture = pictures[indexPath.row]
        imageListCell.configure(with: picture)
        imageListCell.didLikeTaped = { [weak self] like in
            self?.pictures[indexPath.row].isFavorite = like
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListTableViewAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let picture = pictures[indexPath.row]
        delegate?.didSelectImage(self, didSelect: picture)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        getCellHeight(indexPath)
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

