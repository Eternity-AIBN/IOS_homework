//
//  ViewController.swift
//  MotionDetection
//
//  Created by AIBN on 2020/12/15.
//

import UIKit
import CoreML
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    
    static let samplesPerSecond = 25.0
    static let numberOfFeatures = 6
    static let windowSize = 20
    static let windowOffset = 5
    static let numberOfWindows = windowSize / windowOffset
    static let bufferSize = windowSize + windowOffset * (numberOfWindows - 1)
    static let sampleSizeAsBytes = ViewController.numberOfFeatures * MemoryLayout<Double>.stride
    static let windowOffsetAsBytes = ViewController.windowOffset * sampleSizeAsBytes
    static let windowSizeAsBytes = ViewController.windowSize * sampleSizeAsBytes
    
    let modelInput: MLMultiArray! = makeMLMultiArray(numberOfSamples: windowSize)
    let dataBuffer: MLMultiArray! = makeMLMultiArray(numberOfSamples: bufferSize)
    
    var bufferIndex = 0
    var isDataAvailable = false
    
    var classifierOutput: GestureClassifierOutput!
    
    static private func makeMLMultiArray(numberOfSamples: Int) -> MLMultiArray? {
        try? MLMultiArray(
            shape: [1, numberOfSamples, numberOfFeatures] as [NSNumber],
            dataType: .double
        )
    }
    
    func addToBuffer(_ x1: Int, _ x2: Int, _ data: Double) {
        dataBuffer[[0, x1, x2] as [NSNumber]] = NSNumber(value: data)
    }
    
    func buffer(_ motionData: CMDeviceMotion) {
        for offset in [0, ViewController.windowSize] {
            let index = bufferIndex + offset
            if index >= ViewController.bufferSize {
                continue
            }
            addToBuffer(index, 0, motionData.rotationRate.x)
            addToBuffer(index, 1, motionData.rotationRate.y)
            addToBuffer(index, 2, motionData.rotationRate.z)
            addToBuffer(index, 3, motionData.userAcceleration.x)
            addToBuffer(index, 4, motionData.userAcceleration.y)
            addToBuffer(index, 5, motionData.userAcceleration.z)
        }
    }
    
    func enableMotionUpdates(){
        motionManager.deviceMotionUpdateInterval = 1 / ViewController.samplesPerSecond
        motionManager.startDeviceMotionUpdates(
            using: .xArbitraryZVertical,
            to: queue,
            withHandler: { [weak self] motionData, error in
                guard let self = self, let motionData = motionData else {
                    let errorText = error?.localizedDescription ?? "Unknown"
                    print("Device motion update error: \(errorText)")
                    return
                }
                self.buffer(motionData)
                self.bufferIndex = (self.bufferIndex + 1) % ViewController.windowSize
                if self.bufferIndex == 0 {
                    self.isDataAvailable = true
                }
                self.predict()
                DispatchQueue.main.async {
                    self.run()
                }
            }
        )
    }
    
    
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var Confidence: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        enableMotionUpdates()
    }
    
    let model: GestureClassifier = {
        do {
            return try GestureClassifier(configuration: MLModelConfiguration())
        } catch {
            fatalError("Fail to create model")
        }
    }()
    
    func predict(){
        if isDataAvailable && bufferIndex % ViewController.windowOffset == 0 && bufferIndex + ViewController.windowOffset <= ViewController.windowSize {
            let window = bufferIndex / ViewController.windowOffset
            memcpy(modelInput.dataPointer, dataBuffer.dataPointer.advanced(by: window * ViewController.windowOffsetAsBytes), ViewController.windowSizeAsBytes)
            
            var classifierInput: GestureClassifierInput? = nil
            if classifierOutput == nil{   //The first layer
                classifierInput = GestureClassifierInput(features: modelInput)
            }
            else{
                classifierInput = GestureClassifierInput(features: modelInput, hiddenIn: classifierOutput.hiddenOut, cellIn: classifierOutput.cellOut)
            }
            
            classifierOutput = try? model.prediction(input: classifierInput!)
            
            DispatchQueue.main.async {
                self.Result.text = self.classifierOutput.activity
                self.Confidence.text = String(format: "%.1f%%",self.classifierOutput.activityProbability[self.classifierOutput.activity]! * 100)
            }
            
        }
    }
    
    //MARK: run
    var playing = false
    var curScore = 0
    var frameCount = 0
    var timer = 3
    var timeoutFlag = false
    var answer = ""
    
    @IBAction func startButton(_ sender: UIButton) {
        //enableMotionUpdates()
        if !playing{
            playing = !playing
            frameCount = 0
            curScore = 0
            score.text = "0"
            sender.setTitle("Type to end", for: .normal)
            randomMotion()
        }
        else{
            playing = !playing
            sender.setTitle("Type to start", for: .normal)
            motionLabel.text = "Try to ..."
        }
    }
    @IBOutlet weak var motionLabel: UILabel!
    @IBOutlet weak var score: UILabel!
    
    let motions = ["chop_it", "shake_it", "drive_it"]
    
    func randomMotion(){
        let index = Int.random(in: 0..<motions.count)
        answer = motions[index]
        motionLabel.text = "Try to " + answer
        timer = 3
        timeoutFlag = false
    }
    
    func run(){
        guard playing else {
            return
        }
        
        frameCount = (frameCount+1) % Int(ViewController.samplesPerSecond)
        if !timeoutFlag, classifierOutput.activity == answer{  //Do the right motion in time
            frameCount = 0
            timeoutFlag = false
            curScore += 1
            score.text = String(curScore)
            randomMotion()
        }
        else if frameCount == 0{
            if !timeoutFlag{
                if timer == 0{  //Timeout and don't do the right motion
                    timeoutFlag = true
                    curScore -= 1
                    score.text = String(curScore)
                }
                else{  //Don't do the right motion but still have time left
                    timer -= 1
                }
            }
            else{  //Timeout, generate a new motion
                randomMotion()
            }
        }
        
    }

}

