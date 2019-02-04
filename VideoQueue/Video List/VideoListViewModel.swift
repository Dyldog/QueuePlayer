//
//  VideoListViewModel.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct VideoListViewModel {
	private let videoURLDefaultsKey = "VIDEO_URLS"
	private let jsonEncoder = JSONEncoder()
	private let jsonDecoder = JSONDecoder()
	
	private(set) var videoURLs: [URL] = []
	
	var numberOfVideoURLs: Int { return videoURLs.count }
	
	init() {
		retrieveURLsFromStorage()
	}
	
	mutating func addVideo(url: URL) {
		videoURLs.append(url)
		commitURLsToStorage()
	}
	
	mutating func removeVideo(at index: Int) {
		videoURLs.remove(at: index)
		commitURLsToStorage()
	}
	
	func titleForVideo(at index: Int) -> String {
		let url = videoURLs[index]
		
		return "\(url.host!)\(url.path)\(url.query ?? "")"
	}
	
	private func commitURLsToStorage() {
		let jsonEncoder = JSONEncoder()
		let videoURLData = try! jsonEncoder.encode(videoURLs)
		UserDefaults.standard.set(videoURLData, forKey: videoURLDefaultsKey)
	}
	
	private mutating func retrieveURLsFromStorage() {
		if let videoURLData = UserDefaults.standard.data(forKey: videoURLDefaultsKey) {
			videoURLs = try! jsonDecoder.decode([URL].self, from: videoURLData)
		}
	}
}
