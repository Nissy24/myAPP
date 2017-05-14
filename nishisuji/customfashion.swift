//
//  customfashion.swift
//  nishisuji
//
//  Created by 西筋啓人 on 2017/05/08.
//  Copyright © 2017年 Hiroto Nishisuji. All rights reserved.
//

import UIKit
import CoreData
import Photos
import MobileCoreServices
import GoogleMobileAds

class customfashion: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GADBannerViewDelegate {

    var selectedIndex = -1
    
    var myimage = NSMutableArray()
    
    var selectimageIndex = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       read()
    }
    
    func read() {
        
        myimage = NSMutableArray()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        var alldays: String? = nil
        
        var mydate: Date? = nil
        
        let query: NSFetchRequest<Myfashion> = Myfashion.fetchRequest()
        do {
            let fetchResults = try! viewContext.fetch(query)
            for result:AnyObject in fetchResults{
                
                alldays = result.value(forKey: "fashion") as? String
                mydate = result.value(forKey: "saveDate") as? Date
                
                myimage.add(["fashion":alldays,"saveDate":mydate])
                
                
            }
        }catch{
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myimage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell:allfashion = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! allfashion
        
        let dic = myimage[indexPath.row] as! NSDictionary
        
        if dic["fashion"] as? String != nil{
           
            var imageview: String? = dic["fashion"] as! String
            var mydate: Date? = dic["saveDate"] as! Date
            
            var options:PHImageRequestOptions = PHImageRequestOptions()
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
            options.isSynchronous = true
            let url = URL(string: imageview as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFill,options: options) { (image, info) -> Void in
                //cell.myitem?.image = image
                cell.myimage?.image = image
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let dateString: String = dateFormatter.string(from: mydate!)
                
               cell.mylabel?.text = dateString

        }
      }
        cell.backgroundColor = UIColor.white
        
        return cell
    }

    // collectionViewがタップされた時発動
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        // メンバ変数に行番号を保存
        selectedIndex = indexPath.row
        
        // セグエを指定して画面遷移
        performSegue(withIdentifier: "every", sender: indexPath)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier! == "every") {
            let hukuitem = segue.destination as! everyday
            
            // 配列から画像と日付の情報を取得
            let dic = myimage[(sender as! IndexPath).row] as! NSDictionary
            
            //私が書きました
            hukuitem.scmemo1 = ((dic["saveDate"] as? Date))!
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
