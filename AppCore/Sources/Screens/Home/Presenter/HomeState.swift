//
//  HomeState.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import DomainModels
import Helpers

extension HomePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Proeprties

        var filters: RecipeFilters
        var isGettingRecipes: Bool
        var recipeCategories: DomainModelState<[RecipeCategory]>
        var pendingRecipe: Recipe?
        var searchedRecipes: [Recipe]
        var searchQuery: String
        var selectedCategories: Set<CategoryType>
        var route: AnyIdentifiable<Route>?

        var isSearchActive: Bool {
            !searchQuery.isEmpty || !filters.isEmpty
        }

        var areFilteredRecipesEmpty: Bool {
            !filters.isEmpty && searchedRecipes.isEmpty && !isGettingRecipes
        }

        var areRecipesEmpty: Bool {
            searchedRecipes.isEmpty && !isGettingRecipes
        }

        var trendingCategory: RecipeCategory {
            recipeCategories.items.first(where: \.isTrendingCategory) ?? .init(recipes: [], category: .trending)
        }

        var otherCategories: [RecipeCategory] {
            recipeCategories.items.filter { !$0.isTrendingCategory }
        }

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                filters: RecipeFilters(categories: [], timeFilters: []),
                isGettingRecipes: false,
                recipeCategories: DomainModelState(),
                searchedRecipes: [],
                searchQuery: "",
                selectedCategories: Set(),
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case didTapFilters
        case didTapRecipe(Recipe)
    }
}
