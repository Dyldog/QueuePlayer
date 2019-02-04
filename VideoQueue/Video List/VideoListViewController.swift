//
//  ViewController.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class VideoListViewController: SimpleListViewController {
	
	var viewModel = VideoListViewModel()
	
	var testVideoURLs = [
		URL(string: "http://incident.net/v8/files/mp4/9.mp4")!,
		URL(string: "http://www.jeremystreliski.com/IMG/mp4/2011_Alvalle_0_13_.mp4")!
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonTapped))
		
		if viewModel.numberOfVideoURLs == 0 {
			testVideoURLs.forEach { viewModel.addVideo(url: $0) }
		}
	}
	
	// MARK: - Tableview
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfVideoURLs
	}
	
	override func tableView(_ tableView: UITableView, titleForRowAt indexPath: IndexPath) -> String {
		return viewModel.titleForVideo(at: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			viewModel.removeVideo(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	
	// MARK: Bar Button Actions
	
	@objc private func addButtonTapped() {
		presentAddVideoAlert(nil)
	}
	
	@objc private func playButtonTapped() {
		presentPlayer(for: viewModel.videoURLs)
	}
}

// MARK: - Adding

extension VideoListViewController {
	
	private func presentAddVideoAlert(_ textfieldValue: String?) {
		let alert = UIAlertController(title: "Add Video", message: nil, preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = "Video URL"
			textField.text = textfieldValue
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
			let enteredString = alert.textFields![0].text
			
			guard let videoURL = URL(string: enteredString), videoURL.isValidWebResource else {
				self.presentInvalidURLAlert(onOK: { _ in self.presentAddVideoAlert(enteredString) })
				return
			}
			
			guard videoURL.isVideo else {
				self.presentURLNotVideoAlert(onOK: { _ in self.presentAddVideoAlert(enteredString) })
				return
			}
			
			self.viewModel.addVideo(url: videoURL)
			self.tableView.reloadData()
		}))
		
		present(alert, animated: true, completion: nil)
	}
	
	private func presentInvalidURLAlert(onOK: ((UIAlertAction) -> ())?) {
		let alert = UIAlertController(title: "Invalid URL", message: "Please enter a valid URL", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: onOK))
		present(alert, animated: true, completion: nil)
	}
	
	private func presentURLNotVideoAlert(onOK: ((UIAlertAction) -> ())?) {
		let alert = UIAlertController(title: "URL is not a video", message: "Please ensure you have the correct URL", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: onOK))
		present(alert, animated: true, completion: nil)
	}
}

// MARK: - Playing

extension VideoListViewController {
	
	private func presentPlayer(for urls: [URL]) {
		var playerURLs = urls
		
		let playerViewController: VideoURLPlayerViewController = VideoURLPlayerViewController(urls: playerURLs)
		
		playerViewController.onItemDidFinish = { url in
			print("Video did finish playing: \(url)")
			
			guard let videoIndex = playerURLs.firstIndex(where: { $0 == url }) else {
				print("ERROR: Tried to remove video with URL \(url), but URL is not in queue")
				return
			}
			
			playerURLs.remove(at: videoIndex)
			
			print("\(playerURLs.count) videos remaining in queue")
		}
		
		playerViewController.onQueueDidFinish = {
			playerViewController.dismiss(animated: true, completion: nil)
		}
		
		// Present
		present(playerViewController, animated: true, completion: {
			playerViewController.player?.play()
		})
	}
}
