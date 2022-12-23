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
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseID)
        
        tableView.reloadData()
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.contentInset =  UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
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

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource.pictures[indexPath.row].height
    }
}
