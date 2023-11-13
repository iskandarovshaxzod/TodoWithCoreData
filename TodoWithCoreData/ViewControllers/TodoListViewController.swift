//
//  TodoListViewController.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//

import UIKit

class TodoListViewController: UIViewController {
    
    let context = CoreDataManager.shared.container.viewContext
    
    let type: TodoType
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var uncheckedTodos = [Todo]()
    var checkedTodos   = [Todo]()
    
    init(type: TodoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        initViews()
        fetchAllTodos()
    }
    
    
    
    func configureNavBar() {
        
        let menuItems = [
            UIAction(title: "Name", image: UIImage(systemName: "pencil.circle"), handler: { _ in }),
            UIAction(title: "Date", image: UIImage(systemName: "calendar.badge.clock"), handler: { _ in })
        ]
        let sortButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"),
                                         primaryAction: nil,
                                         menu: UIMenu(title: "SORT BY", children: menuItems))
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(addBarButtonItemTapped))
        navigationItem.rightBarButtonItems = [plusButton, sortButton]
        
        navigationItem.title = "Types"
    }
    
    func initViews() {
        title = type.name
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(named: "background")
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func addBarButtonItemTapped() {
        let alert = UIAlertController(title: "New Todo", message: "Add new Todo", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Add",    style: .default, handler: { [weak self, weak alert] _ in
            guard let text = alert?.textFields?.first?.text, !text.isEmpty else { return }
            self?.saveNewTodo(name: text)
        }))
        present(alert, animated: true)
    }
    
    func fetchAllTodos() {
        do {
            checkedTodos   = try context.fetch(Todo.fetchAllCheckedTodos(of: type))
            uncheckedTodos = try context.fetch(Todo.fetchAllUncheckedTodos(of: type))
            updateTable()
        } catch {
            print(error)
        }
    }
    
    func saveNewTodo(name: String) {
        do {
            try Todo.saveNewTodo(title: name, type: type, with: context)
            fetchAllTodos()
        } catch {
            print(error)
        }
    }
    
    func deleteTodo(at indexPath: IndexPath) {
        let todo: Todo
        if indexPath.section == 0 {
            todo = uncheckedTodos[indexPath.row]
        } else {
            todo = checkedTodos[indexPath.row]
        }
        
        do {
            try Todo.deleteTodo(todo: todo, with: context)
            fetchAllTodos()
        } catch {
            print(error)
        }
    }
    
    func makeTodoChecked(at indexPath: IndexPath) {
        let todo = uncheckedTodos[indexPath.row]
        do {
            try Todo.makeTodoChecked(todo: todo, with: context)
            fetchAllTodos()
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

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0 ? "Unchecked" : "Checked")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? uncheckedTodos.count : checkedTodos.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "x.circle"))
            cell.textLabel?.text = uncheckedTodos[indexPath.row].title
            cell.detailTextLabel?.text = "\(uncheckedTodos[indexPath.row].date)"
        } else {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
            cell.textLabel?.text = checkedTodos[indexPath.row].title
            cell.detailTextLabel?.text = "\(checkedTodos[indexPath.row].date)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completed) in
            self?.deleteTodo(at: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 0 {
            let markButton = UIContextualAction(style: .normal, title: "Mark Checked") { [weak self] (action, view, completed) in
                self?.makeTodoChecked(at: indexPath)
            }
            markButton.backgroundColor = .systemYellow
            return UISwipeActionsConfiguration(actions: [markButton])
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
