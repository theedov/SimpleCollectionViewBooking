//
//  DayCell.swift
//  CollectionViewBooking
//
//  Created by Bogdan on 15/7/20.
//

import UIKit

class DayCell: UICollectionViewCell {
    // MARK: Outlets
    @IBOutlet weak var dayTxt: UILabel!
    @IBOutlet weak var monthYearTxt: UILabel!
    
    // MARK: Variables
    static let id = "DayCell"
    static let nib = UINib(nibName: id, bundle: nil)
    
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
    
    func configure(appointmentDay: AppointmentDay) {
        dayTxt.text = appointmentDay.dayPart
        monthYearTxt.text = appointmentDay.monthYearPart
    }
        
    private func cellSelection(_: Bool) {
        if isSelected == true {
            contentView.backgroundColor = .systemBlue
            dayTxt.textColor = .white
            monthYearTxt.textColor = .white
        } else {
            contentView.backgroundColor = .white
            dayTxt.textColor = .black
            monthYearTxt.textColor = .black
        }
    }
    
    private func updateView() {
        dayTxt.font = UIFont.preferredFont(forTextStyle: .title1)
        dayTxt.font = UIFont.boldSystemFont(ofSize: dayTxt.font.pointSize)
        monthYearTxt.font = UIFont.preferredFont(forTextStyle: .callout)
        
        layer.cornerRadius = 10
    }

}
