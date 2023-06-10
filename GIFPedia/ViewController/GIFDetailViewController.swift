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
import GIFPediaPresentationLayer

final class GIFDetailViewController: UIViewController {

    // MARK: - Subviews

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()

    private let doubleTapGesture = UITapGestureRecognizer()

    private let pinIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = .init(systemName: "pin.fill")
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Properties

    var gif: GIF? {
        didSet { reloadGif() }
    }

    var doubleTapHandler: ((GIF) -> Void)?

    // MARK: - Lifecycle Callbacks

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private Methods

    private func setupViews() {
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(didDoubleTap))
        view.backgroundColor = .systemBackground

        view.addSubview(imageView)
        imageView.addGestureRecognizer(doubleTapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.snp.makeConstraints { make in
            make.center.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        imageView.addSubview(pinIconView)
        pinIconView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.bottom.trailing.equalToSuperview().inset(24)
        }
    }

    private func reloadGif() {
        guard let gif else { return }
        navigationItem.title = gif.title
        Nuke.loadImage(with: gif.originalUrl, into: imageView)
        pinIconView.isHidden = !gif.isPinned
    }

    @objc private func didDoubleTap(_ sender: UIGestureRecognizer) {
        guard let gif else { return }
        doubleTapHandler?(gif)
    }
}
