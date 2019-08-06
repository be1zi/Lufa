//
//  HomeFlightsTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 13/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

protocol HomeFlightsTableViewDelegate {
    
    func collectionViewElementSelected(atIndex index: IndexPath, type: HomeCellType)
}

class HomeFlightsTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flights: [Flight] = []
    var delegate: HomeFlightsTableViewDelegate?
    var type: HomeCellType?
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "HomeFlightCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "HomeFlightCollectionViewCell")
        collectionView.register(UINib(nibName: "HomeNoDataCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "HomeNoDataCollectionViewCell")
    }
    
    // MARK: Data
    func setData(withFlights: [Flight], andDelegate: HomeFlightsTableViewDelegate, andType: HomeCellType) {
        flights = withFlights
        delegate = andDelegate
        type = andType
        
        collectionView.reloadData()
    }
}

extension HomeFlightsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let delegate = delegate, let type = type, flights.count > 0 {
            delegate.collectionViewElementSelected(atIndex: indexPath, type: type)
        }
    }
}

extension HomeFlightsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flights.count > 0 ? flights.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch flights.count {
        case (let x) where x > 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFlightCollectionViewCell", for: indexPath) as? HomeFlightCollectionViewCell
            
            guard let collectionCell = cell else {
                return UICollectionViewCell()
            }
            
            collectionCell.loadWithData(flight: flights[indexPath.row])
            
            return collectionCell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeNoDataCollectionViewCell", for: indexPath)
            
            return cell
        }
    }
}
