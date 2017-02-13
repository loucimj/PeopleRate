//
//  PeopleCollectionViewController.swift
//  PeopleRate
//
//  Created by Javier Loucim on 2/11/17.
//  Copyright © 2017 Javier Loucim. All rights reserved.
//

import UIKit

struct Person {
    var imageName:String = "" {
        didSet {
            image = UIImage(named: imageName)
        }
    }
    var name:String = ""
    var image:UIImage? {
        didSet {
            if let colors = image?.getColors() {
                shadowColor = colors.primaryColor
            }
        }
    }
    var shadowColor: UIColor?
    
    init(imageName: String, name:String) {
        self.name = name
        self.imageName = imageName
        self.image = UIImage(named: imageName)
        if let colors = image?.getColors() {
            shadowColor = colors.primaryColor
        }
    }
}

class PeopleCollectionViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var people: Array<Person> = Array<Person>()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PersonCollectionViewCell.self)
        
        
        people.append(Person(imageName: "img1", name: "ABIGAIL SPONDER"))
        people.append(Person(imageName: "item5", name: "Guibert Englebienne"))
        people.append(Person(imageName: "item6", name: "Martin Migoya"))
        people.append(Person(imageName: "item7", name: "Axel Abufalia"))
        people.append(Person(imageName: "item8", name: "Ignacio Peña"))
        people.append(Person(imageName: "item0", name: "Marcos Buricchi"))
        people.append(Person(imageName: "item1", name: "Dario Lanati"))
        people.append(Person(imageName: "item2", name: "Lucrecia Fernandez"))
        people.append(Person(imageName: "item3", name: "Manuel Gomez D'Hers"))
        people.append(Person(imageName: "item4", name: "Javier Loucim"))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
}
extension PeopleCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PersonCollectionViewCell
    
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let myCell = cell as! PersonCollectionViewCell
        let person = people[indexPath.row]
        
        myCell.profileImageView.image = person.image
        if let color = person.shadowColor {
            myCell.profileImageView.layer.shadowColor = color.cgColor
            myCell.profileImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
            myCell.profileImageView.layer.shadowRadius = 10
            myCell.profileImageView.layer.shadowOpacity = 1
        }
        

        myCell.nameLabel.text = person.name.uppercased()
    }

}

extension PeopleCollectionViewController: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }

}

extension PeopleCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView!.frame.size.width, height: self.collectionView!.frame.size.height)
    }
}

extension UICollectionView {
    
    typealias ViewableCellPercentage = (cell:UICollectionViewCell, percentage:CGFloat)
    
    enum ScrollDirection {
        case next, previous
    }
    
    enum CellPosition: Int {
        case PreviousUnderflow = -1
        case Previous = 0
        case Current = 1
        case Next = 2
        case NextOverflow = 3
        
        var isUnderOverflow: Bool {
            return [.NextOverflow, .PreviousUnderflow].contains(self)
        }
    }
    /// Computed variable for the collection view's width, or zero if nil.
    var collectionViewWidth: CGFloat {
        return self.frame.width 
    }
    
    /// Computed variable for the amount the user has dragged. Has a range of (-1...0...1).
    /// Resting state is zero, -1 is dragging to the previous lot, and vice versa for the next.
    var ratioDragged: CGFloat {
        return (self.contentOffset.x) / collectionViewWidth
    }
    /// Computed variable for the direction the user is dragging.
    var userScrollDirection: ScrollDirection { return ratioDragged > 0 ? .next : .previous }
    
    var isScrolling: Bool {
        return ratioDragged.truncatingRemainder(dividingBy: 1) == 0
    }
    
    
    var viewableCellsPercentage: Array<ViewableCellPercentage>? {
        guard self.visibleCells.count != 0 else {
            return nil
        }
        var result = Array<ViewableCellPercentage>()
        
        
        for cell in self.visibleCells {
            //analyze horizontal
            let percentage:CGFloat = 1 - (abs(self.contentOffset.x - cell.frame.origin.x)/cell.frame.width)
            //TODO: analyze vertical
            
            result.append(ViewableCellPercentage(cell: cell, percentage: percentage))
        }
        return result
        
    }
}

extension PeopleCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let viewableCells = collectionView.viewableCellsPercentage {
            var index = 0
            for item in viewableCells {
                let myCell = item.cell as! PersonCollectionViewCell
                
                let direction = collectionView.userScrollDirection
                print(direction)
                
                if direction == .next {
                    myCell.animateWithPercentage(percentage: item.percentage, direction: (index == 0 ? .leaving : .entering ))
                }
                if direction == .previous {
                    myCell.animateWithPercentage(percentage: item.percentage, direction: (index == 0 ? .entering : .leaving ))
                }
                index += 1
            }
        }
        
    }
}
