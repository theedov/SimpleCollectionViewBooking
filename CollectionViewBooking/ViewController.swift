//
//  ViewController.swift
//  CollectionViewBooking
//
//  Created by Bogdan on 15/7/20.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedDateTxt: UILabel!
    
    //MARK: Variables
    private var appointmentDays = [AppointmentDay]()
    private var appointmentTimes = [AppointmentTime]()
    private var selectedDate = AppointmentDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAvailableDates()
        configureCollectionView()
        
        printSelectedDate()
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(UINib(nibName: "DayCell", bundle: nil), forCellWithReuseIdentifier: "DayCell")
        collectionView.register(UINib(nibName: "TimeCell", bundle: nil), forCellWithReuseIdentifier: "TimeCell")
        collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
    }
    
    func printSelectedDate() {
        selectedDateTxt.text = "\(selectedDate.day ?? "Date not selected;") \(selectedDate.time ?? "Time not selected;")"
    }
    
    // MARK: START - CollectionView Layout
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.createCollectionDaysSection()
            case 1:
                return self.createCollectionTimesSection()
            default:
                return self.createCollectionDaysSection()
            }
        }
    }
    
    func createCollectionDaysSection() -> NSCollectionLayoutSection {
        //Define item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //Configure item
        item.contentInsets.trailing = 8
        
        //Define group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //Create section
        let section = NSCollectionLayoutSection(group: group)
        
        //Configure section
        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .continuous
        
        //Configure header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        section.boundarySupplementaryItems = [
            .init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        
        return section
    }
    
    func createCollectionTimesSection() -> NSCollectionLayoutSection {
        //Define item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //Configure item
        item.contentInsets.trailing = 8
        
        //Define group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(45))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //Create section
        let section = NSCollectionLayoutSection(group: group)
        
        //Configure section
        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .continuous
        
        //Configure header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        section.boundarySupplementaryItems = [
            .init(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        
        return section
    }
    // MARK: END - CollectionView Layout
    
    func getAvailableDates() {
        RESTful.request(path: "https://dovgopol.dev/api/testApi", method: "GET", parameters: nil, headers: nil) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result {
            
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    self.appointmentDays = try decoder.decode([AppointmentDay].self, from: data)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch(let error) {
                    debugPrint(error)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return appointmentDays.count
        case 1: return appointmentTimes.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
            cell.configure(appointmentDay: appointmentDays[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCell
            cell.configure(appointmentTime: appointmentTimes[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //Allow to select only 1 cell per section
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: true) })
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let date = appointmentDays[indexPath.row]
            
            appointmentTimes = date.times
            collectionView.reloadSections(IndexSet(integer: 1))
            
            //Save selected day
            selectedDate.day = date.day
            selectedDate.time = nil
        case 1:
            //Save selected time
            selectedDate.time = appointmentTimes[indexPath.row].time
        default: break
        }
        
        printSelectedDate()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            switch indexPath.section {
            case 0:
                header.configure(title: "Date")
            case 1:
                header.configure(title: "Time")
            default: break
            }
            return header
            
        default: return UICollectionReusableView()
        }
    }
}

