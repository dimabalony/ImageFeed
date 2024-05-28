//
//  ImageFeedViewController.swift
//  ImageFeed
//
//  Created by Dmitry Bolonikov on 9.02.24.
//

import UIKit

protocol ImageFeedView: AnyObject {
    func append(_ items: [ImageFeedItem])
    func reload(_ items: [ImageFeedItem])
}

class ImageFeedViewController: UIViewController {
    
    let presenter: ImageFeedPresenterProtocol
    
    private let tableView = UITableView()
    private lazy var dataSource = makeDataSource()
    
    init(presenter: ImageFeedPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        makeConstraints()

        view.backgroundColor = .white
        
        presenter.viewDidLoad()
    }
}

// MARK: Layout

private extension ImageFeedViewController {
    func setupView() {
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 300
        
        var snapshot = NSDiffableDataSourceSnapshot<ImageFeedSection, ImageFeedItem>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot)
        
        tableView.register(ImageFeedTableViewCell.self, forCellReuseIdentifier: ImageFeedTableViewCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func makeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: ImageFeedView

extension ImageFeedViewController: ImageFeedView {
    func append(_ items: [ImageFeedItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func reload(_ items: [ImageFeedItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self else { return }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: UITableViewDataSource

private extension ImageFeedViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<ImageFeedSection, ImageFeedItem> {
        UITableViewDiffableDataSource(tableView: tableView, cellProvider: makeCellProvider)
    }
    
    func makeCellProvider(tableView: UITableView, indexPath: IndexPath, model: ImageFeedItem) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageFeedTableViewCell.reuseIdentifier, for: indexPath)
        
        guard let imageFeedCell = cell as? ImageFeedTableViewCell else { return cell }
        imageFeedCell.setupModel(model, preferredWidth: view.bounds.width)
        return imageFeedCell
    }
}

// MARK: UITableViewDelegate

extension ImageFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UIRefreshControl handling

extension ImageFeedViewController {
    @objc func handleRefreshControl() {
        presenter.refreshItems()
    }
}

extension ImageFeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map(\.row)
        presenter.prefetchItems(at: indexes)
    }
}
