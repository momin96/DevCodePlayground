//
//  CommentsView.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import SwiftUI

struct CommentsView: View {
    let comments: [Comment]
    
    @State private var scrollOffset: CGFloat = 0
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 8) {
                        ForEach(comments, id: \.id) { comment in
                            CommentRow(comment: comment, comments: comments, scrollOffset: $scrollOffset)
                            .animation(.easeInOut(duration: 0.2), value: scrollOffset)                        }
                    }
                    .padding()
                    .offset(y: scrollOffset)
                }
                .onAppear {
                    startAutoScroll(viewHeight: geometry.size.height)
                }
                .onDisappear {
                    stopAutoScroll()
                }
            }
        }
    }
    
    private func startAutoScroll(viewHeight: CGFloat) {
        stopAutoScroll()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            scrollOffset -= 1
            let contentHeight = CGFloat(comments.count * 60) // Approximate height per comment
            if abs(scrollOffset) >= contentHeight - viewHeight {
                scrollOffset = viewHeight
            }
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

struct CommentRow: View {
    let comment: Comment
    let comments: [Comment]
    @Binding var scrollOffset: CGFloat // Bind to track scroll position
     @State private var opacity: Double = 1.0 // Track the opacity of the comment

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: comment.picURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(comment.username)
                    .font(.headline)
                    .foregroundColor(.blue)
                Text(comment.comment)
                    .font(.body)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .opacity(opacity)
        .onChange(of: scrollOffset, { oldValue, newValue in
            // Calculate each comment's position and adjust opacity when it's near the top
            let commentPosition = getCommentPositionForScroll(scrollOffset: newValue)
            if commentPosition < 0 { // If the comment is scrolled past the top
                opacity = max(0, 1 - abs(commentPosition) / 100.0) // Fade out as it moves away from the top
            } else {
                opacity = 1 // Reset opacity when the comment is back in view
            }
        })
    }
    
    private func getCommentPositionForScroll(scrollOffset: CGFloat) -> CGFloat {
            // Each comment's height is roughly 60, you can adjust this based on your layout
            let commentIndex = CGFloat(comments.firstIndex { $0.id == comment.id } ?? 0)
            let commentPosition = scrollOffset + commentIndex * 100
            return commentPosition
        }
}
