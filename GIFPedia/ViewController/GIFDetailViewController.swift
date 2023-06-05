//
//  GIFDetailViewController.swift
//  GIFPedia
//
//  Created by USER on 2023/06/05.
//

import UIKit
import SnapKit
import Nuke
import FLAnimatedImage

final class GIFDetailViewController: UIViewController {

    // MARK: - Subviews

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()

    // MARK: - Properties

    private let giphyEntity: GiphyEntity

    // MARK: - Initializers

    init(giphyEntity: GiphyEntity) {
        self.giphyEntity = giphyEntity
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Callbacks

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .systemBackground

        navigationItem.title = giphyEntity.title

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        if let url = giphyEntity.images.original {
            Nuke.loadImage(with: url, into: imageView)
        }
    }
}
