
import UIKit

extension UIButton {
    func setupWithOutline() {
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor.clear
        self.setBackgroundColor(color: UIColor.lightGray.withAlphaComponent(0.2), forState: .highlighted)
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
