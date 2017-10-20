
import UIKit

class ExampleTransitionViewController: UIViewController {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(title: String, sampleCode: String, showsCloseControl: Bool = true) {
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
        self.view.backgroundColor = UIColor.white
        
        if showsCloseControl {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        }
        
        let codeSectionTitle = UILabel()
        codeSectionTitle.text = "Code"
        codeSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        codeSectionTitle.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        self.view.addSubview(codeSectionTitle)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint(item: codeSectionTitle, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
        } else {
            NSLayoutConstraint(item: codeSectionTitle, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 120).isActive = true
        }
        NSLayoutConstraint(item: codeSectionTitle, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        let sampleCodeView = CodeView()
        sampleCodeView.translatesAutoresizingMaskIntoConstraints = false
        sampleCodeView.code = sampleCode
        sampleCodeView.layer.cornerRadius = 8
        sampleCodeView.layer.shadowRadius = 5
        sampleCodeView.layer.shadowOpacity = 0.1
        sampleCodeView.layer.shadowColor = UIColor.black.cgColor
        sampleCodeView.layer.shadowOffset = CGSize(width: 7, height: 7)
        sampleCodeView.clipsToBounds = false
        self.view.addSubview(sampleCodeView)
        NSLayoutConstraint(item: sampleCodeView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: sampleCodeView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: -80).isActive = true
        NSLayoutConstraint(item: sampleCodeView, attribute: .top, relatedBy: .equal, toItem: codeSectionTitle, attribute: .bottom, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: codeSectionTitle, attribute: .left, relatedBy: .equal, toItem: sampleCodeView, attribute: .left, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func close() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
