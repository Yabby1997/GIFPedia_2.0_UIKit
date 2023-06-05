//
//  GIFSearchViewModel.swift
//  GIFPedia
//
//  Created by USER on 2023/06/06.
//

import Foundation
import GIFPediaService
import Combine

final class GIFSearchViewModel {
    private let gifPediaService: GIFPediaService

    var gifsPublisher: AnyPublisher<[GIF], Never> { gifPediaService.gifsPublisher }
    @Published var queryText: String = ""

    init(gifPediaService: GIFPediaService) {
        self.gifPediaService = gifPediaService
    }

    func didTapSearchButton() {
        gifPediaService.search(keyword: queryText)
    }

    func didScrollToEnd() {
        gifPediaService.requestNext()
    }
}
