//
//  SceneDelegate.swift
//  GIFPedia_UIKit
//
//  Created by USER on 2023/06/05.
//

import UIKit
import GIFPediaService
import TenorRepository
import GiphyRepository
import SHURLSessionNetworkService
import PinnedGIFPersistence
import SHUserDefaultsPersistenceService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var gifPinService: GIFFlagService = {
        let persistenceService = SHUserDefaultsPersistenceService()
        let pinnedGIFPersistence = PinnedGIFPersistence(persistenceService: persistenceService)
        return GIFFlagService(gifPersistence: pinnedGIFPersistence)
    }()

    private lazy var giphySearchViewController: UIViewController = {
        let networkService = SHURLSessionNetworkService()
        let giphyRepository = GiphyRepository(
            networkService: networkService,
            apiKey: "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"
        )
        let gifPediaSearchService = GIFPediaSearchService(gifRepository: giphyRepository)
        let gifSearchViewModel = GIFSearchViewModel(searchService: gifPediaSearchService, pinService: gifPinService)
        let gifSearchViewController = GIFSearchViewController(viewModel: gifSearchViewModel)
        let gifSearchNavigationViewController = UINavigationController(rootViewController: gifSearchViewController)
        gifSearchNavigationViewController.tabBarItem = UITabBarItem(
            title: "Giphy",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        return gifSearchNavigationViewController
    }()

    private lazy var tenorSearchViewController: UIViewController = {
        let networkService = SHURLSessionNetworkService()
        let tenorRepository = TenorRepository(
            networkService: networkService,
            apiKey: "AIzaSyAyqL6ZgYRj60GIMveovpSLqAsmyGp2BRE"
        )
        let gifPediaSearchService = GIFPediaSearchService(gifRepository: tenorRepository)
        let gifSearchViewModel = GIFSearchViewModel(searchService: gifPediaSearchService, pinService: gifPinService)
        let gifSearchViewController = GIFSearchViewController(viewModel: gifSearchViewModel)
        let gifSearchNavigationViewController = UINavigationController(rootViewController: gifSearchViewController)
        gifSearchNavigationViewController.tabBarItem = UITabBarItem(
            title: "Tenor",
            image: UIImage(systemName: "magnifyingglass.circle"),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")
        )
        return gifSearchNavigationViewController
    }()

    private lazy var pinnedViewController: UIViewController = {
        let pinnedGIFViewModel = PinnedGIFViewModel(pinService: gifPinService)
        let pinnedGIFViewController = PinnedGIFViewController(viewModel: pinnedGIFViewModel)
        let pinnedGIFNavigationViewController = UINavigationController(rootViewController: pinnedGIFViewController)
        pinnedGIFNavigationViewController.tabBarItem = UITabBarItem(
            title: "Pinned",
            image: UIImage(systemName: "pin.circle"),
            selectedImage: UIImage(systemName: "pin.circle.fill")
        )
        return pinnedGIFNavigationViewController
    }()

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            giphySearchViewController,
            tenorSearchViewController,
            pinnedViewController
        ]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
