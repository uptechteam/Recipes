//
//  FavoritesView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers
import Library
import UIKit

final class FavoritesView: UIView {

    struct Props: Equatable {
        let filtersIcon: ImageSource
        let filterDescriptionViewProps: FiltersDescriptionView.Props
        let recipesViewProps: FavoriteRecipesView.Props
        let contentStateViewProps: ContentStateView.Props
    }

    // MARK: - Properties

    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    let filtersButton = IconButton()
    let searchTextField = SearchTextField()
    private let filterDescriptionView = FiltersDescriptionView()
    let recipesView = FavoriteRecipesView()
    let contentStateView = ContentStateView()
    // callbacks
    var onTapFilters: () -> Void = { }
    var onChangeSearchQuery: (String) -> Void = { _ in }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupStackView()
        setupTitleStackView()
        setupTitleLabel()
        setupSearchTextField()
        setupFiltersButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [titleStackView, searchTextField, filterDescriptionView, recipesView, contentStateView]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(18, after: titleStackView)
        stackView.setCustomSpacing(24, after: searchTextField)
        stackView.setCustomSpacing(24, after: filterDescriptionView)
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    private func setupTitleStackView() {
        [titleLabel, UIView(), filtersButton].forEach(titleStackView.addArrangedSubview)
        titleStackView.alignment = .center
    }

    private func setupTitleLabel() {
        titleLabel.render(title: .favoritesTitle, color: .appBlack, typography: .headerTwo)
    }

    private func setupFiltersButton() {
        filtersButton.addAction(UIAction(handler: { [unowned self] _ in onTapFilters() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = .favoritesSearchPlaceholder
        searchTextField.tintColor = .appBlack
    }

    // MARK: - Public methods

    func render(props: Props) {
        filtersButton.set(image: props.filtersIcon.image)
        filterDescriptionView.render(props: props.filterDescriptionViewProps)
        recipesView.render(props: props.recipesViewProps)
        contentStateView.render(props: props.contentStateViewProps)
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FavoritesView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }

        return !(view is UIControl)
    }
}
