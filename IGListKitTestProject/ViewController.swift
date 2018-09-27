import UIKit
import IGListKit

class Post: ListDiffable {
    var id: String = ""
    var someNumber: Int
    
    init(id: String) {
        self.id = id
        self.someNumber = Int(arc4random_uniform(100))
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        return false //For the experiment
    }
}

class ViewController: UIViewController, ListAdapterDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var items: [Post] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(load), for: .valueChanged)
        return refresher
    }()

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return self.items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CustomSectionController(post: object as! Post)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return UIView()
    }
    
    @objc
    func load() {
        var objects: [Post] = []
        for i in 0..<3 {
            objects.append(Post(id: String(i)))
        }
        self.items = objects
        
        self.adapter.performUpdates(animated: true, completion: nil)
        self.refreshControl.endRefreshing()
    }

    lazy private var adapter: ListAdapter = {
        let updater = ListAdapterUpdater()
        let adapter = ListAdapter(updater: updater, viewController: self)
        adapter.collectionView = self.collectionView
        adapter.dataSource = self

        return adapter
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.refreshControl = self.refreshControl
    }
}

class CustomSectionController: ListSectionController {
    
    private var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 56)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = self.collectionContext?.dequeueReusableCell(withNibName: "CustomCollectionViewCell",
                                                               bundle: nil, for: self , at: index) as! CustomCollectionViewCell
        cell.text = String(self.post.someNumber)
        return cell
    }
}
