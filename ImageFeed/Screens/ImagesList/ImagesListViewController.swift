//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
        
    private var pictures: [Picture] = []
    private var didAnimateCells: [IndexPath: Bool] = [:]
    
    private lazy var tableView = UITableView()
    
    private lazy var refreshControl = UIRefreshControl()
    private var hasRefreshed = false {
        didSet {
            reloadView()
        }
    }
    
    var onSelect: ((Picture) -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        pictures = MockProvider.pictures
        setupTableView()
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
    }
    
    func setupTableView() {
        tableView.register(models: [PictureViewModel.self])
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
        pictures.shuffle()
        didAnimateCells = [:]
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

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let picture = pictures[safe: indexPath.row] else { return UITableViewCell() }
        let model = PictureViewModel(from: picture) { [weak self] in
            self?.pictures[indexPath.row].isFavorite.toggle()
        }
        
        return tableView.dequeueReusableCell(withModel: model, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let picture = pictures[safe: indexPath.row],
            let onSelect = onSelect
        else {
            return
        }
        onSelect(picture)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let picture = pictures[safe: indexPath.row] else { return 0 }
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
