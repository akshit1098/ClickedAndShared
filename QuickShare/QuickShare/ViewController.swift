//
//  ViewController.swift
//  QuickShare
//
//  Created by Akshit Saxena on 1/23/24.
//

import UIKit
import Photos

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    var imagePicker: UIImagePickerController!
    
    
    
    var assetCollection: PHAssetCollection?
    
    var photos: PHFetchResult<PHAsset>?
    let reuseIdentifier = "tableViewCell"
    var dummyObjects = ["hi", "there", "i'm", "here"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        if (collection.firstObject != nil){
            self.assetCollection = collection.firstObject! as? PHAssetCollection
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.photos = PHAsset.fetchAssets(in: assetCollection!, options: options)
        }
        else{
            print("nothing Found")
        }
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        if (collection.firstObject != nil){
            self.assetCollection = collection.firstObject! as? PHAssetCollection
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.photos = PHAsset.fetchAssets(in: assetCollection!, options: options)
        }
        else{
            print("nothing Found")
        }
        tableView.reloadData()
    }
    
    @IBAction func CameraButtonClicked(_ sender: Any) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    //    @IBAction func CameraButtonClicked(_ sender: AnyObject){
//        imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
//        present(imagePicker, animated: true, completion: nil)
//    }
//    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        let newVc = self.storyboard?.instantiateViewController(withIdentifier: "showPhotoVc") as! ShowImageViewController
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            newVc.image = image
            show(newVc, sender: self)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
//        cell.myImageView.image = UIImage(named: "polaroid")
        if let asset = self.photos?[indexPath.row]{
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 320, height: 240), contentMode: .aspectFill, options: nil) { (result, info) in
                if let image = result{
                    cell.myImageView?.image = image
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier{
            if(id == "showFullImageSegue"){
                let newVc = segue.destination as! ShowImageViewController
                
                var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                if let asset = self.photos?[(indexPath!.row)]{
                    newVc.asset = asset
                }
            }
        }
    }

}

