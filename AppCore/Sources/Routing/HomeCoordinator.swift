//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Author
import BusinessLogic
import DomainModels
import Filters
import Foundation
import Home
import Library
import Recipe
import TabBar
import UIKit

@MainActor
final class HomeCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    private var interactiveControllers: [Int: SwipeInteractionController]
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    private var tabBarController: TabBarController? {
        navigationController.tabBarController as? TabBarController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.interactiveControllers = [:]
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = HomeViewController.resolve(coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.delegate = self
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - AuthorCoordinating

extension HomeCoordinator: AuthorCoordinating {
    func didTapBackOnAuthor() {
        navigationController.popViewController(animated: true)
    }

    func didTapRecipeOnAuthor(_ recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - HomeCoordinating

extension HomeCoordinator: HomeCoordinating {
    func showFilters() {
        let viewController = FiltersViewController.resolve(coordinator: self, envelope: .home)
        navigationController.pushViewController(viewController, animated: true)
    }

    func show(recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - FiltersCoordinating

extension HomeCoordinator: FiltersCoordinating {
    func didApplyFilters() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - RecipeCoordinating

extension HomeCoordinator: RecipeCoordinating {
    func didTapAuthor(_ author: User) {
        let envelope = AuthorEnvelope(author: author)
        let viewController = AuthorViewController.resolve(coordinator: self, envelope: envelope)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapBack() {
        navigationController.popViewController(animated: true)
    }

    func didTapEditRecipe(_ recipeDetails: RecipeDetails) {
        let coordinator = ManageRecipeCoordinator(
            presentingViewController: navigationController,
            recipeDetails: recipeDetails
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

// MARK: - UINavigationControllerdelegate

extension HomeCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if !viewController.isTabBarVisible {
            tabBarController?.toggleTabBarVisibility(on: false)
        }

        let isNavigationBarHidden = viewController is HomeViewController
        || viewController is RecipeViewController
        || viewController is AuthorViewController
        navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        tabBarController?.toggleTabBarVisibility(on: viewController.isTabBarVisible)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard
            let transition = animationController as? PopTransition,
            let controller = interactiveControllers[transition.fromViewController.hash],
            controller.isInteractionInProgress
        else {
            return nil
        }

        return controller
    }

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            let controller = SwipeInteractionController(viewController: toVC)
            interactiveControllers[toVC.hash] = controller
            return PushTransition(snapshot: tabBarController?.makeTabBarSnapshot() ?? UIView())

        case .pop:
            return PopTransition(fromViewController: fromVC)

        default:
            return nil
        }
    }
}
