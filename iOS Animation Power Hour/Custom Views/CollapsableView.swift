
import UIKit

/// A view with a title and a collapse arrow button on the right. When this button is toggled, it
/// will slide out its `contentView` below it.
class CollapsableView: UIView {
    private(set) var isCollapsed: Bool = true {
        didSet {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.contentView.isHidden = self.isCollapsed
                self.collapseButton.transform = (self.isCollapsed) ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    let titleLabel = UILabel()
    
    private let collapseButton = UIButton(type: .system)
    private var contentView: UIView!
    
    required init(title: String, contentView: UIView, startsCollapsed: Bool = true) {
        super.init(frame: CGRect.zero)
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        self.addSubview(stackView)
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        let titleStackView = UIStackView()
        titleStackView.alignment = .center
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillProportionally
        titleStackView.spacing = 10
        stackView.addArrangedSubview(titleStackView)
        
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 44, weight: .thin)
        titleStackView.addArrangedSubview(self.titleLabel)
        
        self.collapseButton.translatesAutoresizingMaskIntoConstraints = false
        self.collapseButton.setImage(#imageLiteral(resourceName: "collapse-arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        self.collapseButton.imageView?.contentMode = .scaleAspectFit
        self.collapseButton.addTarget(self, action: #selector(collapseButtonPressed), for: .touchUpInside)
        self.collapseButton.setContentHuggingPriority(.required, for: .horizontal)
        self.collapseButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        NSLayoutConstraint(item: self.collapseButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: self.collapseButton, attribute: .width, relatedBy: .equal, toItem: self.collapseButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
        titleStackView.addArrangedSubview(self.collapseButton)
        
        self.contentView = contentView
        self.contentView.clipsToBounds = true
        stackView.addArrangedSubview(self.contentView)

        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        NSLayoutConstraint(item: lineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0.5).isActive = true
        stackView.addArrangedSubview(lineView)

        self.isCollapsed = startsCollapsed
        self.contentView.isHidden = self.isCollapsed
        self.collapseButton.transform = (self.isCollapsed) ? CGAffineTransform.identity : CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func collapseButtonPressed() {
        self.isCollapsed = !self.isCollapsed
    }
}
