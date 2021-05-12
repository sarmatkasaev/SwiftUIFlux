import SwiftUI
import SwiftUIFlux


// MARK: State
struct AppState: FluxState {
    var moviesState: MoviesState
}

struct MoviesState: FluxState, Codable {
    var movies: [Movie] = []
}

struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    
    let original_title: String
    let title: String
}


// MARK: Reducer
func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    state.moviesState = moviesStateReducer(state: state.moviesState, action: action)
    return state
}

func moviesStateReducer(state: MoviesState, action: Action) -> MoviesState {
    var state = state
    switch action {
    case let action as MoviesActions.SetDetail:
        state.movies.append(action.movie)

    default:
        break
    }

    return state
}

// MARK: Actions
struct MoviesActions {
    struct FetchDetail: AsyncAction {
        func execute(state: FluxState?, dispatch: @escaping DispatchFunction) {
            dispatch(SetDetail(movie: Movie(id: 1, original_title: "orig title 1", title: "title 11")))
        }
    }

    struct SetDetail: Action {
        let movie: Movie
    }

}





let store = Store<AppState>(reducer: appStateReducer,
//                            middleware: nil,
                            state: AppState(moviesState: MoviesState()))

@main
struct swiftui_navigationApp: App {
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                ContentView()
            }
        }
    }
}



// View
import SwiftUIFlux

@EnvironmentObject var store: Store<AppState>

store.state.moviesState.movies

store.dispatch(action: MoviesActions.FetchDetail())
