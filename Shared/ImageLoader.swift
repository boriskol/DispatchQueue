//
//  ImageLoader.swift
//  DispatchQueue
//
//  Created by Borna Libertines on 09/02/22.
//

import Foundation
import SwiftUI

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: URL?
    var imageCache = ImageCache.getImageCache()
    
    init(urlString: URL) {
        self.urlString = urlString 
        loadImage()
    }
    init(){
        
    }
    
    func loadImage() {
        if loadImageFromCache() {
           // debugPrint("Cache hit")
            return
        }
        //debugPrint("loading from url\(self.urlString)")
        loadImageFromUrl()
    }
    
    func loadImageFromCache() -> Bool {
        guard let urlString = urlString else {
            return false
        }
        
        guard let cacheImage = imageCache.get(forKey: urlString.path) else {
            return false
        }
        image = cacheImage
        return true
    }
    
    func deleteImageFromCache(urlStringD: String){
        imageCache.delete(forKey: urlStringD)
    }
    
    func loadImageFromUrl() {
        guard let urlString1 = self.urlString else {
            return
        }
        let task = URLSession.shared.dataTask(with: urlString1, completionHandler: getImageFromResponse(data:response:error:))
                task.resume()
        
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            debugPrint("Error: \(error!)")
            return
        }
        guard let data = data else {
            debugPrint("No data found")
            return
        }
        guard let loadedImage = UIImage(data: data) else {
            return
        }
        
        DispatchQueue.main.async {
            
            self.imageCache.set(forKey: self.urlString!.path, image: loadedImage)
            self.image = loadedImage
        }
    }
    deinit{
        debugPrint("UrlImageModel deinit")
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
    
    func delete(forKey: String) {
        cache.removeObject(forKey: forKey as NSString)
    }
    deinit{
        debugPrint("ImageCache deinit")
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}



struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    static var defaultImage = UIImage(named: "musicartisy.svg")
    init(urlString: URL) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        //GeometryReader { geo in
        VStack(alignment: .center, spacing: 8, content: {
            Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
                .resizable()
                //.scaledToFit()
                //.scaledToFill()
        })
        //.scaledToFill()
            //.overlay(Rectangle().fill(Color.gray.opacity(0.1)),alignment: .topLeading)
        //.ignoresSafeArea()
    }
    
    
}
