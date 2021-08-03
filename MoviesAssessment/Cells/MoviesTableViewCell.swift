import UIKit

fileprivate typealias CollectionDataSourceDelegate =  UICollectionViewDataSource & UICollectionViewDelegate

@objc(MoviesTableViewCell)
final class MoviesTableViewCell: UITableViewCell {
     
    private var movies: [responseData]?
    private var collectionViewOffset: CGPoint?
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self) , bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(movies : [responseData]?) {
        self.movies?.removeAll()
        self.movies = movies
    }
}
extension MoviesTableViewCell: CollectionDataSourceDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { movies?.count ?? 0 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as! MovieCollectionViewCell
        guard let fileUrl = URL(string: movies?[indexPath.row].poster ?? "") else { return cell }
        cell.movieImage.showActivityIndicator()
        getData(from: fileUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? fileUrl.lastPathComponent)
            cell.movieImage.hideActivityIndicator()
            DispatchQueue.main.async() { cell.movieImage.image = UIImage(data: data) }
        }
        
        guard let offset = self.collectionViewOffset else { return cell }
        collectionView.setContentOffset( CGPoint(x: offset.x, y: 0), animated: false)
        
        return cell
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedMovie = movies?[indexPath.row] else { return }
        NotificationCenter.default.post(name: .pushView, object: selectedMovie)
    }
}

extension MoviesTableViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.bounds.width / 4) - 5, height: collectionView.bounds.height - (2 * 5))
        return size
    }
}

