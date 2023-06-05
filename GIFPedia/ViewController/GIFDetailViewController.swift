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
import GIFPediaService

final class GIFDetailViewController: UIViewController {

    // MARK: - Subviews

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()

    // MARK: - Properties

    private let gif: GIF

    // MARK: - Initializers

    init(gif: GIF) {
        self.gif = gif
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

        navigationItem.title = gif.title

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        Nuke.loadImage(with: gif.originalUrl, into: imageView)
    }
}
