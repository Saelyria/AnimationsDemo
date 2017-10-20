
import UIKit

class CustomTransitionViewController: UIViewController {
    private let puppies = [
        Puppy(name: "Lucas", image: #imageLiteral(resourceName: "pup-1"), description: ""),
        Puppy(name: "George", image: #imageLiteral(resourceName: "pup-2"), description: ""),
        Puppy(name: "Sergeant", image: #imageLiteral(resourceName: "pup-3"), description: ""),
        Puppy(name: "Pug", image: #imageLiteral(resourceName: "pup-4"), description: ""),
        Puppy(name: "Jonas", image: #imageLiteral(resourceName: "pup-5"), description: ""),
        Puppy(name: "Tina", image: #imageLiteral(resourceName: "pup-6"), description: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Custom Transitions"
        self.view.backgroundColor = UIColor.white

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 225, height: 225)
        layout.minimumInteritemSpacing = 25
        layout.minimumLineSpacing = 25
        layout.sectionInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PuppyCollectionViewCell.self, forCellWithReuseIdentifier: PuppyCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
    }
}

extension CustomTransitionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PuppyCollectionViewCell.reuseIdentifier, for: indexPath) as! PuppyCollectionViewCell
        
        let puppy = puppies[indexPath.row]
        cell.puppy = puppy
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = CustomTransitionDetailViewController()
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PuppyCollectionViewCell
        detailVC.puppy = selectedCell.puppy
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension CustomTransitionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puppies.count
    }
}
