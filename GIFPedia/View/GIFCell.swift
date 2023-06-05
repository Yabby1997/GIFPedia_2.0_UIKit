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

    // MARK: - Properties

    var thumbnailUrl: URL? {
        didSet {
            guard let url = thumbnailUrl else { return }
            Nuke.loadImage(with: url, into: imageView)
        }
    }

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
        imageView.image = nil
    }

    // MARK: - Private Methods

    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
