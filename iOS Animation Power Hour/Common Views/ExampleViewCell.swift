
import UIKit

class ExampleViewCell: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let imageView = UIImageView()
    private var onTapAction: (() -> Void)!
    
    convenience init(title: String, description: String, onTapAction: @escaping () -> Void) {
        self.init(frame: CGRect())
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        self.onTapAction = onTapAction
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        NSLayoutConstraint(item: contentView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -7.5).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 7.5).isActive = true
        
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        self.descriptionLabel.text = description
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.descriptionLabel.textColor = UIColor.gray
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        self.imageView.image = #imageLiteral(resourceName: "chevron")
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.imageView)
        NSLayoutConstraint(item: self.imageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        let views = ["title":titleLabel, "description":descriptionLabel, "image":imageView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[title]-10-[description]-15-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[title]-15-[image(20)]-10-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[description]-15-[image]-10-|", options: [], metrics: nil, views: views))
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func onTap() {
        self.onTapAction()
    }
}
