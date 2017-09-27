
import UIKit

extension UIViewController {
    func stringFromCodeSampleFile(named fileName: String) -> String {
        var contents = ""
        if let filePath = Bundle.main.path(forResource: fileName, ofType: "txt") {
            if let data = try? String(contentsOfFile: filePath) {
                contents = data
            }
        }
        return contents
    }
    
    func createRedSquare(width: CGFloat = 100) -> UIView {
        let redSquare = UIView()
        redSquare.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: redSquare, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width).isActive = true
        NSLayoutConstraint(item: redSquare, attribute: .width, relatedBy: .equal, toItem: redSquare, attribute: .height, multiplier: 1, constant: 0).isActive = true
        redSquare.backgroundColor = UIColor.red
        return redSquare
    }
    
    func createViewWithTwoRedSquares() -> (container: UIView, s1: UIView, s2: UIView) {
        let square1 = self.createRedSquare(width: 60)
        let square2 = self.createRedSquare(width: 60)
        let containerView = UIView()
        containerView.addSubview(square1)
        containerView.addSubview(square2)
        NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint(item: square1, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: square2, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        let views = ["s1":square1, "s2":square2]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=30)-[s1]-20-[s2]-(>=30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        return (containerView, square1, square2)
    }
    
    func createViewWithSquareAndLabel() -> (container: UIView, square: UIView, label: UILabel) {
        let square = self.createRedSquare(width: 80)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        let containerView = UIView()
        containerView.addSubview(square)
        containerView.addSubview(label)
        NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 300).isActive = true
        NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: square, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        let views = ["square":square, "label":label]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=30)-[label]-20-[square]-(>=30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        return (containerView, square, label)
    }
}
