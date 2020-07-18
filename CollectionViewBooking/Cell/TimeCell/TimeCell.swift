//
//  TimeCell.swift
//  CollectionViewBooking
//
//  Created by Bogdan on 15/7/20.
//

import UIKit

class TimeCell: UICollectionViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var timeTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateView()
    }
    
    override var isSelected: Bool {
        didSet {
            cellSelection(isSelected)
        }
    }
    
    func configure(appointmentTime: AppointmentTime) {
        timeTxt.text = appointmentTime.time
    }
    
    func cellSelection(_: Bool) {
        if isSelected == true {
            contentView.backgroundColor = .systemBlue
            timeTxt.textColor = .white
        } else {
            contentView.backgroundColor = .white
            timeTxt.textColor = .black
        }
    }
    
    private func updateView() {
        timeTxt.font = UIFont.preferredFont(forTextStyle: .body)
        
        layer.cornerRadius = 10
    }

}
