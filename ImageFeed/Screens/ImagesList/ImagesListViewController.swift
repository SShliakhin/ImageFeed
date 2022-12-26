//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
        
    private let tableView = UITableView()
    private let dataSource: ImagesListDataSource = .init(pictures: Picture.pictures)
    
    private let refreshControl = UIRefreshControl()
    private var hasRefreshed = false {
        didSet {
            reloadView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        applyStyle()
        applyLayout()
    }
}

private extension ImagesListViewController {
    private func setup() {
        setupTableView()
        setupRefreshControl()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseID)
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = Theme.color(usage: .ypWhite)
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.contentInset = Theme.contentInset(kind: .table)
    }
    
    func applyLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Actions
private extension ImagesListViewController {
    @objc func refreshContent() {
        dataSource.shufflePictures()
        hasRefreshed.toggle()
    }
    
    func reloadView() {
        tableView.refreshControl?.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.tableView.performBatchUpdates {
                self.tableView.reloadSections([0], with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource.getCellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * .pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
        cell.layer.transform = rotationTransform

        UIView.animate(
            withDuration: 0.85,
            delay: 0.1,
            options: .curveEaseInOut,
            animations: {
                cell.layer.transform = CATransform3DIdentity
            }
        )
    }
}
