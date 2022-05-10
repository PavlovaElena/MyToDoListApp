//
//  TaskListTableViewController.swift
//  MyToDoListApp
//
//  Created by Елена Павлова on 01.05.2022.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    private let cellID = "Task"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        fetchData()
    }
    
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        
        let colorSetting = UINavigationBarAppearance()
        colorSetting.backgroundColor = UIColor(red: 102/255, green: 212/255, blue: 207/255, alpha: 1)
        colorSetting.titleTextAttributes = [.foregroundColor: UIColor.white]
        colorSetting.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = colorSetting
        navigationController?.navigationBar.scrollEdgeAppearance = colorSetting
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
    
    private func save(taskName: String) {
        StorageManager.shared.save(taskName) { task in
            taskList.append(task)
            tableView.insertRows(
                at: [IndexPath(row: taskList.count - 1, section: 0)],
                with: .automatic
            )
        }
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let tasks):
                taskList = tasks
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TaskListTableViewController {
    
    //Edit status of task
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = taskList[indexPath.row]
        
        let done = createAction(
            for: task.isDone,
            at: indexPath,
            title: "Done",
            colorIfTrue: .systemGreen,
            image: "checkmark.circle") {
                StorageManager.shared.editDoneStatus(task, newDoneStatus: !task.isDone)
            }
        
        let importantTask = createAction(
            for: task.isImportantTask,
            at: indexPath,
            title: "Important",
            colorIfTrue: .systemPink,
            image: "exclamationmark.circle") {
                StorageManager.shared.editImportantMarker(task, newImportantMarker: !task.isImportantTask)
            }
        
        return UISwipeActionsConfiguration(actions: [done, importantTask])
    }
    
    // Edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = taskList[indexPath.row]
        showAlert(task: task) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        
        if editingStyle == .delete {
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(task)
        }
    }
}

// MARK: - Private methods
extension TaskListTableViewController {
    private func createAction(
        for typeAction: Bool,
        at indexPath: IndexPath,
        title: String,
        colorIfTrue: UIColor,
        image: String,
        completion: @escaping () -> Void) -> UIContextualAction {
            
            let action = UIContextualAction(style: .destructive, title: title) { [unowned self] _, _, actionCompleted in
                completion()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                actionCompleted(true)
            }
            action.backgroundColor = typeAction ? colorIfTrue : .systemGray
            action.image = UIImage(systemName: image)
            return action
        }
    
    // Alert Controller
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update task" : "New Task"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.editTitleTask(task, newName: taskName)
                completion()
            } else {
                self?.save(taskName: taskName)
            }
        }
        
        present(alert, animated: true)
    }
}
