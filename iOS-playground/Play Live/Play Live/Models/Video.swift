//
//  Video.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import Foundation
import AVFoundation

class Video: Codable {
    let id: Int
    let userID: Int
    let username: String
    let profilePicURL: String
    let description: String
    let topic: String
    let viewers: Int
    let likes: Int
    let video: String
    let thumbnail: String
    
    var videoPlayer: AVPlayer?
    
    private enum CodingKeys: String, CodingKey {
        case id, userID, username, profilePicURL, description, topic, viewers, likes, video, thumbnail
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.userID = try container.decode(Int.self, forKey: .userID)
        self.username = try container.decode(String.self, forKey: .username)
        self.profilePicURL = try container.decode(String.self, forKey: .profilePicURL)
        self.description = try container.decode(String.self, forKey: .description)
        self.topic = try container.decode(String.self, forKey: .topic)
        self.viewers = try container.decode(Int.self, forKey: .viewers)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.video = try container.decode(String.self, forKey: .video)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        
        if let url = URL(string: video) {
            self.videoPlayer = AVPlayer(url: url)
        }
    }

    var isPlaying = false
    
    func play() {
        isPlaying = true
        videoPlayer?.play()
        videoPlayer?.isMuted = false
        videoPlayer?.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer?.currentItem)
    }
    
    func pause() {
        isPlaying = false
        videoPlayer?.pause()
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: videoPlayer?.currentItem)
    }
    
    @objc private func playerItemDidReachEnd() {
        // Loop the video when it ends
        videoPlayer?.seek(to: .zero)
        videoPlayer?.play()
    }
}
