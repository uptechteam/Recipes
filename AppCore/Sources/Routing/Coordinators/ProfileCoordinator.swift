//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import Profile
import UIKit

final class ProfileCoordinator: Coordinating {

    // MARK: - Properties

    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController = makeViewController()
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }

    private func makeViewController() -> ProfileViewController {
        let dependencies = ProfileViewController.Dependencies()
        return ProfileViewController(
            store: ProfileViewController.makeStore(dependencies: dependencies),
            actionCreator: ProfileViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }
}

// MARK: - Extensions

extension ProfileCoordinator: ProfileCoordinating {

}
