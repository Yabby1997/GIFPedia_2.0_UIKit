//
//  PinnedGIFViewModel.swift
//  GIFPedia
//
//  Created by USER on 2023/06/06.
//

import Foundation
import GIFPediaService
import Combine

final class PinnedGIFViewModel {
    private let pinService: GIFFlagService

    var gifsPublisher: AnyPublisher<[GIF], Never> {
        pinService.flagged
            .map { entities in
                print(entities.count)
                return entities.map { entity in
                    entity.model(isPinned: true)
                }
            }
            .eraseToAnyPublisher()
    }

    init(pinService: GIFFlagService) {
        self.pinService = pinService
    }

    func willAppear() {
        pinService.reload()
    }

    func didLongTap(for gif: GIF) {
        print(gif.entity.id)
        if gif.isPinned {
            pinService.unflag(gif: gif.entity)
        } else {
            pinService.flag(gif: gif.entity)
        }
    }
}
