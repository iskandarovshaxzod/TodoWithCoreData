//
//  TodoDetailViewController.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    func initViews() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.backgroundColor = UIColor(named: "background")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension TodoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}
