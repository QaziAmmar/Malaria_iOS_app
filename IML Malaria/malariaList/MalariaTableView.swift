//
//  MalariaTableView.swift
//  IML Malaria
//
//  Created by Qazi Ammar Arshad on 10/04/2020.
//  Copyright © 2020 Neberox Technologies. All rights reserved.
//

import UIKit

class MalariaTableView: UIViewController {

    var malariaImage : [UIImage] = []
    var maConfidenceNo : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
//MARK:- UITableViewDelegate
extension MalariaTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return malariaImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MalariaTableViewCell
        cell.malariaImageView.image = malariaImage[indexPath.row]//UIImage(named: String(indexPath.row + 1))
        cell.confidenceLbl.text =   "Confidence No: \(maConfidenceNo[indexPath.row])" 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        144.0
    }
}
