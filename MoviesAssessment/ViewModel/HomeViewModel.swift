import UIKit.UIImage
import Combine
import Resolver

class HomeViewModel: ObservableObject {
    
    // MARK: - Private properties
    private let client = Client()
    private(set) var allGenres: [String?]?
    private var movies: [responseData]?
    @LazyInjected private var repository: IMovieRepository
    
    // MARK: Observables
    @Published var state = MoviesViewModelState.idle
    
    // MARK: - Internal Functions
    
    func getAllMovies() {
        repository.getAllMovies { [weak self] results in
            switch results {
            case .finished: self?.state = .loaded
            case .failure(let error): self?.state = .error(error) }
        } recievedValue: { [weak self] movieResponse in self?.requestedMovies(movieResponse: movieResponse) }
    }
    
    private func requestedMovies(movieResponse: MovieResponse) {
        movies = movieResponse.movies // Assign movies
        getGenres(movieResponse: movieResponse) // save all genres
    }
    
    func genrefor(_ section: Int) -> String  { allGenres?[section] ?? "" }
    
    func movieCount() -> Int { movies?.count ?? 0 }
    
    func moviesFor(_ section: Int) -> [responseData]? { movies?.filter({ $0.genres?.first == allGenres?[section] })}
    
    // MARK: - Helper Functions
    
    private func getGenres(movieResponse: MovieResponse) {
        let genres = movieResponse.movies.map({ $0.genres?.first })
        let unduplicateGenres = Array(Set.init(genres))
        allGenres = unduplicateGenres
    }
}
