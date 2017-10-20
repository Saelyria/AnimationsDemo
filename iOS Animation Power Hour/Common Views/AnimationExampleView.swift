
import UIKit

/// The view containing the red animatable square. It can be constructed using a number of difference components
/// for demonstrating other aspects of the animation, including a second red square, a Bézier curve view, a label,
/// or a blue square set as a subview of the red square.
class AnimationExampleView: UIView {
    struct Component: OptionSet {
        let rawValue: Int
        
        static let bezierView = Component(rawValue: 0)
        static let label = Component(rawValue: 1)
        static let redSquare = Component(rawValue: 2)
        static let secondRedSquare = Component(rawValue: 3)
        static let blueSquareInRedSquare = Component(rawValue: 4)
    }
    
    private var components = [Component]()
    private(set) var bezierView: BezierCurveView?
    private(set) var label: UILabel?
    private(set) var redSquares = [UIView]()
    private(set) var blueSquare: UIView?
    
    private let horizontalStackView = UIStackView()
    private let leftVerticalStackView = UIStackView()
    private let rightVerticalStackView = UIStackView()
    
    convenience init(withComponents components: [Component]) {
        self.init(frame: CGRect())
        self.components = components
        self.backgroundColor = UIColor.groupTableViewBackground
        self.layer.cornerRadius = 8
        
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.distribution = .fillProportionally
        self.horizontalStackView.alignment = .fill
        self.addSubview(self.horizontalStackView)
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        self.leftVerticalStackView.isHidden = true
        self.leftVerticalStackView.axis = .vertical
        self.leftVerticalStackView.distribution = .fill
        self.leftVerticalStackView.alignment = .fill
        self.leftVerticalStackView.spacing = 10
        self.horizontalStackView.addArrangedSubview(self.leftVerticalStackView)
        
        self.rightVerticalStackView.isHidden = true
        self.rightVerticalStackView.axis = .vertical
        self.rightVerticalStackView.distribution = .fill
        self.rightVerticalStackView.alignment = .fill
        self.rightVerticalStackView.spacing = 10
        self.horizontalStackView.addArrangedSubview(self.rightVerticalStackView)
        
        if components.contains(.bezierView) {
            self.leftVerticalStackView.isHidden = false
            self.bezierView = BezierCurveView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            self.bezierView!.backgroundColor = UIColor.clear
            self.bezierView!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: self.bezierView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 80).isActive = true
            NSLayoutConstraint(item: self.bezierView!, attribute: .width, relatedBy: .equal, toItem: self.bezierView!, attribute: .height, multiplier: 1, constant: 0).isActive = true
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = false
            containerView.addSubview(bezierView!)
            NSLayoutConstraint(item: self.bezierView!, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: self.bezierView!, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            self.leftVerticalStackView.addArrangedSubview(containerView)
        }
        
        if components.contains(.label) {
            self.rightVerticalStackView.isHidden = false
            self.label = UILabel()
            self.label!.textAlignment = .center
            self.label!.translatesAutoresizingMaskIntoConstraints = false
            self.label!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
            NSLayoutConstraint(item: self.label!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 45).isActive = true
            self.rightVerticalStackView.addArrangedSubview(self.label!)
        }
        
        if components.contains(.redSquare) && components.contains(.secondRedSquare) {
            self.rightVerticalStackView.isHidden = false
            let square1 = self.createRedSquare(width: 60)
            let square2 = self.createRedSquare(width: 60)
            self.redSquares = [square1, square2]
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = false
            containerView.addSubview(square1)
            containerView.addSubview(square2)
            NSLayoutConstraint(item: square1, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: square1, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: -35).isActive = true
            NSLayoutConstraint(item: square2, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: square2, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 35).isActive = true
            
            self.rightVerticalStackView.addArrangedSubview(containerView)
        } else if (components.contains(.redSquare)) {
            self.rightVerticalStackView.isHidden = false
            let square = self.createRedSquare()
            self.redSquares = [square]
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = false
            containerView.addSubview(square)
            NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: square, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            self.rightVerticalStackView.addArrangedSubview(containerView)
        }
        
        if components.contains(.blueSquareInRedSquare) {
            if let redSquare = self.redSquares.first {
                let blueSquare = self.createRedSquare(width: 50)
                blueSquare.backgroundColor = UIColor.blue
                redSquare.addSubview(blueSquare)
                redSquare.clipsToBounds = true
                NSLayoutConstraint(item: blueSquare, attribute: .centerX, relatedBy: .equal, toItem: redSquare, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: blueSquare, attribute: .centerY, relatedBy: .equal, toItem: redSquare, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            }
        }
    }
}

fileprivate extension AnimationExampleView {
    func createRedSquare(width: CGFloat = 100) -> UIView {
        let redSquare = UIView()
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: redSquare, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: redSquare, attribute: .width, relatedBy: .equal, toItem: redSquare, attribute: .height, multiplier: 1, constant: 0).isActive = true
        redSquare.backgroundColor = UIColor.red
        redSquare.layer.cornerRadius = 8
        redSquare.layer.shadowRadius = 5
        redSquare.layer.shadowOpacity = 0.2
        redSquare.layer.shadowColor = UIColor.black.cgColor
        redSquare.layer.shadowOffset = CGSize(width: 5, height: 5)
        return redSquare
    }
}
