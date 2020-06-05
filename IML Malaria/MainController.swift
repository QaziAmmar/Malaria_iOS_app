//
//  EditProfileController.swift
//  Port of Peri Peri
//
//  Created by Muhammad Umar on 15/08/2019.
//  Copyright © 2019 Neberox Technologies. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Alamofire

class MainController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var userDp  : UIImageView!
    //    @IBOutlet weak var predictionLbl: UILabel!
    @IBOutlet weak var cellCountLbl: UILabel!
    //    @IBOutlet weak var confidanceLbl: UILabel!
    @IBOutlet weak var cellCount: UILabel!
    @IBOutlet weak var malariaCountLbl: UILabel!
    
    
    
    var imagePicker = UIImagePickerController()
    var selectedGalleryImage: UIImage!
    var responceImageModel: ImagesModel!
    var malariaObjs : [ImagePoint]?
    var healtyaObjs : [ImagePoint]?
    private var allMalariaCropsImages : [UIImage] = []
    private var maConfidenceNo : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        //        cellCountLbl.isHidden = true
    }
    
    @IBAction func camBtnPressed(_btn: UIButton) {
        
        self.view.endEditing(true)
        let prefStyle:UIAlertController.Style = UIAlertController.Style.actionSheet
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: prefStyle)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler:{
            
            (alert: UIAlertAction!) -> Void in
            print("camera")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
            }
        })
        
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
                //                self.imagePicker.allowsEditing = true
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func countCellBtn(_ sender: UIButton) {
        countCells()
    }
    
    @IBAction func CheckSingleCell(_ sender: UIButton) {
        //        checkMalaria()
        guard let totalCell = malariaObjs?.count else {print("no cell");return}
        malariaCountLbl.text = String(totalCell)
    }
    
    
    @IBAction func analyzeMalariaAction(_ sender: Any) {
        
        if allMalariaCropsImages.count > 0 {
                
                guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MalariaTableView") as? MalariaTableView else {print("no vc");return}
                vc.malariaImage = allMalariaCropsImages
                vc.maConfidenceNo = maConfidenceNo
                show(vc, sender: sender)
        }else {
            // show alart here
        
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil
        {
            let img = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage?)!.byFixingOrientation()
            //            self.imagePicked = Utilities.resizeImage(image: img, newWidth: 1024)
            self.selectedGalleryImage = img
            self.userDp.image = self.selectedGalleryImage
            
            
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// API Extension.
extension MainController {
    
    
    //    func checkMalaria()  {
    //        MBProgressHUD.showAdded(to: self.view, animated: true)
    //        let url = "http://192.168.1.7:8000/api/check_malaria/"
    //
    //        do{
    //            Alamofire.upload(multipartFormData: { (multipartFormData) in
    //                if self.imagePicked != nil {
    //                    if let imageData = self.imagePicked.jpegData(compressionQuality: 0) {
    //                        multipartFormData.append(imageData, withName: "file", fileName: "image.png", mimeType: Utilities.getImageMimieType(data: imageData))
    //                    }
    //                }
    //            }, usingThreshold: UInt64.init(), to: url, method: .post, headers:[:]) { (encodingResult) in
    //
    //                switch encodingResult {
    //                case .success(let upload, _, _):
    //
    //                    upload.responseData(completionHandler: { (response) in
    //                        MBProgressHUD.hide(for: self.view, animated: true)
    //
    //                        switch response.result {
    //                        case .success(let value):
    //
    //                            let decoder = JSONDecoder()
    //                            do{
    //                                _ = try decoder.decode(MalariaPrediction.self, from: value)
    //                                self.updateLbl(image: self.imagePicked)
    //
    //                            }catch let error {
    //                                print(error)
    //                            }
    //
    //                        case .failure(let error):
    //                            print(error)
    //                        }
    //
    //                    })
    //
    //                case .failure(_):
    //                    MBProgressHUD.hide(for: self.view, animated: true)
    //                }
    //            }
    //        }
    //    }
    
    func countCells() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let url = "http://192.168.1.6:8000/api/test/"
        
        do{
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if self.selectedGalleryImage != nil {
                    if let imageData = self.selectedGalleryImage.jpegData(compressionQuality: 0) {
                        multipartFormData.append(imageData, withName: "file", fileName: "image.png", mimeType: Utilities.getImageMimieType(data: imageData))
                    }
                }
            }, usingThreshold: UInt64.init(), to: url, method: .post, headers:[:]) { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData(completionHandler: { (response) in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        switch response.result {
                        case .success(let value):
                            
                            let decoder = JSONDecoder()
                            do{
                                let FULLResponse = try
                                    decoder.decode(ImagesModel.self, from: value)
                                self.updateImage(model: FULLResponse)
                                
                                
                            }catch let error {
                                print(error)
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    })
                    
                case .failure(_):
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
    }
    
    //    func updateLbl(image: UIImage) {
    //
    //        let imageSize = image.size
    //        let scale: CGFloat = 0
    //        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
    //        let context = UIGraphicsGetCurrentContext()
    //        image.draw(at: CGPoint.zero)
    //        let tempPoint = self.imagePoints[10...15]
    //        for point in tempPoint {
    //
    //
    //            let rectangle = CGRect(x: point.x!, y: point.y!, width: point.w!, height: point.h!)
    //
    //            context!.setStrokeColor(UIColor.red.cgColor)
    //            context!.setLineWidth(2)
    //            context?.setFillColor(red: 255, green: 255, blue: 255, alpha: 0)
    //            context!.addRect(rectangle)
    //            context!.drawPath(using: .stroke)
    //
    //        }
    //
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //        userDp.image = newImage
    //
    //    }
    
    
    func updateImage(model: ImagesModel) {
        
        allMalariaCropsImages.removeAll() // Before prossing new image , remove periovus data
        
        let image = userDp.image
        let imageSize = image?.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize!, false, scale)
        let context = UIGraphicsGetCurrentContext()
        image?.draw(at: CGPoint.zero)
        
        
        healtyaObjs = model.data?.imagePoints?.filter({$0.prediction == "healthy"})
        malariaObjs = model.data?.imagePoints?.filter({$0.prediction == "malaria"})
        
        
        for point in (healtyaObjs)! {
            let rectangle = CGRect(x: point.x!, y: point.y!, width: point.w!, height: point.h!)
            
            
            context!.setStrokeColor(red: 0.020,green: 0.386,blue: 0.000,alpha: 1)
            context!.setLineWidth(3)
            context?.setFillColor(red: 255, green: 255, blue: 255, alpha: 0)
            context!.addRect(rectangle)
            context!.drawPath(using: .stroke)
            
        }
        
        for point in (malariaObjs)! {
            let rectangle = CGRect(x: point.x!, y: point.y!, width: point.w!, height: point.h!)
            
            context!.setStrokeColor(UIColor.red.cgColor)
            context!.setLineWidth(3)
            context?.setFillColor(red: 255, green: 255, blue: 255, alpha: 0)
            context!.addRect(rectangle)
            context!.drawPath(using: .stroke)
            
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        userDp.image = newImage
        cellCountLbl.isHidden = false
        cellCount.text = String(describing: model.data?.imagePoints?.count ?? 0)
        
        // this funcation use for to crop images from main image
        guard let malariaObj = malariaObjs else {print("no obje");return}
        seperat(malariaPoints: malariaObj)
    }
}
//MARK:- Crop Malaira Image
extension MainController {
    func seperat(malariaPoints : [ImagePoint]){
        
        for singleMalaria in malariaPoints {
            
            
            guard let x = singleMalaria.x else {print("no x");return}
            guard let y = singleMalaria.y else {print("no y");return}
            guard let w = singleMalaria.w else {print("no w");return}
            guard let h = singleMalaria.h else {print("no w");return}
            guard let confidence = singleMalaria.confidence else {print("no co");return}
            
            let cropImage = self.selectedGalleryImage.crop(rect: CGRect(x: x, y: y, width: w, height: h))
            allMalariaCropsImages.append(cropImage)
            maConfidenceNo.append(confidence)
        }
    }
}
