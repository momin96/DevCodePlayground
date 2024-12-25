//
//  StreamingViewModel.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import Foundation
import Combine
import AVFoundation

// MARK: - ViewModel

class StreamingViewModel {
    private let service: StreamingService
    var videos: [Video] = []
    var comments: [Comment] = []
    
    var reloadPublisher = PassthroughSubject<Void, Never>()

    init(service: StreamingService) {
        self.service = service
    }

    func fetchVideos() async throws {
        let videos = try await service.fetchVideos().videos
        self.videos.append(contentsOf: videos)
        reloadPublisher.send()
    }

    func fetchComments() async throws {
        self.comments = try await service.fetchComments().comments
    }
    
    func playVideo(On indexPath: IndexPath) {
        
        let currentIndex = indexPath.row
        
        // Get the current video
        let currentVideo = videos[currentIndex]
        currentVideo.play()
        
        // Safely calculate the previous & next index
        if let previousIndex = currentIndex > 0 ? currentIndex - 1 : nil {
            let path = IndexPath(row: previousIndex, section: 0)
            pauseVideo(On: path)
        }
        
        if let nextIndex = currentIndex < videos.count - 1 ? currentIndex + 1 : nil {
            let path = IndexPath(row: nextIndex, section: 0)
            pauseVideo(On: path)
        }
    }
    
    func pauseVideo(On indexPath: IndexPath) {
        let index = indexPath.row
        videos[index].pause()
    }
    
    func validateEndOfVideos(with indexPath: IndexPath) {
        guard indexPath.row == videos.count - 1 else { return }
        Task {
            do {
                try await fetchVideos()
            }
        }
    }
}

// MARK: - Service Layer

protocol StreamingService {
    func fetchVideos() async throws -> VideosResponse
    func fetchComments() async throws -> CommentssResponse
}

class MockStreamingService: StreamingService {
    func fetchVideos() async throws -> VideosResponse {
        guard let url = Bundle.main.url(forResource: "videos", withExtension: "json") else {
            throw ServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(VideosResponse.self, from: data)
    }

    func fetchComments() async throws -> CommentssResponse {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json") else {
            throw ServiceError.fileNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(CommentssResponse.self, from: data)
    }
}

// MARK: - Error Handling

enum ServiceError: Error {
    case fileNotFound
}
