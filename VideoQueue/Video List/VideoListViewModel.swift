//
//  VideoListViewModel.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

struct VideoListViewModel {
	private let videoDefaultsKey = "VIDEOS"
	private let jsonEncoder = JSONEncoder()
	private let jsonDecoder = JSONDecoder()
	
	private(set) var videos: [Video] = []
	
	init() {
		retrieveURLsFromStorage()
	}
	
	mutating func addVideo(video: Video) {
		videos.append(video)
		commitVideosToStorage()
	}
	
	mutating func removeVideo(at index: Int) {
		videos.remove(at: index)
		commitVideosToStorage()
	}
	
	func titleForVideo(at index: Int) -> String {
		let url = videos[index].url
		return "\(url.host!)\(url.path)\(url.query ?? "")"
	}
	
	private func commitVideosToStorage() {
		let jsonEncoder = JSONEncoder()
		let videoData = try! jsonEncoder.encode(videos)
		UserDefaults.standard.set(videoData, forKey: videoDefaultsKey)
	}
	
	private mutating func retrieveURLsFromStorage() {
		if let videoData = UserDefaults.standard.data(forKey: videoDefaultsKey) {
			videos = try! jsonDecoder.decode([Video].self, from: videoData)
		}
	}
}
