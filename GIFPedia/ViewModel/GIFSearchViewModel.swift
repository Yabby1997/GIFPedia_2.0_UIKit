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
    private let searchService: GIFPediaSearchService

    private var queryText: String = ""

    @Published private var isLoading = false
    @Published private var scrollToTopSignal: Void?

    var gifsPublisher: AnyPublisher<[GIF], Never> { searchService.gifsPublisher }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }
    var scrollToTopSignalPublisher: AnyPublisher<Void, Never> {
        $scrollToTopSignal.compactMap { $0 }.eraseToAnyPublisher()
    }

    init(searchService: GIFPediaSearchService) {
        self.searchService = searchService
    }

    func didUpdateQuery(text: String?) {
        queryText = text ?? ""
    }

    func didTapSearchButton() {
        Task {
            isLoading = true
            await searchService.search(keyword: queryText)
            scrollToTopSignal = ()
            isLoading = false
        }
    }

    func didScrollTo(bottomOffset: CGFloat) {
        guard !isLoading, !queryText.isEmpty, bottomOffset < 300 else { return }
        Task {
            isLoading = true
            await searchService.requestNext()
            isLoading = false
        }
    }
}
