//
//  Comment.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import Foundation

class Comment: Codable {
    let id: Int
    let username: String
    let picURL: String
    let comment: String
}

struct VideosResponse: Codable {
    let videos: [Video]
}

struct CommentssResponse: Codable {
    let comments: [Comment]
}
