//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alfredo Merino on 5/11/19.
//  Copyright © 2019 Alfredo Merino. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    // MARK: - Properties
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    
    // MARK: - Actions
    @IBAction func recordAudio(_ sender: UIButton) {
        configureUI(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                          .userDomainMask,
                                                          true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                                 mode: AVAudioSession.Mode.default,
                                 options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    @IBAction func stopRecording(_ sender: Any) {
        audioRecorder.stop()
        configureUI(isRecording: false)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            let alert = UIAlertController(title: "Recording Failed", message: "An error occurred while attempting recording.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureUI(isRecording: Bool){
        if isRecording == false {
            
            
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true

        }
        else {
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = isRecording
            stopRecordingButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

