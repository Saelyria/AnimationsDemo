
import UIKit

class CollectionViewController: UIViewController {
    var animationController: ImageExpandAnimationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Puppies"
        self.view.backgroundColor = UIColor.white
        
        // making some gross frame/spacing calculations for iPhone 8 Plus, don't judge
        let layout = UICollectionViewFlowLayout()
        let cellDimension = self.view.frame.width/2 - 20
        layout.itemSize = CGSize(width: cellDimension, height: cellDimension)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PuppyCollectionViewCell.self, forCellWithReuseIdentifier: PuppyCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PuppyCollectionViewCell.reuseIdentifier, for: indexPath) as! PuppyCollectionViewCell
        
        let puppy = Puppy.allPuppies[indexPath.row]
        cell.puppy = puppy
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PuppyCollectionViewCell
        let detailVC = DetailViewController(puppy: selectedCell.puppy!)
        
        // Set the presenting view controller's style to 'custom', set its transitioning delegate to self,
        // and create a new animation transitioning object (in this case, the 'ImageExpandAnimationController'
        detailVC.modalPresentationStyle = .custom
        detailVC.transitioningDelegate = self
        self.animationController = ImageExpandAnimationController(listImage: selectedCell.imageView, detailImage: detailVC.imageView)
        
        self.present(detailVC, animated: true, completion: nil)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Puppy.allPuppies.count
    }
}

extension CollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animationController
    }
}

