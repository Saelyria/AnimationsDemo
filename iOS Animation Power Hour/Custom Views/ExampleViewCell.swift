
import UIKit

class ExampleViewCell: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    private var onTapAction: (() -> Void)!
    
    convenience init(title: String, description: String, onTapAction: @escaping () -> Void) {
        self.init(frame: CGRect())
        
        self.onTapAction = onTapAction
        
        self.titleLabel.text = title
        self.titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        self.descriptionLabel.text = description
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        self.descriptionLabel.textColor = UIColor.gray
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        
        let views = ["title":titleLabel, "description":descriptionLabel]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[title]-10-[description]-15-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[title]-10-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[description]-10-|", options: [], metrics: nil, views: views))
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func onTap() {
        self.onTapAction()
    }
}
