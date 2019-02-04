//
//  ViewController.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var testVideoURLs = [
		URL(string: "http://incident.net/v8/files/mp4/9.mp4")!,
		URL(string: "http://www.jeremystreliski.com/IMG/mp4/2011_Alvalle_0_13_.mp4")!
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(playButtonTapped))
	}
	
	@objc private func playButtonTapped() {
		presentPlayer(for: testVideoURLs)
	}
	
	private func presentPlayer(for urls: [URL]) {
		let playerViewController: VideoURLPlayerViewController = VideoURLPlayerViewController(urls: testVideoURLs)
		
		var playerURLs = urls
		
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
