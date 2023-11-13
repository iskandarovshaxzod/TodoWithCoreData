//
//  TypeViewController.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//

import UIKit

class TypeViewController: UIViewController {
    
    let context = CoreDataManager.shared.container.viewContext
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var types = [TodoType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        initViews()
        fetchAllTypes()
    }
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(rightBarButtonItemTapped))
        navigationItem.title = "Types"
    }

    func initViews() {
        view.addSubview(tableView)
        tableView.frame      = view.bounds
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "background")
    }
    
    @objc func rightBarButtonItemTapped() {
        let alert = UIAlertController(title: "New Type", message: "Add new Todo Type", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Add",    style: .default, handler: { [weak self, weak alert] _ in
            guard let text = alert?.textFields?.first?.text, !text.isEmpty else { return }
            self?.saveNewType(name: text)
        }))
        present(alert, animated: true)
    }
    
    func saveNewType(name: String) {
        do {
            try TodoType.saveNewType(type: name, with: context)
            fetchAllTypes()
        } catch {
            print(error)
        }
    }
    
    func fetchAllTypes() {
        do {
            types = try context.fetch(TodoType.fetchAllTypes())
            updateTable()
        } catch {
            print(error)
        }
    }
    
    func deleteType(at indexPath: IndexPath) {
        let type = types[indexPath.section]
        do {
            try TodoType.deleteType(type: type, with: context)
            fetchAllTypes()
        } catch {
            print(error)
        }
    }
    
    func updateTable() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

}

extension TypeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text       = types[indexPath.section].name
        cell.detailTextLabel?.text = "\(types[indexPath.section].todosCount) todos"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completed) in
            self?.deleteType(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = types[indexPath.section]
        navigationController?.pushViewController(TodoListViewController(type: type), animated: true)
    }
}
