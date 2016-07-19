//
//  UploadViewController.swift
//  WCApi
//
//  Created by Aleksander Koko on 7/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WCApi

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var selectedImage: NSData?
    var uploadMultimedia: UploadMultimedia?

    @IBAction func selectPhoto(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func upload(sender: AnyObject) {
        
        let user = UserModel(username: "AleksanderKoko")
        let title = "A file name here"
        let description = "A description here"
        let comment = "Uploading from WCApi"
        
        self.uploadMultimedia!.upload(user, title: title, description: description, comment: comment, license: MultimediaModel.Licenses.CreativeCommonsAttributionShareAlike40, categories: ["ScreenShots"], imageData: self.selectedImage!, date: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.uploadMultimedia = UploadMultimedia(handler: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if  let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            self.view.layer.backgroundColor = UIColor.blackColor().CGColor
            
            self.selectedImage = UIImageJPEGRepresentation(pickedImage, 1.0)
            
        }else{
            self.view.layer.backgroundColor = UIColor.whiteColor().CGColor
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UploadViewController: UploadMultimediaHandlerProtocol{
    
    func uploadMultimediaSuccess(){
        
    }
    
    func uploadMultimediaError(error: UploadMultimediaErrorFatal){
        
    }
    
    func uploadMultimediaError(error: GetTokenErrorFatal){
        
    }

    
}
