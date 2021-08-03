import Foundation
import Combine
import Resolver

class SearchViewModel: ObservableObject {
    // MARK: - Internal property
    
    @Published var searchState = MoviesViewModelState.idle
    
    // MARK: - Private properties
    private var searchResults: MovieResponse?
    @LazyInjected private var repository: IMovieRepository
    
    // MARK: - Internal functions
    
    func movieCount() -> Int { searchResults?.movies.count ?? 0 }
    func moviesFor(_ row: Int) -> responseData? { searchResults?.movies[row] }
    
    func searchForMovie(_ searchString: String) {
        repository.searchForMovie(searchString) { [weak self] result in
            self?.searchState = .loading
            switch result {
            case .finished:
                if self?.searchResults?.movies.count ?? 0 > 0 { self?.searchState = .loaded }
                else { self?.searchState = .error(APIError.noMoviesFound) }
            case .failure(let error):
                self?.searchState = .error(error)
            }
        } recievedValue: { [weak self] movies in
            self?.searchResults = movies
        }
    }
}
