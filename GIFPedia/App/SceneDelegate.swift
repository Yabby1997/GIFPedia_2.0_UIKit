//
//  SceneDelegate.swift
//  GIFPedia_UIKit
//
//  Created by USER on 2023/06/05.
//

import UIKit
import GIFPediaService
import GiphyRepository
import GiphyURLSessionNetworkService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let giphyURLSessionNetworkService = GiphyURLSessionNetworkService()
        let giphyRepository = GiphyRepository(
            giphyNetworkService: giphyURLSessionNetworkService,
            apiKey: "7FckdoA95APjXjzIPCRm9he4wpaa6DFC"
        )
        let gifPediaService = GIFPediaService(gifRepository: giphyRepository)
        let gifSearchViewModel = GIFSearchViewModel(gifPediaService: gifPediaService)
        let gifSearchViewController = GIFSearchViewController(viewModel: gifSearchViewModel)
        window.rootViewController = UINavigationController(rootViewController: gifSearchViewController)
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
