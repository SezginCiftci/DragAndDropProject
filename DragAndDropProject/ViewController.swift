//
//  ViewController.swift
//  DragAndDropProject
//
//  Created by Sezgin Çiftci on 26.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    fileprivate var items: [String] = [
        "resim 1",
        "resim 2",
        "resim 3",
        "resim 4",
        "resim 5",
        "resim 6",
        "resim 7"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "Drag & Drop"
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collection.backgroundColor = .white
        view.addSubview(collection)
        
        collection.delegate = self
        collection.dataSource = self
        collection.dragDelegate = self
        collection.dragInteractionEnabled = true
        collection.dropDelegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        collection.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    }
    fileprivate func reorderItem(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates {
                self.items.remove(at: sourceIndexPath.item)
                self.items.insert(item.dragItem.localObject as! String, at: destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            } completion: { _ in
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}

extension ViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        
        if coordinator.proposal.operation == .move {
            reorderItem(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
}

extension ViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let square = (collectionView.frame.width-8) / 3
        return CGSize(width: square, height: square)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath)
        cell.backgroundColor = .white
        print(indexPath)
        let image = UIImage(named: self.items[indexPath.row])
        let cellImage = UIImageView(image: image)
        cellImage.contentMode = .scaleAspectFit
        cell.contentView.addSubview(cellImage)
        cell.contentView.clipsToBounds = true
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 4).isActive = true
        cellImage.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -4).isActive = true
        cellImage.leadingAnchor .constraint(equalTo: cell.contentView.leadingAnchor, constant: 4).isActive = true
        cellImage.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -4).isActive = true
        
        
        return cell
    }
}

