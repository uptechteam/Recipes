//
//  InputStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import BusinessLogic
import DomainModels
import Helpers

extension InputViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        let inputDetails: InputDetails
        var text: String
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case saveTapped
        case textChanged(String)
    }

    enum Route {
        case finish(InputDetails)
    }

    public struct Dependencies {

        // MARK: - Properties

        public let keyboardManager: KeyboardManaging

        // MARK: - Lifecycle

        public init(keyboardManager: KeyboardManaging) {
            self.keyboardManager = keyboardManager
        }
    }

    public static func makeStore(dependencies: Dependencies, envelope: InputEnvelope) -> Store {
        return Store(
            initialState: makeInitialState(dependencies: dependencies, envelope: envelope),
            reducer: reduce,
            middlewares: []
        )
    }

    private static func makeInitialState(dependencies: Dependencies, envelope: InputEnvelope) -> State {
        return State(
            inputDetails: envelope.details,
            text: "",
            route: nil
        )
    }
}

extension InputViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .saveTapped:
            switch newState.inputDetails {
            case .numberOfServings:
                newState.route = .init(value: .finish(.numberOfServings(newState.text)))

            default:
                break
            }

        case .textChanged(let text):
            newState.text = text
        }

        return newState
    }
}

