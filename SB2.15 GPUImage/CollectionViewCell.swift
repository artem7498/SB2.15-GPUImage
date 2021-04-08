//
//  CollectionViewCell.swift
//  SB2.15 GPUImage
//
//  Created by Артём on 4/1/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterName: UILabel!
    
    func showIcon(){
        filterName.backgroundColor = .gray
    }
    
    func hideIcon(){
        filterName.backgroundColor = .none
    }
    
}
