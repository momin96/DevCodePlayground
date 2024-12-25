# UIKit Play Live Shorts App

Welcome to the Shorts App, a fun project I developed to get back into UIKit after almost 5 years of exclusively using SwiftUI! Inspired by YouTube Shorts, this app lets users swipe up or down to explore videos, view the creator's profile, read comments, and see likes & view counts.

## Features

**Swipe Navigation:** Smooth vertical swiping to browse through videos using UICollectionView.

**Creator Details:** Displays creator profiles with name & profile picture.

**Engagement Metrics:** Shows likes, comments, & view counts for each video.

**Dynamic Data Handling:** Data is fetched & processed using a structured Service Layer with JSON parsing.

## Technical Highlights

**UICollectionView:**
- Configured with custom layout to enable vertical swiping for video transitions.
- Implements UICollectionViewDelegate & UICollectionViewDataSource for managing video cells dynamically.

**ViewController:**
- Acts as the central hub, handling UI updates & user interactions.
- Communicates with the ViewModel for fetching & preparing data.

**ViewModel:**
- Implements business logic & acts as a bridge between the ViewController & Service Layer.
- Ensures clean separation of concerns by preparing data for the UI.

**Service Layer:**
- Handles all API calls & parses JSON responses into usable model objects.
- Ensures the app stays scalable & maintainable.

**Storyboard Integration:**
- All UI components, including the UICollectionView and UIViewController, were designed using Storyboards for a visual-first approach.

## How to Run

1. Clone the repository.
2. Open the project in Xcode.
3. Run the app on your simulator or device.


## Improvements & Feedback
Check out the repo, explore the code, and feel free to suggest any improvements! 😊
