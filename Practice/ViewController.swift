//
//  ViewController.swift
//  Practice
//
//  Created by Admin on 11/03/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var imageSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    let scrollView = UIScrollView()
    var imageViews = [UIImageView]()

    var asset: AVAsset?
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var imageGenerator: AVAssetImageGenerator?
    var images = [UIImage]()
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.7)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)

        // Load the video asset
        if let url = Bundle.main.url(forResource: "sample-video", withExtension: "mp4")
        {
            asset = AVAsset(url: url)
            // Set the frame and content mode of the image view


        
        // Create the player item and player
        playerItem = AVPlayerItem(asset: asset!)
        player = AVPlayer(playerItem: playerItem!)
        
        // Create the video player view
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = videoPlayerView.bounds
        videoPlayerView.layer.addSublayer(playerLayer)
        
        // Create the image generator
        imageGenerator = AVAssetImageGenerator(asset: asset!)
        imageGenerator?.appliesPreferredTrackTransform = true
        
        // Generate the thumbnail images at 1 second intervals
        let durationSeconds = CMTimeGetSeconds(asset!.duration)
            print("Duration: \(durationSeconds) seconds")

        let intervalSeconds = 1.0
        var time = CMTime.zero
        while (CMTimeGetSeconds(time) < durationSeconds) {
            print("Time: \(CMTimeGetSeconds(time)) seconds")

            if let image = generateThumbnailImage(time: time) {
                images.append(image)
            }
            time = CMTimeMakeWithSeconds(CMTimeGetSeconds(time) + intervalSeconds, preferredTimescale: 1000)
        }
            for image in images {
                      let imageView = UIImageView(image: image)
                      imageView.contentMode = .scaleAspectFit
                      scrollView.addSubview(imageView)
                      imageViews.append(imageView)
                  }
            for i in 0..<imageViews.count {
                       imageViews[i].translatesAutoresizingMaskIntoConstraints = false
                       imageViews[i].topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                       imageViews[i].bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                       imageViews[i].widthAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
                       if i == 0 {
                           imageViews[i].leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
                       } else {
                           imageViews[i].leadingAnchor.constraint(equalTo: imageViews[i-1].trailingAnchor).isActive = true
                       }
                       if i == imageViews.count - 1 {
                           imageViews[i].trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
                       }
                   }
        // Configure the image slider
        imageSlider.maximumValue = Float(images.count - 1)
        imageSlider.value = 0
        imageView.image = images[0]
            print("Number of images: \(images.count)")

                }
    }
    
    // Generate a thumbnail image from the video at a specific time
    func generateThumbnailImage(time: CMTime) -> UIImage? {
        do {
            let imageGenerator = AVAssetImageGenerator(asset: asset!)
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.requestedTimeToleranceBefore = CMTimeMake(value: 1, timescale: 15)
            imageGenerator.requestedTimeToleranceAfter = CMTimeMake(value: 1, timescale: 15)

            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            print(cgImage) // print the CGImage to see if it's the same image
            return UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
    
    // Play the video from the selected image
    @IBAction func playFromSelectedImage(_ sender: Any) {
        let selectedIndex = Int(imageSlider.value)
        let selectedTime = CMTimeMakeWithSeconds(Float64(selectedIndex), preferredTimescale: 1)
        player?.seek(to: selectedTime)
        player?.play()
        
        // Start a timer to update the slider position
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let currentTime = CMTimeGetSeconds(self.player!.currentTime())
            self.imageSlider.value = Float(currentTime)
        }
    }
    
    // Stop the video playback and timer
    @IBAction func stopPlayback(_ sender: Any) {
        player?.pause()
        timer?.invalidate()
    }
    
    // Update the image view when the slider value changes
    @IBAction func sliderValueChanged(_ sender: Any) {
        let selectedIndex = Int(imageSlider.value)
        print(selectedIndex)
        imageView.image = images[selectedIndex]
        let offset = CGPoint(x: CGFloat(imageSlider.value) * scrollView.contentSize.width / CGFloat(images.count - 1), y: 0)
        scrollView.setContentOffset(offset, animated: true)

    }
}

