//
//  ShowImageViewController.swift
//  QuickShare
//
//  Created by Akshit Saxena on 1/24/24.
//

import UIKit
import Photos
import Social


class ShowImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
//    var passedString = "blank"
    var asset: PHAsset?
    var image: UIImage?
    var docController: UIDocumentInteractionController?
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(passedString)
        // Do any additional setup after loading the view.
        if let myAsset = asset{
            PHImageManager.default().requestImage(for: myAsset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width * 0.5625), contentMode: .aspectFill, options: nil) { (result, info) in
                if let image = result{
                    self.imageView.image = image
                }
            }
        } else if(image != nil){
            self.imageView.image = image
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton){
        
        switch sender.tag{
        case 0:
//            print("fb")
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
                ShareFacebookTwitter(vc: vc)
            }
        case 1:
            shareInstagram()
        case 2:
//            print("whatsapp")
            shareWhatsapp()
        case 3:
//            print("twitter")
            if let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
                ShareFacebookTwitter(vc: vc)
            }
        case 4:
            print("pinterest")
        default:
            print("nothiing!!")
        }
    }
    
    func ShareFacebookTwitter(vc: SLComposeViewController){
        vc.setInitialText("Look at this great picture!!")
        vc.add(imageView.image)
        let facebookURL = URL(string: "https://www.google.com")
        vc.add(facebookURL)
        present(vc, animated: true, completion: nil)
    }
    
    func shareWhatsapp(){
        let urlWhats = "whatsapp://app"
        
        if let whatsappURL = URL(string: urlWhats){
            if UIApplication.shared.canOpenURL(whatsappURL){
                if let image = imageView.image{
                    if let imageData = image.jpegData(compressionQuality: 85){
                        do{
                            let tempFile = try URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsAppTmp.wai")
                            try imageData.write(to: tempFile, options: .atomicWrite)
                            self.docController = UIDocumentInteractionController(url: tempFile)
                            self.docController?.uti = "net.whaatsapp.image"
                            self.docController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                        }
                        catch _ {
                            print("whatsapp error")
                        }
                    }
                }
            }
        }
    }
    
    func shareInstagram(){
        let instagramUrl = URL(string: "instagram://app")
        
        if(UIApplication.shared.canOpenURL(instagramUrl!)){
            let imageData = imageView.image!.jpegData(compressionQuality: 85)
            let captionString = "Default Text"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            do{
                try imageData?.write(to: URL(fileURLWithPath: writePath), options: [.atomicWrite])
                let fileURL = URL(fileURLWithPath: writePath)
                self.docController = UIDocumentInteractionController(url: fileURL)
                self.docController?.delegate = self
                
                self.docController?.uti = "com.instagram.exclusivegram"
                
                self.docController?.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                self.docController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
            } catch _ {
                print("error Instagram")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
