//
//  HistoryViewController.swift
//  SliderGame
//
//  Created by Shakutara on 10/22/19.
//  Copyright © 2019 Shakutara. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Initalization
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var historyResponses = [HistoryResponse]()
    
    override func viewDidLoad() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        loadHistoryList()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyResponses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as? HistoryTableViewCell else {
            fatalError("The dequeued cell is not an instance of HistoryTableViewCell.")
        }
        let history = historyResponses[indexPath.row]
        cell.playerNameLabel.text = history.player_name
        cell.playerDateLabel.text = String(history.player_date)
        return cell
    }
    
    //MARK: Actions
    @IBAction func backButtonClick(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Private methods
    private func loadHistoryList() {
        AF.request("https://api.myjson.com/bins/ujs2k", method: .get).validate().response { (response) in
            do {
                let res = try JSONDecoder().decode(Array<HistoryResponse>.self, from: response.data!)
                self.historyResponses.append(contentsOf: res)
                self.historyTableView.reloadData()
            } catch let error {
                print(error)
            }
            debugPrint(response)
        }
    }
}
