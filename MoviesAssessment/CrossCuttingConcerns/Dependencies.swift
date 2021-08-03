import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { MovieRepository() }.implements(IMovieRepository.self)
        register { Client() }
        register { HomeViewModel() }
        register { SearchViewModel() }
    }
}
