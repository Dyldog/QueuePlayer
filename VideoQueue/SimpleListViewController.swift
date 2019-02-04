//
//  SimpleListViewController.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class SimpleListViewController: UITableViewController {
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellID = "CELL"
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID) ?? UITableViewCell(style: .default, reuseIdentifier: cellID)
		
		cell.textLabel?.text = self.tableView(tableView, titleForRowAt: indexPath)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, titleForRowAt indexPath: IndexPath) -> String {
		fatalError()
	}
}
