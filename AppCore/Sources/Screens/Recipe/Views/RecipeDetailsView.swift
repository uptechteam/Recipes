//
//  RecipeDetailsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeDetailsView: UIView {

    struct Props: Equatable {

    }

    // MARK: - Properties



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
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
