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
}

// MARK: - UITableViewDataSource
extension TaskListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - Alert Controller
extension TaskListTableViewController {
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update task" : "New Task"
        let alert = UIAlertController.createAlertController(withTitle: title)
        
        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                completion()
            } else {
                print(taskName)
            }
        }
        
        present(alert, animated: true)
    }
}
