import UIKit
import Combine
import Resolver

@objc(SearchViewController)
final class SearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            searchBar.delegate = self
            tableView.separatorStyle = .none
        }
    }
    private var errorView: ErrorView?
    private var cancellable: AnyCancellable?
    private var imagecancell: Set<AnyCancellable> = []
    @LazyInjected private var viewModel: SearchViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelStateBinding()
        tableView.register(UINib(nibName: String(describing: SearchTableViewCell.self),
                                 bundle: nil), forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
    }
    
    private func viewModelStateBinding() {
        self.cancellable = viewModel.$searchState.receive(on: DispatchQueue.main).sink { [weak self] state in
            switch state {
            case .idle:break
            case .loading:
                self?.view.showActivityIndicator()
            case .loaded:
                self?.tableView.reloadData()
                self?.view.hideActivityIndicator()
            case .error(let error):
                self?.view.hideActivityIndicator()
                self?.showOnFailure(error: error)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    private func showOnFailure(error: Error) {
        errorView = ErrorView(frame: self.view.bounds)
        errorView?.errorMessage = error.localizedDescription
        errorView?.onActionButtonTouched = {[weak self] in
            self?.errorView?.removeFromSuperview()
        }
        self.view.addSubviewPinnedToEdges(errorView!)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchString = searchBar.searchTextField.text , (searchBar.searchTextField.text?.count ?? 0) > 0  else {
             self.showAlert(alertText: "Error", alertMessage: NSLocalizedString("You have not entered the movie to search", comment: ""))
            return
        }
        viewModel.searchForMovie(searchString)
        searchBar.resignFirstResponder()
    }
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = viewModel.moviesFor(indexPath.row) { navigateToDetailsScreen(from: navigationController, movie: selectedMovie) }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.movieCount() }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movie = viewModel.moviesFor(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTableViewCell.self),
                                                       for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.movieTitleLabel.text = movie.title
        if let fileUrl = URL(string: movie.poster ?? "" ) {
            getData(from: fileUrl) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? fileUrl.lastPathComponent)
                cell.movieImage.hideActivityIndicator()
                DispatchQueue.main.async() { cell.movieImage.image = UIImage(data: data) }
            }
        }
        return cell
    }
}

// MARK: - Coordination

extension SearchViewController: BaseCoordinatorProtocol {
    func navigateToDetailsScreen(from navigationController: UINavigationController?, movie: responseData) {
        let viewController = MovieDetailsViewController(movie: movie)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
