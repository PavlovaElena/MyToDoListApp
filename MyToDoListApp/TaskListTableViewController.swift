//
//  TaskListTableViewController.swift
//  MyToDoListApp
//
//  Created by Елена Павлова on 01.05.2022.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
       
    }
    
}

