//
//  SectionHeader.swift
//  CollectionViewBooking
//
//  Created by Bogdan on 15/7/20.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    @IBOutlet weak var titleTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleView()
    }

    func configure(title: String) {
        titleTxt.text = title
    }
    
    private func styleView() {
        titleTxt.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleTxt.font = UIFont.boldSystemFont(ofSize: titleTxt.font.pointSize)
    }
}
