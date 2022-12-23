//
//  ImagesListDataSource.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 23.12.2022.
//

import UIKit

final class ImagesListDataSource: NSObject {
    var pictures: [Picture]
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(pictures: [Picture]) {
        self.pictures = pictures
    }
    
    private func convertToViewModel(_ model: Picture) -> PictureViewModel {
        .init(
            image: UIImage(named: model.asset) ?? .actions,
            dateString: dateFormatter.string(from: model.date),
            isFavorite: model.isFavorite
        )
    }
}

// MARK: - UITableViewDataSource
extension ImagesListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseID, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let picture = pictures[indexPath.row]
        let pictureViewModel = convertToViewModel(picture)
        imageListCell.configure(with: pictureViewModel)
        
        pictures[indexPath.row].height = imageListCell.rowHeight
        
        return cell
    }
}
