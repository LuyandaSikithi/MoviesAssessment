import Foundation
import Combine
import Resolver

// MARK: - Interface

protocol IMovieRepository {
    func getAllMovies(completionState: @escaping ((Subscribers.Completion<Error>) -> Void),
                      recievedValue: @escaping ((MovieResponse) -> Void))
    
    func searchForMovie(_ searchString: String,
                        completionState: @escaping ((Subscribers.Completion<Error>) -> Void),
                        recievedValue: @escaping ((MovieResponse) -> Void))
}

// MARK: - Implementation

final class MovieRepository: IMovieRepository {
    // MARK: Private properties
    private var subscriptions: Set<AnyCancellable> = []
    @Injected var client: Client
    
    // MARK: Internal/Exposed Functions
    func getAllMovies(completionState: @escaping ((Subscribers.Completion<Error>) -> Void),
                      recievedValue: @escaping ((MovieResponse) -> Void)) {
        
        let request = GetAllMoviesRequest()
        client.publisherForRequest(request)
            .sink(receiveCompletion: { result in completionState(result) },
                  receiveValue: { movies in recievedValue(movies) }).store(in: &subscriptions)
    }
    
    func searchForMovie(_ searchString: String,
                        completionState: @escaping ((Subscribers.Completion<Error>) -> Void),
                        recievedValue: @escaping ((MovieResponse) -> Void)) {
        
        let request = GetMovieSearchRequest(searchString)
        client.publisherForRequest(request)
            .sink(receiveCompletion: { result in completionState(result)
            }, receiveValue: { movies in recievedValue(movies) })
            .store(in: &subscriptions)
    }
}
