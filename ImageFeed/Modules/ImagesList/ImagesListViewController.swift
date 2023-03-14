//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 21.12.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {
	private let presenter: IImagesListViewOutput
	private let adapter: ImagesListTableViewAdapter
	
	// MARK: - UI
	private lazy var tableView = UITableView()
	
	private lazy var refreshControl = UIRefreshControl()
	private var hasRefreshed = false {
		didSet {
			reloadView()
		}
	}
	
	// MARK: - Init
	init(presenter: ImagesListPresenter, adapter: ImagesListTableViewAdapter) {
		self.presenter = presenter
		self.adapter = adapter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
		applyStyle()
		applyLayout()
		
		presenter.viewDidLoad()
	}
}

// MARK: - IImagesListViewInput

extension ImagesListViewController: IImagesListViewInput {
	func reloadTableView() {
		tableView.reloadData()
	}
}

// MARK: - ILoadWithProgressHUD

extension ImagesListViewController: ILoadWithProgressHUD {}

// MARK: - Actions
private extension ImagesListViewController {
	@objc func refreshContent() {
		presenter.didRefreshContent()
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

// MARK: - UIComponent
private extension ImagesListViewController {
	private func setup() {
		setupTableView()
		
		refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
	}
	
	func setupTableView() {
		tableView.register(models: [PhotoViewModel.self])
		
		tableView.dataSource = adapter
		tableView.delegate = adapter
		
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
