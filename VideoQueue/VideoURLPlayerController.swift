//
//  VideoURLPlayerController.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class VideoURLPlayerViewController: AVPlayerViewController {
	
	var onItemDidFinish: ((URL) -> ())?
	var onQueueDidFinish: (() -> ())?
	
	var urlQueue: [URL] = []
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	init(urls: [URL]) {
		super.init(nibName: nil, bundle: nil)
		
		urlQueue = urls
		loadNextVideo()
	}
	
	private func loadNextVideo() {
		let nextURL = urlQueue[0]

		if nextURL.isYoutubeVideo {
			let youtubeID = nextURL.path.replacingOccurrences(of: "/", with: "")
			XCDYouTubeClient.default().getVideoWithIdentifier(youtubeID) { video, error in
				self.setCurrentVideoURL(url: video!.streamURLs.values.randomElement()!)
			}
		} else {
			setCurrentVideoURL(url: nextURL)
		}
	}
	
	private func setCurrentVideoURL(url: URL) {
		let playerItem = AVPlayerItem(url: url)
		addDidEndNotification(for: playerItem)
		self.player = AVPlayer(playerItem: playerItem)
		player?.play()
	}
	
	// MARK: - Notifications
	
	private func addDidEndNotification(for playerItem: AVPlayerItem) {
		NotificationCenter.default.addObserver(self, selector: #selector(videoDidFinishPlaying(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
	}
	
	private func removeDidEndNotification(for playerItem: Any?) {
		NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
	}
	
	@objc private func videoDidFinishPlaying(notification: NSNotification) {
		removeDidEndNotification(for: notification.object)
		
		let item = notification.object as! AVPlayerItem
		let asset = item.asset as! AVURLAsset
		
		let finishedURL = urlQueue[0]
		
		onItemDidFinish?(finishedURL)
		
		urlQueue.remove(at: 0)
		
		if urlQueue.count == 0 { // It will still contain the item that just finished
			onQueueDidFinish?()
		} else {
			loadNextVideo()
			player?.play()
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
