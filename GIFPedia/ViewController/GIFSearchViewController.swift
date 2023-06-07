//
//  GIFSearchViewController.swift
//  GIFPedia
//
//  Created by USER on 2023/06/05.
//

import UIKit
import SnapKit
import Combine
import GIFPediaService

final class GIFSearchViewController: UIViewController {
    enum Section: Hashable {
        case main
    }

    // MARK: - Subviews

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GIFCell.self, forCellWithReuseIdentifier: GIFCell.identifier)
        return collectionView
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Dependencies

    private let viewModel: GIFSearchViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, GIF>?
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initializers

    init(viewModel: GIFSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Callbacks

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground

        searchController.searchBar.placeholder = "GIF 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self

        navigationItem.searchController = searchController
        navigationItem.title = "GIFPedia"

        dataSource = UICollectionViewDiffableDataSource<Section, GIF>(
            collectionView: collectionView
        ) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFCell.identifier, for: indexPath)
            guard let cell = cell as? GIFCell else { return nil }
            cell.thumbnailUrl = itemIdentifier.thumbnailUrl
            return cell
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }

    private func bind() {
        viewModel.gifsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] gifs in
                self?.applySnapshot(gifs)
            }
            .store(in: &cancellables)

        viewModel.scrollToTopSignalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.setContentOffset(.zero, animated: true)
            }
            .store(in: &cancellables)
    }

    private func applySnapshot(_ gifs: [GIF]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GIF>()
        snapshot.appendSections([.main])
        snapshot.appendItems(gifs)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Extensions

extension GIFSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.didUpdateQuery(text: searchController.searchBar.text)
    }
}

extension GIFSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapSearchButton()
    }
}

extension GIFSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gif = dataSource?.itemIdentifier(for: indexPath) else { return }
        let gifDetailViewController = GIFDetailViewController(gif: gif)
        navigationController?.pushViewController(gifDetailViewController, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.didScrollTo(
            bottomOffset: scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y
        )
    }
}


extension GIFSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.frame.width - 1.0) / 2
        return CGSize(width: width, height: width)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        1.0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        1.0
    }
}
