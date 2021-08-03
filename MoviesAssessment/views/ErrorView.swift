import UIKit

class ErrorView: UIView {

    // MARK: Private @IBOutlet(s)

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var message: UILabel!


    // MARK: Private @IBAction(s)

    @IBAction private func retryPressed(_ sender: Any) { onActionButtonTouched?() }

    // MARK: Properties

    var errorMessage: String = "" {
        didSet {
            message.textColor = UIColor.gray
            message.text = errorMessage
        }
    }

    var onActionButtonTouched: (() -> Void)? {
        didSet { actionButton.isHidden = onActionButtonTouched == nil }
    }

    // MARK: Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        if let contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
             addSubviewPinnedToEdges(contentView)
        }
        actionButton.roundCorners()
    }
}
