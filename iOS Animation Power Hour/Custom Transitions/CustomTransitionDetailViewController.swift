
import UIKit

class CustomTransitionDetailViewController: UIViewController {
    var puppy: Puppy? {
        didSet {
            if let puppy = puppy {
                self.nameLabel.text = puppy.name
                self.imageView.image = puppy.image
                self.descriptionLabel.text = puppy.description
            }
        }
    }
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let closeButton = UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        self.closeButton.addTarget(self, action: #selector(onClosePressed), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        NSLayoutConstraint(item: self.closeButton, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -25).isActive = true
        NSLayoutConstraint(item: self.closeButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 35).isActive = true
        NSLayoutConstraint(item: self.closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 50).isActive = true
        NSLayoutConstraint(item: self.closeButton, attribute: .width, relatedBy: .equal, toItem: self.closeButton, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        self.nameLabel.textColor = UIColor.white
        self.view.addSubview(self.nameLabel)
        NSLayoutConstraint(item: self.nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFill
        self.view.addSubview(self.imageView)
        NSLayoutConstraint(item: self.imageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 400).isActive = true
        NSLayoutConstraint(item: self.imageView, attribute: .height, relatedBy: .equal, toItem: self.imageView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.numberOfLines = 0
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        self.descriptionLabel.textColor = UIColor.white
        self.view.addSubview(self.descriptionLabel)
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.descriptionLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: 0).isActive = true
        
        let views = ["name":nameLabel, "image":imageView, "desc":descriptionLabel]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[name]-25-[image]-25-[desc]-(>=30)-|", options: [], metrics: nil, views: views))
    }
    
    @objc func onClosePressed() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
