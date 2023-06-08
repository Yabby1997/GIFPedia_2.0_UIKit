//
//  GIFCell.swift
//  GIFPedia
//
//  Created by USER on 2023/06/05.
//

import UIKit
import SnapKit
import Nuke
import FLAnimatedImage

final class GIFCell: UICollectionViewCell {
    static let identifier = "GIFCell"

    // MARK: - Subviews

    private let imageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = .systemGray3
        return imageView
    }()

    private let pinIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = .init(systemName: "pin.fill")
        imageView.tintColor = .red
        imageView.isHidden = true
        return imageView
    }()

    private let longTapGesture = UILongPressGestureRecognizer()

    // MARK: - Properties

    var thumbnailUrl: URL? {
        didSet {
            guard let url = thumbnailUrl else { return }
            Nuke.loadImage(with: url, into: imageView)
        }
    }

    var isPinned: Bool = false {
        didSet {
            pinIconView.isHidden = !isPinned
        }
    }

    var longTapHandler: (() -> Void)?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Callbacks

    override func prepareForReuse() {
        thumbnailUrl = nil
        imageView.image = nil
        isPinned = false
    }

    // MARK: - Private Methods

    private func setupViews() {
        longTapGesture.addTarget(self, action: #selector(didLongTap))
        contentView.addGestureRecognizer(longTapGesture)

        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.addSubview(pinIconView)
        pinIconView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.bottom.trailing.equalToSuperview().inset(12)
        }
    }

    @objc private func didLongTap(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else { return }
        longTapHandler?()
    }
}
