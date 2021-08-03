import UIKit
import Combine
import Resolver

@objc(HomesTableViewController)
final class HomesTableViewController: UITableViewController, BaseCoordinatorProtocol {
    
    private let refreshControls = UIRefreshControl()
    private var cancellable: AnyCancellable?
    @LazyInjected private var viewModel: HomeViewModel
    private var errorView: ErrorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModelStateBinding()
    }
    
    @objc func goToDetails(_ notification: Notification) {
        if let movie = notification.object as? responseData { navigateToDetailsScreen(from: navigationController, movie: movie) }
    }
    
    func navigateToDetailsScreen(from navigationController: UINavigationController?, movie: responseData) {
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    @objc func getData(_ sender: Any) { viewModel.getAllMovies() }
    
    private func setup() {
        getData(self)
        tableView.separatorStyle = .none
        refreshControls.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
        tableView.register(UINib(nibName: String(describing: MoviesTableViewCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: MoviesTableViewCell.self))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToDetails(_:)),
                                               name: .pushView, object: nil)
    }
    
    private func viewModelStateBinding() {
        self.cancellable = viewModel.$state.receive(on: DispatchQueue.main).sink {[weak self] state in
            self?.view.hideActivityIndicator()
            switch state {
            case .idle: break
            case .loading:
                self?.refreshControls.endRefreshing()
                self?.view.showActivityIndicator()
            case .loaded:
                self?.tableView.reloadData()
            case .error(let error):
                self?.showOnFailure(error: error)
            }
        }
    }
    
    private func showOnFailure(error: Error) {
        errorView = ErrorView(frame: self.view.bounds)
        errorView?.errorMessage = error.localizedDescription
        errorView?.onActionButtonTouched = {[weak self] in
            self?.viewModel.getAllMovies()
            self?.errorView?.removeFromSuperview()
        }
        self.view.addSubviewPinnedToEdges(errorView!)
    }
    
    private func setupTableHeader(text: String) -> UIView {
        let header = UIView(frame: CGRect(x: CGFloat.zero,
                                          y: CGFloat.zero,
                                          width: view.frame.width,
                                          height: Constants.Metrics.height80))
        
        let label = UILabel(frame: CGRect(x: Constants.Metrics.horizontalStride20,
                                          y: (Constants.Metrics.verticalStride2 * -1), // invert
                                          width: header.frame.size.width - Constants.Metrics.width15,
                                          height: header.frame.height - Constants.Metrics.height10))
        
        header.backgroundColor = .lightGray
        header.addSubview(label)
        label.textColor = .white
        label.text = text
        return header
    }
}

// MARK: - Tableview Datasource & Delegate

extension HomesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    override func numberOfSections(in tableView: UITableView) -> Int { viewModel.allGenres?.count ?? 0 }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { viewModel.genrefor(section) }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { setupTableHeader(text: viewModel.genrefor(section)) }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { Constants.Metrics.headerHeight60 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MoviesTableViewCell.self),
                                                       for: indexPath) as? MoviesTableViewCell else { return UITableViewCell() }
        cell.update(movies: viewModel.moviesFor(indexPath.section))
        self.tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        return cell
    }
}

