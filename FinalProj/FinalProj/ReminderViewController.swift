//
//  ReminderViewController.swift
//  FinalProj
//
//  Created by AIBN on 2021/1/24.
//

import UIKit
import os.log
import CoreML

let labels = ["apple", "banana", "cake", "candy", "carrot", "cookie",
              "doughnut", "grape", "hot dog", "ice cream", "juice",
              "muffin", "orange", "pineapple", "popcorn", "pretzel",
              "salad", "strawberry", "waffle", "watermelon"]

class ReminderViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTestField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /*
     This value is either passed by `ReminderTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new reminder.
     */
    var thing: Reminder?
    var model: Snacks?
    static let maxInflightBuffers = 3
    var resizedPixelBuffers: [CVPixelBuffer?] = []
    let ciContext = CIContext()
    
    override func viewWillAppear(_ animated: Bool) {
        model = Snacks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resultLabel.text = ""
        
        setUpCoreImage()
        
        // Handle the text field's user input through delegate callbacks.
        nameTestField.delegate = self
        
        // Set up views if editing an existing Reminder.
        if let reminder = thing {
            navigationItem.title = reminder.thing
            nameTestField.text   = reminder.thing
            photoImageView.image = reminder.photo
            ratingControl.rating = reminder.rating
            datePicker.date = reminder.date
        }
        
        //Enable the Save button only if the text field has a valid reminder name
        updateSaveButtonState()
    }
    
    func setUpCoreImage() {
      // Since we might be running several requests in parallel, we also need
      // to do the resizing in different pixel buffers or we might overwrite a
      // pixel buffer that's already in use.
      for _ in 0..<ReminderViewController.maxInflightBuffers {
        var resizedPixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(nil, SNACKMODEL.inputWidth, SNACKMODEL.inputHeight,
                                         kCVPixelFormatType_32BGRA, nil,
                                         &resizedPixelBuffer)

        if status != kCVReturnSuccess {
          print("Error: could not create resized pixel buffer", status)
        }
        resizedPixelBuffers.append(resizedPixelBuffer)
      }
    }

    //MARK: UITestFileDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        resultLabel.text = "Analyzing Image..."
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        let yolo = SNACKMODEL()
        let pixelBuffer = selectedImage.pixelBuffer(width: SNACKMODEL.inputWidth, height: SNACKMODEL.inputHeight)
        
        if let resizedPixelBuffer = resizedPixelBuffers[0] {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
            let sx = CGFloat(SNACKMODEL.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer!))
            let sy = CGFloat(SNACKMODEL.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer!))
            let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
            let scaledImage = ciImage.transformed(by: scaleTransform)
            ciContext.render(scaledImage, to: resizedPixelBuffer)

            // Give the resized input to our model.
            let boundingBoxes = yolo.predict(image: resizedPixelBuffer)
            resultLabel.text = "I think it's a \(labels[boundingBoxes!.classIndex])"
        }
        /*UIGraphicsBeginImageContextWithOptions(CGSize(width: ReminderViewController.inputWidth, height: ReminderViewController.inputHeight), true, 2.0)
        selectedImage.draw(in: CGRect(x: 0, y: 0, width: ReminderViewController.inputWidth, height: ReminderViewController.inputHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        guard let prediction = try? model?.prediction(image: pixelBuffer!) else{
            return
        }
        
        var index = -1
        var prob = -1.0
        for i in 0..<20{
            print(i, labels[i], prediction.output1[i].doubleValue)
            if (i != 3) && (prediction.output1[i].doubleValue > prob) {
                prob = prediction.output1[i].doubleValue
                index = i
            }
        }*/
        
    }

    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddReminderMode = presentingViewController is UINavigationController
        
        if isPresentingInAddReminderMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ReminderViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTestField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let date = datePicker.date
        
        // Set the thing to be passed to MealTableViewController after the unwind segue.
        thing = Reminder(thing: name, photo: photo, rating: rating, date: date)
        
        let ltime = intervalSinceNow(date)
        
        application(application: UIApplication.shared, didFinishLaunchingWithOptions: nil, lTime: ltime)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        //Hide the keyboard
        nameTestField.resignFirstResponder()
        
        //UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked, ont taken
        imagePickerController.sourceType = .photoLibrary
        
        //Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState(){
        //Disable the Save button if the text field is empty
        let text = nameTestField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func dateConvertString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = formatter.string(from: date)
        return date
    }

    
    //获取日期差，yyyy-MM-dd HH:mm:ss格式
    private func intervalSinceNow(_ fromdate: Date) -> Double{
        let format = DateFormatter.init()

        format.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let fromZone = TimeZone.current

        let fromInterval = fromZone.secondsFromGMT(for: fromdate)

        let fromDate = fromdate.addingTimeInterval(Double(fromInterval))

        let adate = Date()

        let zone = TimeZone.current

        let interval = zone.secondsFromGMT(for: adate)

        let localeDate = adate.addingTimeInterval(Double(interval))

        let interValTime = fromDate.timeIntervalSinceReferenceDate - localeDate.timeIntervalSinceReferenceDate

        let lTime = fabs(interValTime)

        let iSeconds = Int(lTime.truncatingRemainder(dividingBy: 60))

        let iMinutes = Int((lTime / 60) / 60)

        let iHours = Int(fabs((lTime / 3600).truncatingRemainder(dividingBy: 24)))

        let iDays: Int = Int(lTime / 60 / 60 / 24);

        print(iDays, iHours, iMinutes, iSeconds)
        print(lTime)
        
        return lTime

    }
    
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?, lTime: Double) -> Void {
     
        let pushtypes : UIUserNotificationType = [UIUserNotificationType.badge,UIUserNotificationType.alert,UIUserNotificationType.sound]
        let userSetting = UIUserNotificationSettings(types: pushtypes  , categories:nil)
            
        application.registerUserNotificationSettings(userSetting)
        self.sendNotification(lTime: lTime)
    }
    
    //添加本地推送和设置固定时间推送了
    private func sendNotification(lTime: Double) {
        //取消所有的本地通知
        UIApplication.shared.cancelAllLocalNotifications()
        //数字清零
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        let localNotificationAM = UILocalNotification()
    
        localNotificationAM.fireDate = getFireDate(lTime: lTime) as Date
        localNotificationAM.repeatInterval = NSCalendar.Unit.day
        localNotificationAM.timeZone = NSTimeZone.default
        localNotificationAM.alertBody = thing?.thing
        localNotificationAM.applicationIconBadgeNumber = 1
        localNotificationAM.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(localNotificationAM)
    }
    
    private func getFireDate(lTime: Double)->NSDate{
        let pushTime: Double = lTime
        return  NSDate(timeIntervalSinceNow: TimeInterval(pushTime))
    }
    
}

