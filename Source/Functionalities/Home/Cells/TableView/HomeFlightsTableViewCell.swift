//
//  HomeFlightsTableViewCell.swift
//  Lufa
//
//  Created by Konrad Belzowski on 13/06/2019.
//  Copyright © 2019 Konrad Belzowski. All rights reserved.
//

import Foundation
import UIKit

class HomeFlightsTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flights: [Flight] = []
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "HomeFlightCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "HomeFlightCollectionViewCell")
    }
    
    //MARK: Data
    func setFlights(withFlights: [Flight]) {
        flights = withFlights
        
        collectionView.reloadData()
    }
}

extension HomeFlightsTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeFlightsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFlightCollectionViewCell", for: indexPath) as? HomeFlightCollectionViewCell
        
        guard let collectionCell = cell else {
            return UICollectionViewCell()
        }
        
        collectionCell.loadWithData(flight: flights[indexPath.row])
        
        return collectionCell
    }
}
