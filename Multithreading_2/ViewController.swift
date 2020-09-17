//
//  ViewController.swift
//  Multithreading_2
//
//  Created by Mad Brains on 17.09.2020.
//  Copyright © 2020 GeekTest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var images = [
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!,
        UIImage(named: "PikachuImage")!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        blurImages()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.imageView?.image = images[indexPath.row]
        
        return cell
    }
    
    func blur(image: UIImage, imageView: UIImageView?) {
        DispatchQueue.global(qos: .userInteractive).async {
            let inputCIImage = CIImage(image: image)!
            
            let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
            let outputImage = blurFilter.outputImage!
            let context = CIContext()
            let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
            
            let bluredImage = UIImage(cgImage: cgiImage!)
            
            DispatchQueue.main.async {
                imageView?.image = bluredImage
            }
        }
    }
    
    func blurImages() {
        var bluredImages = images
        
        let dispatchGroup = DispatchGroup()
        
        for element in bluredImages.enumerated() {
            
            DispatchQueue.global(qos: .userInteractive).async(group: dispatchGroup) {
                let inputImage = element.element
                
                let inputCIImage = CIImage(image: inputImage)!
                
                let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
                let outputImage = blurFilter.outputImage!
                let context = CIContext()
                let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
                
                let bluredImage = UIImage(cgImage: cgiImage!)
                
                bluredImages[element.offset] = bluredImage
            }
            
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.images = bluredImages
            self.tableView.reloadData()
        }
    }
    

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

//        let inputCIImage = CIImage(image: inputImage)!
//
//        let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: inputCIImage])!
//        let outputImage = blurFilter.outputImage!
//        let context = CIContext()
//        let cgiImage = context.createCGImage(outputImage, from: outputImage.extent)
//
//        let bluredImage = UIImage(cgImage: cgiImage!)
