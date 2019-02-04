//
//  VideoListViewModel.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct VideoListViewModel {
	private(set) var videoURLs: [URL] = []
	
	var numberOfVideoURLs: Int { return videoURLs.count }
	
	mutating func addVideo(url: URL) {
		videoURLs.append(url)
	}
	
	mutating func removeVideo(at index: Int) {
		videoURLs.remove(at: index)
	}
	
	func titleForVideo(at index: Int) -> String {
		let url = videoURLs[index]
		
		return "\(url.host!)\(url.path)\(url.query ?? "")"
	}
}
