//
//  GIF.swift
//  GIFPedia
//
//  Created by USER on 2023/06/08.
//

import Foundation

struct GIF: Hashable, Equatable {
    let id: String
    let title: String
    let thumbnailUrl: URL
    let originalUrl: URL
    let isPinned: Bool
}
