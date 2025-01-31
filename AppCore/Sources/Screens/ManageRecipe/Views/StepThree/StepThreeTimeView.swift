//
//  StepThreeTimeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Helpers
import Library
import UIKit

final class StepThreeTimeView: UIView {

    struct Props: Equatable {
        let timeText: String
        let timeColorSource: ColorSource
        let timeTypography: Typography
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    // callbacks
    var onTap: () -> Void = { }

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
        setupTitleLabel()
    }

    private func setupContentView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), timeLabel])
        stackView.alignment = .bottom
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupTitleLabel() {
        titleLabel.render(title: .manageRecipeStepThreeTimeTitle, color: .textMain, typography: .subtitle)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Public methods

    func render(props: Props) {
        timeLabel.render(
            title: props.timeText,
            color: props.timeColorSource.color,
            typography: props.timeTypography
        )
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        onTap()
    }
}
