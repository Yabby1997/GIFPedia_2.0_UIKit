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
    private let pinService: GIFFlagService

    private var queryText: String = ""

    @Published private var isLoading = false
    @Published private var scrollToTopSignal: Void?

    var gifsPublisher: AnyPublisher<[GIF], Never> {
        Publishers.CombineLatest(searchService.gifsPublisher, pinService.flagged)
            .map { searchedEntities, pinnedEntities in
                searchedEntities.map { entity in
                    entity.model(isPinned: pinnedEntities.contains(entity))
                }
            }
            .eraseToAnyPublisher()
    }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }
    var scrollToTopSignalPublisher: AnyPublisher<Void, Never> {
        $scrollToTopSignal.compactMap { $0 }.eraseToAnyPublisher()
    }

    init(searchService: GIFPediaSearchService, pinService: GIFFlagService) {
        self.searchService = searchService
        self.pinService = pinService
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

    func didLongTap(for gif: GIF) {
        if gif.isPinned {
            pinService.unflag(gif: gif.entity)
        } else {
            pinService.flag(gif: gif.entity)
        }
    }
}

// MARK: - Extensions

extension GIF {
    var entity: GIFEntity {
        GIFEntity(id: id, title: title, thumbnailUrl: thumbnailUrl, originalUrl: originalUrl)
    }
}

extension GIFEntity {
    func model(isPinned: Bool) -> GIF {
        GIF(id: id, title: title, thumbnailUrl: thumbnailUrl, originalUrl: originalUrl, isPinned: isPinned)
    }
}
