//
//  Extension + UITableViewCell.swift
//  MyToDoListApp
//
//  Created by Елена Павлова on 10.05.2022.
//

import UIKit

extension UITableViewCell {
    func configure(with task: Task) {
        var content = defaultContentConfiguration()
        
        content.text = task.title
        
        if task.isImportantTask {
            content.image = UIImage(systemName: "exclamationmark")
            content.imageProperties.tintColor = .systemPink
        }
        if task.isDone {
            content.image = UIImage(systemName: "checkmark.circle")
            content.imageProperties.tintColor = .systemGreen
        }
        
        contentConfiguration = content
    }
}
