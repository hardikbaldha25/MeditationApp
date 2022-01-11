//
//  ViewController.swift
//  MeditationApp
//
//  Created by Hardik on 11/01/22.
//

import UIKit
import AVKit
import MediaPlayer

class AudioPlayController: UIViewController {
    
    var playerAv: AVPlayer?
    var playerItem: AVPlayerItem?
    var observer: Any?
    var lastStopedTime: CMTime?
    @IBOutlet private weak var btnPlay: UIButton!
    
    @IBOutlet private weak var lblDuration: UILabel!
    @IBOutlet private weak var lblCurrent: UILabel!
    
    @IBOutlet private weak var progressSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupCommandCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func playSound(_ sender: Any) {
        
        
        if self.btnPlay.isSelected {
            self.btnPlay.isSelected = false
            self.pauseAudio()
        } else {
            self.btnPlay.isSelected = true
            if let stopTIme = self.lastStopedTime {
                self.playerAv?.seek(to: stopTIme)
                self.playerAv?.play()
            } else {
               playAudio()
            }
        }
    
    }
    
    func playAudio() {
        guard let soundFileURL = Bundle.main.url(forResource: "sample", withExtension: "mp3") else {
            return
        }
        print(soundFileURL)
        initPlayItemAndPlayAudio(audioUrl: soundFileURL)
        
    }
    private func pauseAudio() {
        self.playerAv?.pause()
        self.lastStopedTime = self.playerAv?.currentTime()
    }
    
    func setupCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
    
        guard playerItem != nil else {return}
        let nowPlayingInfo = [ MPMediaItemPropertyPlaybackDuration : CMTime(seconds: 10, preferredTimescale: .max), MPMediaItemPropertyTitle : "sample"] as [String : Any]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                
    }

    @objc func playCenter(_ action: MPRemoteCommandEvent) {
        
    }
    @objc func pauseCenter(_ action: MPRemoteCommandEvent) {
       
    }
    
    private func updateProgressBar() {
        if let duration = playerItem?.duration, let current = playerItem?.currentTime() {
            let durationInSec = CMTimeGetSeconds(duration)
            let durationCurrent = CMTimeGetSeconds(current)
            if !durationInSec.isNaN {
                self.lblDuration.text = duration.durationText
            }
            if !durationCurrent.isNaN {
                self.lblCurrent.text = current.durationText
            }
            
            if (durationInSec.isFinite && (durationInSec > 0)) {
                progressSlider.value = Float(durationCurrent / durationInSec)
            }
            
            if !durationCurrent.isNaN && !durationInSec.isNaN {
                if current.durationText == duration.durationText {
                    //                self.playerAv?.pause()
                    
                    if observer != nil {
                        playerAv?.removeTimeObserver(observer)
                        observer = nil
                    }
                    progressSlider.value = 0.0
                    self.lblCurrent.text = "00:00"

                }
            }
            
        }
    }
    
    private func initPlayItemAndPlayAudio(audioUrl: URL) {
        playerItem = AVPlayerItem(url: audioUrl)
        playerAv = AVPlayer(playerItem: playerItem)
        
        playerAv?.play()
        playerAv?.volume = 1.0
        
        if playerAv?.rate != 0 && playerAv?.error == nil {
            print("Playing")
            if observer != nil {
                playerAv?.removeTimeObserver(observer)
            }
            observer = playerAv?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: nil, using: { [weak self] _ in
                guard let `self` = self else {
                    return
                }
                
                self.updateProgressBar()
                
                let playbackLikelyToKeepUp = self.playerAv?.currentItem?.isPlaybackLikelyToKeepUp
                if playbackLikelyToKeepUp == false {
                    print("IsBuffering")
                
                } else {
                    print("Buffering completed")
                
                }
            })
        } else {
            print("Error Playing")
        }
    }
   
}



extension CMTime {
    
    var durationText: String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let hours: Int = Int(totalSeconds / 3600)
        let minutes: Int = Int(totalSeconds % 3600 / 60)
        let seconds: Int = Int((totalSeconds % 3600) % 60)

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
