//
//  URL+Extensions.swift
//  VideoQueue
//
//  Created by Dylan Elliott on 4/2/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

extension URL {
	private var videoExtensions: [String] {
		return ["wmv", "avi", "mkv", "rmvb", "rm", "xvid", "mp4", "3gp", "mpg"]
	}
	
	var isValidWebResource: Bool {
		return (self.host != nil)
	}
	
	var isYoutubeVideo: Bool {
		return self.host == "youtu.be" &&  self.path.count > 0
	}
	
	var isVideo: Bool {
		return videoExtensions.contains(self.pathExtension)
	}
	
	init?(string: String?) {
		guard let string = string, let url = URL(string: string) else { return nil }
		self = url
	}
}
