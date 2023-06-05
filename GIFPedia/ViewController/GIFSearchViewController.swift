//
//  GIFSearchViewController.swift
//  GIFPedia
//
//  Created by USER on 2023/06/05.
//

import UIKit
import SnapKit

final class GIFSearchViewController: UIViewController {

    // MARK: - Dependencies

    private let decoder = JSONDecoder()

    // MARK: - Subviews

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GIFCell.self, forCellWithReuseIdentifier: GIFCell.identifier)
        return collectionView
    }()

    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Properties

    private let apiKey: String = "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"
    private var giphyEntities: [GiphyEntity] = [] {
        didSet { reload() }
    }
    private var searchText: String { searchController.searchBar.text ?? "" }

    // MARK: - Lifecycle Callbacks

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground

        searchController.searchBar.placeholder = "GIF 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.title = "GIFPedia"

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func search(query: String) {
        guard let url = URL(string: "https://api.giphy.com/v1/gifs/search") else { return }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "100"),
            URLQueryItem(name: "pageOffset", value: "0"),
            URLQueryItem(name: "rating", value: "g"),
            URLQueryItem(name: "lang", value: "en")
        ]

        guard let queryUrl = urlComponents?.url else { return }
        var urlRequest = URLRequest(url: queryUrl)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self,
                  let data,
                  let result = try? self.decoder.decode(GiphySearchResult.self, from: data) else { return }
            self.giphyEntities = result.data
        }.resume()
    }

    private func reload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Extensions

extension GIFSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(query: searchText)
        collectionView.setContentOffset(.zero, animated: true)
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

extension GIFSearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        giphyEntities.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIFCell.identifier, for: indexPath)
        guard let cell = cell as? GIFCell else { return cell }
        let giphyEntity = giphyEntities[indexPath.item].images
        cell.thumbnailUrl = giphyEntity.thumbnail
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let giphyEntity = giphyEntities[indexPath.item]
        let detailViewController = GIFDetailViewController(giphyEntity: giphyEntity)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
