import UIKit
import Combine
import Cosmos

@objc(MovieDetailsViewController)
final class MovieDetailsViewController: UIViewController {
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var castLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var ratingView: CosmosView!
    
    private var movie: responseData?
    init(movie: responseData?) {
        self.movie = movie
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
    }

    private func updateDisplay() {
        guard let chosenMovie = movie else { return }
        ratingView.rating = (chosenMovie.imdb_rating ?? 0) / 2
        titleLabel.text = chosenMovie.title ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        var yearLengthString = ""
        
        if let dateFromString = dateFormatter.date(from: chosenMovie.released_on ?? "") {
            let components = Calendar.current.dateComponents([.day, .month,.year], from: dateFromString)
            if let year = components.year{
                yearLengthString = String(year)
            }
        }
        
        if let movieLength = chosenMovie.length  {
            yearLengthString = yearLengthString  + " | " + movieLength
        }
        
        switch chosenMovie.director! {
        case .string(let director):
            yearLengthString = yearLengthString + " | " + director
        case .stringArray(let directors):
            yearLengthString = yearLengthString + " | " + directors.joined(separator: ",")
        }
        
        yearLabel.text = yearLengthString
        let castString = "Cast: {value}"
        
        let ratingStringValue = String(format: "%.02f", chosenMovie.imdb_rating ?? 0)
        titleLabel.text =  titleLabel.text!  + " (\(ratingStringValue))"
        let castMembers = chosenMovie.cast?.joined(separator: ", ")
        castLabel.text = castString.replacingOccurrences(of: "{value}", with: castMembers ?? "")
        descriptionTextView.text = chosenMovie.overview ?? ""
        
        
        if let fileUrl = URL(string: chosenMovie.backdrop ?? "") {
            getData(from: fileUrl) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? fileUrl.lastPathComponent)
                DispatchQueue.main.async() { [weak self] in
                    self?.backgroundImage.image = UIImage(data: data)
                }
            }
        }
        
        if let fileUrl = URL(string: chosenMovie.poster ?? "") {
            getData(from: fileUrl) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? fileUrl.lastPathComponent)
                DispatchQueue.main.async() { [weak self] in
                    self?.movieImage.image = UIImage(data: data)
                }
            }
        }
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
