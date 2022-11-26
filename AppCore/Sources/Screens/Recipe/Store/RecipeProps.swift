//
//  RecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Foundation
import Library

extension RecipeViewController {
    static func makeProps(from state: State) -> RecipeView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            recipeImageSource: state.recipeImageSource,
            isLiked: false,
            recipeDetailsViewProps: makeRecipeDetailsViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> RecipeHeaderView.Props {
        return .init(
            title: state.recipeName,
            isLiked: false
        )
    }

    private static func makeRecipeDetailsViewProps(state: State) -> RecipeDetailsView.Props {
        return .init(
            headerViewProps: makeDetailsHeaderViewProps(state: state),
            ingredientsViewProps: makeIngredientsViewProps(state: state),
            instructionsViewProps: makeInstructionsViewProps(state: state),
            feedbackViewProps: makeFeedbackViewProps(state: state),
            manageViewProps: makeManageViewProps(state: state)
        )
    }

    private static func makeDetailsHeaderViewProps(state: State) -> RecipeDetailsHeaderView.Props {
        return .init(
            name: state.recipeName,
            contentStateView: makeContentStateView(state: state),
            authorViewProps: makeAuthorViewProps(state: state),
            isBottomContentVisible: state.recipeDetails.isPresent,
            ratingViewProps: RatingView.Props(ratingText: "\(state.recipeDetails.ratingDetails.rating)"),
            timeViewProps: RecipeTimeView.Props(timeDescription: "\(state.recipeDetails.duration) min")
        )
    }

    private static func makeAuthorViewProps(state: State) -> RecipeAuthorView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            avatarImageSource: state.recipeDetails.author.avatar,
            username: state.recipeName
        )
    }

    private static func makeContentStateView(state: State) -> ContentStateView.Props {
        return .init(
            isVisible: !state.recipeDetails.isPresent,
            isSpinnerVisible: state.recipeDetails.isLoading,
            isTitleVisible: state.recipeDetails.error != nil,
            title: "Something went wrong\nPlease try again",
            isActionButtonVisible: state.recipeDetails.error != nil,
            actionButtonTitle: "Retry"
        )
    }

    private static func makeIngredientsViewProps(state: State) -> RecipeIngredientsView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            servingsDescription: "? servings",
            ingredientsProps: state.recipeDetails.ingredients.map { ingredient in
                return RecipeIngredientView.Props(
                    name: ingredient.name,
                    weightDescription: "\(ingredient.amount)\(ingredient.unit.reduction)"
                )
            }
        )
    }

    private static func makeInstructionsViewProps(state: State) -> RecipeInstructionsView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            instructionsProps: state.recipeDetails.instructions.enumerated().map { (index, instruction) in
                RecipeInstructionView.Props(title: "\(index + 1) step", description: instruction)
            }
        )
    }

    private static func makeFeedbackViewProps(state: State) -> RecipeFeedbackView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            text: "How would you rate \(state.recipeName)?",
            rating: 0
        )
    }

    private static func makeManageViewProps(state: State) -> RecipeManageView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            isEditButtonVisible: true,
            isDeleteButtonVisible: true
        )
    }
}
