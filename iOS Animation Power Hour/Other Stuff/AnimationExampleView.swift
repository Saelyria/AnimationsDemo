
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
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        self.layer.cornerRadius = 8
        
        self.horizontalStackView.axis = .horizontal
        self.horizontalStackView.distribution = .fillProportionally
        self.horizontalStackView.alignment = .center
        self.addSubview(self.horizontalStackView)
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: self.horizontalStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        
        self.leftVerticalStackView.axis = .vertical
        self.leftVerticalStackView.distribution = .fillProportionally
        self.leftVerticalStackView.alignment = .center
        self.leftVerticalStackView.spacing = 10
        self.horizontalStackView.addArrangedSubview(self.leftVerticalStackView)
        
        self.rightVerticalStackView.axis = .vertical
        self.rightVerticalStackView.distribution = .fillProportionally
        self.rightVerticalStackView.alignment = .center
        self.rightVerticalStackView.spacing = 10
        self.horizontalStackView.addArrangedSubview(self.rightVerticalStackView)
        
        if components.contains(.bezierView) {
            self.bezierView = BezierCurveView()
            self.bezierView!.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: self.bezierView!, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 80).isActive = true
            NSLayoutConstraint(item: self.bezierView!, attribute: .width, relatedBy: .equal, toItem: self.bezierView!, attribute: .height, multiplier: 1, constant: 0).isActive = true
            self.horizontalStackView.addArrangedSubview(self.bezierView!)
        }
        
        if components.contains(.label) {
            self.label = UILabel()
            self.label!.translatesAutoresizingMaskIntoConstraints = false
            self.label!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
            NSLayoutConstraint(item: self.label!, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 60).isActive = true
            self.rightVerticalStackView.addArrangedSubview(self.label!)
        }
        
        if components.contains(.redSquare) && components.contains(.secondRedSquare) {
            let square1 = self.createRedSquare(width: 60)
            let square2 = self.createRedSquare(width: 60)
            self.redSquares = [square1, square2]
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = false
            containerView.addSubview(square1)
            containerView.addSubview(square2)
            NSLayoutConstraint(item: square1, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: square2, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            let views = ["s1":square1, "s2":square2]
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=30)-[s1]-20-[s2]-(>=30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            
            self.rightVerticalStackView.addArrangedSubview(containerView)
        } else if (components.contains(.redSquare)) {
            let square = self.createRedSquare()
            self.redSquares = [square]
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.clipsToBounds = false
            containerView.addSubview(square)
            NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            self.rightVerticalStackView.addArrangedSubview(containerView)
        }
        
        if components.contains(.blueSquareInRedSquare) {
            if let redSquare = self.redSquares.first {
                let blueSquare = self.createRedSquare(width: 50)
                blueSquare.translatesAutoresizingMaskIntoConstraints = false
                blueSquare.backgroundColor = UIColor.blue
                redSquare.addSubview(blueSquare)
                NSLayoutConstraint(item: blueSquare, attribute: .centerX, relatedBy: .equal, toItem: redSquare, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
                NSLayoutConstraint(item: blueSquare, attribute: .centerY, relatedBy: .equal, toItem: redSquare, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            }
        }
        
        
//        let square = self.createRedSquare(width: 80)
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
//        self.addSubview(square)
//        self.addSubview(label)
//        NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200).isActive = true
//        NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
//        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func getView(forComponent component: Component) -> UIView? {
        switch component {
        case .bezierView: return self.bezierView
        case .label: return self.label
        case .redSquare: return self.redSquares[0]
        case .secondRedSquare: return self.redSquares[1]
        case .blueSquareInRedSquare: return self.blueSquare
        default: return nil
        }
    }
}

fileprivate extension AnimationExampleView {
    func createRedSquare(width: CGFloat = 100) -> UIView {
        let redSquare = UIView()
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: redSquare, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: redSquare, attribute: .width, relatedBy: .equal, toItem: redSquare, attribute: .height, multiplier: 1, constant: 0).isActive = true
        redSquare.backgroundColor = UIColor.red
        return redSquare
    }
}
