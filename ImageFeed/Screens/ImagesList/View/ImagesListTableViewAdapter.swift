//
//  ImagesListTableViewAdapter.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 03.01.2023.
//

import UIKit

protocol IImagesListTableViewAdapterDelegate: AnyObject {
    func didSelectImage(_ adapter: IImagesListTableViewAdapter, didSelect item: Picture)
}

protocol IImagesListTableViewAdapter: AnyObject {
    func setupTableView(_ tableView: UITableView)
    func reloadTableView(_ tableView: UITableView)
    func shufflePictures()
    var delegate: IImagesListTableViewAdapterDelegate? { get set }
}

final class ImagesListTableViewAdapter: NSObject {
    
    weak var delegate: IImagesListTableViewAdapterDelegate?
    private let dataSet: ImagesListData
    
    private var didAnimateCells: [IndexPath: Bool] = [:]
    
    init(dataSet: ImagesListData) {
        self.dataSet = dataSet
        super.init()
    }
}

extension ImagesListTableViewAdapter: IImagesListTableViewAdapter {
    func setupTableView(_ tableView: UITableView) {
        tableView.register(models: [PictureViewModel.self])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func reloadTableView(_ tableView: UITableView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.performBatchUpdates {
                tableView.reloadSections([0], with: .automatic)
            }
        }
    }
    
    func shufflePictures() {
        dataSet.shuffleItems()
        didAnimateCells = [:]
    }
}

// MARK: - UITableViewDataSource
extension ImagesListTableViewAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let picture = dataSet.itemAt(index: indexPath.row) else { return UITableViewCell() }
        let model = PictureViewModel(from: picture) { [weak self] in
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
        return Theme.size(kind: .cellHeight(image: UIImage(named: picture.image)))
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
