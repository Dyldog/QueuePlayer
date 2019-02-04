//
//  VideoURLPlayerController.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit
import AVKit

class VideoURLPlayerViewController: AVPlayerViewController {
	
	var onItemDidFinish: ((URL) -> ())?
	var onQueueDidFinish: (() -> ())?
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
	init(urls: [URL]) {
		super.init(nibName: nil, bundle: nil)
		set(urls: urls)
	}
	
	func set(urls: [URL]) {
		// Items
		let items = urls.map { AVPlayerItem(url: $0) }
		items.forEach { addDidEndNotification(for: $0) }
		
		// Player
		self.player = AVQueuePlayer(items: items)
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
		
		onItemDidFinish?(asset.url)
		
		let player = self.player as! AVQueuePlayer
		
		if player.items().count == 1 { // It will still contain the item that just finished
			onQueueDidFinish?()
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
