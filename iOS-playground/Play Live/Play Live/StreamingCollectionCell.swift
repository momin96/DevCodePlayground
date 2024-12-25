//
//  StreamingCollectionCell.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import UIKit
import AVFoundation
import SwiftUI

class StreamingCollectionCell: UICollectionViewCell {
    
    static let streamCollectionIdentifier: String = "StreamingCollectionCellIdentifier"
    
    // UI Elements
    private var playerLayer: AVPlayerLayer?
    private var video: Video?

    private var commentsHostingController: UIHostingController<CommentsView>?

    private var baseView: UIView!
    private var topContainerView: UIView!
    private var bottomContainerView: UIView!
    private var profilePicImageView: UIImageView!
    private var usernameLabel: UILabel!
    private var viewersImageButton: UIButton!
    private var viewersLabel: UILabel!
    private var likesImageButton: UIButton!
    private var likesLabel: UILabel!
    private var followButton: UIButton!
    private var commentField: UITextField!
    private let playPauseButton = PlayPauseButton(frame: CGRect(x: 0, y: 0, width: 150.0, height: 150.0))
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
    }
    
    private func applyGradient(to view: UIView, colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 80)
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 1)
        
    }
    
    @objc private func didSingleTap(_ gesture: UIGestureRecognizer) {
        if let isPlaying = video?.isPlaying {
            isPlaying ?
            video?.pause() :
            video?.play()
            
            playPauseButton.allowPlaying(isPlaying)
        }
    }
    
    @objc private func didDoubleTap(_ gesture: UIGestureRecognizer) {
        print("Double tapp")
    }
    
    private func setupUI() {
        // Base view
        baseView = UIView()
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
        singleTapGesture.numberOfTapsRequired = 1
        contentView.addGestureRecognizer(singleTapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
        
        // Ensure single tap waits for double tap to fail
        singleTapGesture.require(toFail: doubleTapGesture)
        
        NSLayoutConstraint.activate([
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Initialize and add topContainerView
        topContainerView = UIView()
        baseView.addSubview(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            topContainerView.topAnchor.constraint(equalTo: baseView.topAnchor),
            topContainerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        applyGradient(to: topContainerView, colors: [UIColor.black.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor])
        
        
        // Initialize and add bottomContainerView
        bottomContainerView = UIView()
        baseView.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Apply gradient to bottomContainerView
        applyGradient(to: bottomContainerView, colors: [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor])
        
        // Profile Picture
        profilePicImageView = UIImageView()
        profilePicImageView.layer.cornerRadius = 25
        profilePicImageView.clipsToBounds = true
        baseView.addSubview(profilePicImageView)
        profilePicImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePicImageView.layer.cornerRadius = 25
        profilePicImageView.clipsToBounds = true
        
        // Username Label
        usernameLabel = UILabel()
        usernameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        usernameLabel.textColor = .white
        baseView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let redColor = UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
        
        // Follow Button
        followButton = UIButton(type: .system)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = redColor
        followButton.layer.cornerRadius = 12
        baseView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(playPauseButton)
        
        // Set constraints for centering the button
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 150),
            playPauseButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Viewers Image View
        viewersImageButton = UIButton()
        viewersImageButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        viewersImageButton.tintColor = redColor
        baseView.addSubview(viewersImageButton)
        viewersImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Viewers Label
        viewersLabel = UILabel()
        viewersLabel.font = UIFont.systemFont(ofSize: 14)
        viewersLabel.textColor = .white
        baseView.addSubview(viewersLabel)
        viewersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Likes Image View
        likesImageButton = UIButton()
        likesImageButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likesImageButton.tintColor = redColor
        baseView.addSubview(likesImageButton)
        likesImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Likes Label
        likesLabel = UILabel()
        likesLabel.font = UIFont.systemFont(ofSize: 14)
        likesLabel.textColor = .white
        baseView.addSubview(likesLabel)
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            // Profile Picture & Username
            profilePicImageView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            profilePicImageView.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 56),
            profilePicImageView.widthAnchor.constraint(equalToConstant: 50),
            profilePicImageView.heightAnchor.constraint(equalToConstant: 50),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profilePicImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profilePicImageView.centerYAnchor),
            
            // Follow Button
            followButton.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8),
            followButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 80),
            followButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Viewers Image & Label
            viewersLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
            viewersLabel.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -40),
            viewersLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            viewersLabel.heightAnchor.constraint(equalToConstant: 20),
            
            viewersImageButton.trailingAnchor.constraint(equalTo: viewersLabel.leadingAnchor, constant: -8),
            viewersImageButton.centerYAnchor.constraint(equalTo: viewersLabel.centerYAnchor),
            
            // Likes Image & Label
            likesLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -16),
            likesLabel.bottomAnchor.constraint(equalTo: viewersImageButton.topAnchor, constant: -16),
            likesLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            likesLabel.heightAnchor.constraint(equalToConstant: 20),
            
            likesImageButton.trailingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: -8),
            likesImageButton.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor)
        ])
        
        // Initialize and add the comment TextField
        let commentTextField = UITextField()
        commentTextField.placeholder = "Comment..."
        commentTextField.borderStyle = .none
        commentTextField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.masksToBounds = true
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 30))
        commentTextField.leftViewMode = .always

        let smileyContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let smileyLabel = UILabel(frame: smileyContainer.bounds)
        smileyLabel.text = "😊"
        smileyLabel.textAlignment = .center
        smileyContainer.addSubview(smileyLabel)
        commentTextField.rightView = smileyContainer
        commentTextField.rightViewMode = .always
        
        // Add the TextField to baseView
        baseView.addSubview(commentTextField)
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        commentField = commentTextField
        
        // Constraints for Comment TextField
        NSLayoutConstraint.activate([
            commentTextField.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 16),
            commentTextField.bottomAnchor.constraint(equalTo: viewersLabel.centerYAnchor, constant: 16),
            commentTextField.heightAnchor.constraint(equalToConstant: 40),
            commentTextField.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 100),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            UIView.animate(withDuration: 0.3) {
                self.baseView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.baseView.transform = .identity
        }
    }

    func configure(with comments: [Comment]) {
        let commentsView = CommentsView(comments: comments)
            commentsHostingController = UIHostingController(rootView: commentsView)
        let commentViewTag = 765
        commentsHostingController?.view.tag = commentViewTag
        
        if !baseView.subviews.contains(where: { $0.tag == commentViewTag }) {
            if let hostingControllerView = commentsHostingController?.view {
                hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
                baseView.addSubview(hostingControllerView)
                hostingControllerView.backgroundColor = .clear
                // Set up constraints for the CommentsView (topContainerView)
                NSLayoutConstraint.activate([
                    hostingControllerView.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 10),
                    hostingControllerView.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 10),
                    hostingControllerView.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -80),
                    hostingControllerView.heightAnchor.constraint(equalToConstant: 250)
                ])
            }
        }
    }
    
    
    func configure(with video: Video) {
        self.video = video
        
        usernameLabel.text = video.username.uppercased()
        viewersLabel.text = "\(video.viewers)"
        likesLabel.text = "\(video.likes)"
        loadImage(from: video.profilePicURL)
        
        print("Video \(video.video)")
        // Set up the AVPlayerLayer to display the video
        if let player = video.videoPlayer {
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = contentView.bounds
            playerLayer.videoGravity = .resizeAspectFill
            if self.playerLayer != nil {
                self.playerLayer?.removeFromSuperlayer()
            }
            baseView.layer.insertSublayer(playerLayer, at: 0)
            self.playerLayer = playerLayer
        }
        
        playPauseButton.playingCallback = { isPlaying in
            isPlaying ? video.pause() : video.play()
        }
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Asynchronous network request
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Ensure data is received and there were no errors
            guard let self = self, let data = data, error == nil else { return }
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.profilePicImageView.image = image
                }
            }
        }.resume()
    }
}


class PlayPauseButton: UIButton {
    private var isPlaying = false
    
    var playingCallback: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        let redColor = UIColor(red: 1.0, green: 0.0, blue: 0.5, alpha: 1.0)
        tintColor = redColor
        addTarget(self, action: #selector(togglePlayback), for: .touchUpInside)
    }

    @objc private func togglePlayback() {
        animate()
        isPlaying.toggle()
        playingCallback?(isPlaying)
    }
    
    private func animate() {
        let newImage = UIImage(systemName: isPlaying ? "pause.fill" : "play.fill")
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.setImage(newImage, for: .normal)
        }, completion: nil)
    }
    
    func allowPlaying(_ playing: Bool) {
        animate()
        isPlaying = playing
    }
}
