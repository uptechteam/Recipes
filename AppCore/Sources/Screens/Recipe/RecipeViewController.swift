//
//  RecipeViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import DomainModels
import Helpers
import UIKit

public protocol RecipeCoordinating: AnyObject {
    func didTapAuthor(_ author: User)
    func didTapBack()
    func didTapEditRecipe(_ recipeDetails: RecipeDetails)
}

public final class RecipeViewController: UIViewController {

    // MARK: - Properties

    private let presenter: RecipePresenter
    private let contentView = RecipeView()
    private unowned let coordinator: RecipeCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: RecipePresenter, coordinator: RecipeCoordinating) {
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deinit \(self)")
    }

    public override func loadView() {
        view = contentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { [presenter] in
            await presenter.viewWillAppear()
        }
    }

    // MARK: - Private methods

    private func setupBinding() {
        contentView.headerView.onTapBack = { [presenter] in
            presenter.backTapped()
        }

        contentView.onTapBack = { [presenter] in
            presenter.backTapped()
        }

        contentView.onTapFavorite = toSyncClosure { [presenter] in
            await presenter.favoriteTapped()
        }

        contentView.headerView.onTapFavorite = toSyncClosure { [presenter] in
            await presenter.favoriteTapped()
        }

        contentView.detailsView.headerView.authorView.onTap = { [presenter] in
            presenter.authorTapped()
        }

        contentView.detailsView.headerView.contentStateView.onTapAction = toSyncClosure { [presenter] in
            await presenter.retryTapped()
        }

        contentView.detailsView.feedbackView.onTapStar = toSyncClosure { [presenter] index in
            await presenter.starTapped(index: index)
        }

        contentView.detailsView.manageView.onTapEdit = { [presenter] in
            presenter.editTapped()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { RecipePresenter.makeProps(from: $0) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: RecipePresenter.Route) {
        switch route {
        case .didTapAuthor(let author):
            coordinator.didTapAuthor(author)

        case .didTapBack:
            coordinator.didTapBack()

        case .didTapEdit(let recipe):
            coordinator.didTapEditRecipe(recipe)
        }
    }
}
