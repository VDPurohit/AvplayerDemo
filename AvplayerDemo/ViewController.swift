//
//  ViewController.swift
//  AvplayerDemo
//
//  Created by Admin on 19/03/19.
//  Copyright © 2019 CIPl-1PC143. All rights reserved.
//


import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController  {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var playButton:UIButton?
    var recordingSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
       // try recordingSession.setCategory(.playAndRecord, mode: .default, options: [])
        }catch {
            
        }
        
        let value : Decimal = 40.3
        print(Double(value.description) as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let url = URL(string: "https://s3.amazonaws.com/kargopolov/kukushka.mp3")
        
        guard let path = Bundle.main.path(forResource: "SampleAudio_0.7mb", ofType:"mp3") else {
            debugPrint("video.m4v not found")
            return
        }
        //self.player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        player = AVPlayer(playerItem: playerItem)
        
        let playerLayer=AVPlayerLayer(player: player!)
        playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
        self.view.layer.addSublayer(playerLayer)
        
        playButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        let xPostion:CGFloat = 50
        let yPostion:CGFloat = 100
        let buttonWidth:CGFloat = 150
        let buttonHeight:CGFloat = 45
        
        playButton!.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        playButton!.backgroundColor = UIColor.lightGray
        playButton!.setTitle("Play", for: UIControl.State.normal)
        playButton!.tintColor = UIColor.black
        //playButton!.addTarget(self, action: Selector("playButtonTapped:"), for: .touchUpInside)
        playButton!.addTarget(self, action: #selector(ViewController.playButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(playButton!)
        
        
        // Add playback slider
        
        let playbackSlider = UISlider(frame:CGRect(x:10, y:300, width:300, height:20))
        playbackSlider.minimumValue = 0
        
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = UIColor.green
        
        playbackSlider.addTarget(self, action: #selector(ViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        // playbackSlider.addTarget(self, action: "playbackSliderValueChanged:", forControlEvents: .ValueChanged)
        self.view.addSubview(playbackSlider)
        
    }
    
    @IBAction func btnSpeaker(_ sender: UIButton!) {
        self.toggleAudioRoute(toSpeaker: sender.isSelected)
        //self.setAudioOutputSpeaker(sender.isSelected)
        sender.isSelected.toggle()
    }
    
    func SetSessionPlayerOn()
    {   print("sepaker on")
        
        do {
           // try recordingSession.setCategory(.playAndRecord, mode: .default)
            
        }catch {}
        
        do {
            try recordingSession.setActive(true)
        }catch {}
    }
    func SetSessionPlayerOff()
    {
        print("sepaker off")
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch _ {
        }
    }
    
//    func setAudioOutputSpeaker(_ enabled: Bool) {
//        let session = AVAudioSession.sharedInstance()
//        try? session.setCategory(AVAudioSession.Category.playAndRecord, mode: .videoRecording, options: .defaultToSpeaker)
//        try? session.setMode(.voiceChat)
//        if enabled {
//            try? session.setCategory(AVAudioSession.Category.playAndRecord, mode: .videoRecording, options: .defaultToSpeaker)
//        } else {
//            try? session.overrideOutputAudioPort(.none)
//        }
//        try? session.setActive(true)
//    }
    
    func toggleAudioRoute(toSpeaker: Bool) {
        print(toSpeaker)
        do {
            if (toSpeaker) {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("speaker on")
                } catch _ {
                }
            } else {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("speaker off")
                } catch _ {
                }
            }
        } catch {
            NSLog("error.localizedDescription \(error.localizedDescription)")
        }
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    
    @objc func playButtonTapped(_ sender:UIButton)
    {
        if player?.rate == 0
        {
            player!.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Pause", for: UIControl.State.normal)
        } else {
            player!.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            playButton!.setTitle("Play", for: UIControl.State.normal)
        }
    }
}

