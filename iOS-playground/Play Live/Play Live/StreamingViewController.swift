//
//  StreamingViewController.swift
//  Play Live
//
//  Created by Nasir Ahmed Momin on 21/12/24.
//

import UIKit
import Combine

class StreamingViewController: UIViewController {
    
    let viewModel = StreamingViewModel(service: MockStreamingService())
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var subscriptions: Set<AnyCancellable> = []
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        collectionView.register(StreamingCollectionCell.self, forCellWithReuseIdentifier: StreamingCollectionCell.streamCollectionIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupSubscription()
        fetchVideos()
    }
    
    private func setupSubscription() {
        viewModel.reloadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                collectionView.reloadData()
            }.store(in: &subscriptions)
    }
    
    func fetchVideos() {
        Task {
            do {
                try await viewModel.fetchComments()
                try await viewModel.fetchVideos()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.viewModel.playVideo(On: indexPath)
                }
            } catch let error {
                print("error \(error)")
            }
        }
    }
}

extension StreamingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StreamingCollectionCell.streamCollectionIdentifier, for: indexPath) as? StreamingCollectionCell else {
            fatalError("Unable to dequeue StreamingCollectionCell")
        }
        
        let video = viewModel.videos[indexPath.item]
        cell.configure(with: video)
        cell.configure(with: viewModel.comments)
        viewModel.validateEndOfVideos(with: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.pauseVideo(On: indexPath)
    }
}

extension StreamingViewController: UICollectionViewDelegate,  UICollectionViewDelegateFlowLayout {
    
    // UICollectionViewDelegateFlowLayout method to set the size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    // Detect when scrolling stops
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playVideoInCenteredCell()
    }
    
    // Helper to find the center cell and trigger action
    private func playVideoInCenteredCell() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            viewModel.playVideo(On: indexPath)
        }
    }
}
