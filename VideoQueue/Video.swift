//
//  Video.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation
import XCDYouTubeKit

class Video: Codable {
	
	let url: URL
	
	init(url: URL) {
		self.url = url
	}
	
	func retrieveFinalURL(_ completion: @escaping (URL) -> ()) {
		 completion(url)
	}
	
	
}

extension Video: Comparable {
	static func < (lhs: Video, rhs: Video) -> Bool {
		return lhs.url.absoluteString < rhs.url.absoluteString
	}
	
	static func == (lhs: Video, rhs: Video) -> Bool {
		return lhs.url == rhs.url
	}
}

class YoutubeVideo: Video {
	override func retrieveFinalURL(_ completion: @escaping (URL) -> ()) {
		let youtubeID = url.path.replacingOccurrences(of: "/", with: "")
		XCDYouTubeClient.default().getVideoWithIdentifier(youtubeID) { video, error in
			completion(video!.streamURLs.values.randomElement()!)
		}
	}
}
