//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
        
    private let tableView = UITableView()
    private var adapter: ImagesListTableViewAdapter?
    
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
        adapter = ImagesListTableViewAdapter(
            tableView,
            self,
            ImagesListData()
        )
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func applyStyle() {
        view.backgroundColor = Theme.color(usage: .ypBlack)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.contentInset = Theme.contentInset(kind: .table)
        
        refreshControl.tintColor = Theme.color(usage: .ypWhite)
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
        adapter?.shufflePictures()
        hasRefreshed.toggle()
    }
    
    func reloadView() {
        tableView.refreshControl?.endRefreshing()
        adapter?.reloadView()
    }
}

// MARK: - ImagesListTableViewAdapterDelegate
extension ImagesListViewController: ImagesListTableViewAdapterDelegate {
    func didSelectImage(_ adapter: ImagesListTableViewAdapter, didSelect item: Picture) {
        print(item)
    }
}
