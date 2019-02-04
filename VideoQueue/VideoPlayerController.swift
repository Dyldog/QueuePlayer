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

class VideoPlayerViewController: AVPlayerViewController {
	
	var onItemDidFinish: ((Video) -> ())?
	var onQueueDidFinish: (() -> ())?
	
	var videoQueue: [Video] = []
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	init(videos: [Video]) {
		super.init(nibName: nil, bundle: nil)
		
		videoQueue = videos
		loadNextVideo()
	}
	
	private func loadNextVideo() {
		let nextVideo = videoQueue[0]
		
		nextVideo.retrieveFinalURL { url in
			let playerItem = AVPlayerItem(url: url)
			self.addDidEndNotification(for: playerItem)
			self.player = AVPlayer(playerItem: playerItem)
			self.player?.play()
		}
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

		let finishedVideo = videoQueue[0]
		videoQueue.remove(at: 0)
		
		onItemDidFinish?(finishedVideo)
		
		if videoQueue.count == 0 {
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
