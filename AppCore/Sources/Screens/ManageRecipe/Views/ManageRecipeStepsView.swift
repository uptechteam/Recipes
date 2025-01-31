//
//  ManageRecipeStepsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Library
import UIKit

final class ManageRecipeStepsView: UIView {

    struct Props: Equatable {
        let title: String
        let isBackButtonVisible: Bool
        let isNextButtonVisible: Bool
        let isFinishButtonVisible: Bool
        let isLoaderVisible: Bool
    }

    // MARK: - Properties

    private let dividerView = UIView()
    private let backButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    private let titleLabel = UILabel()
    private let nextButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: .primary,
            imagePosition: .right,
            isBackgroundVisible: false
        )
    )
    private let finishButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    private let spinnerView = SpinnerView()
    // callbacks
    var onTapBack: () -> Void = { }
    var onTapNext: () -> Void = { }
    var onTapFinish: () -> Void = { }

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
        setupDivider()
        setupStackView()
        setupBackButton()
        setupTitleLabel()
        setupNextButton()
        setupFinishButton()
        setupSpinnerView()
    }

    private func setupDivider() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel, nextButton, finishButton, spinnerView])
        stackView.alignment = .center
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    private func setupBackButton() {
        backButton.addAction(UIAction(handler: { [unowned self] _ in onTapBack() }), for: .touchUpInside)
        backButton.setImage(.arrowBack)
        backButton.setTitle(.manageRecipeNavigationBack)
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func setupNextButton() {
        nextButton.addAction(UIAction(handler: { [unowned self] _ in onTapNext() }), for: .touchUpInside)
        nextButton.setImage(.arrowForwardGreen)
        nextButton.setTitle(.manageRecipeNavigationNext)
    }

    private func setupFinishButton() {
        finishButton.addAction(
            UIAction(handler: { [unowned self] _ in onTapFinish() }),
            for: .touchUpInside
        )
        finishButton.setTitle(.manageRecipeNavigationFinish)
    }

    private func setupSpinnerView() {
        NSLayoutConstraint.activate([
            spinnerView.widthAnchor.constraint(equalToConstant: 20),
            spinnerView.heightAnchor.constraint(equalTo: spinnerView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .textMain, typography: .buttonLarge)
        backButton.alpha = props.isBackButtonVisible ? 1 : 0
        nextButton.isHidden = !props.isNextButtonVisible
        finishButton.isHidden = !props.isFinishButtonVisible
        spinnerView.toggle(isAnimating: props.isLoaderVisible)
    }
}
