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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonTapped))
		
		let testVideos = [
			YoutubeVideo(url: URL(string: "https://youtu.be/7-w6c-ybwXk")!),
			Video(url: URL(string: "http://incident.net/v8/files/mp4/9.mp4")!),
			Video(url: URL(string: "http://www.jeremystreliski.com/IMG/mp4/2011_Alvalle_0_13_.mp4")!)
		]
		
		if viewModel.videos.count == 0 {
			testVideos.forEach { viewModel.addVideo(video: $0) }
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}
	
	// MARK: - Tableview
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.videos.count
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
		presentPlayer(for: viewModel.videos)
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
			self.userDidEnterVideoURL(urlString: alert.textFields![0].text)
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
	
	private func userDidEnterVideoURL(urlString: String?) {
		guard let videoURL = URL(string: urlString), videoURL.isValidWebResource else {
			self.presentInvalidURLAlert(onOK: { _ in self.presentAddVideoAlert(urlString) })
			return
		}
		
		guard videoURL.isVideo else {
			self.presentURLNotVideoAlert(onOK: { _ in self.presentAddVideoAlert(urlString) })
			return
		}
		
		if videoURL.isYoutubeVideo {
			self.viewModel.addVideo(video: YoutubeVideo(url: videoURL))
		} else {
			self.viewModel.addVideo(video: Video(url: videoURL))
		}
		
		self.tableView.reloadData()
	}
}

// MARK: - Playing

extension VideoListViewController {
	
	private func presentPlayer(for videos: [Video]) {
		let playerViewController: VideoPlayerViewController = VideoPlayerViewController(videos: videos)
		
		playerViewController.onItemDidFinish = { video in
			let videoIndex = self.viewModel.videos.firstIndex(where: { $0 == video })!
			self.viewModel.removeVideo(at: videoIndex)
		}
		
		playerViewController.onQueueDidFinish = {
			playerViewController.dismiss(animated: true, completion: nil)
		}
		
		// Present
		present(playerViewController, animated: true, completion: nil)
	}
}
