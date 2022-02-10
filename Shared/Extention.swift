//
//  Extention.swift
//  DispatchQueue
//
//  Created by Borna Libertines on 09/02/22.
//

import Foundation
import UIKit
import SwiftUI
/*
let imageCache = NSCache<NSURL, UIImage>()
extension UIImageView {
    
    func downloaded(urlString: URL, contentMode mode: ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: urlString) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                imageCache.setObject(image, forKey: urlString as NSURL)
                self?.image = image
            }
        }.resume()
    }
    func downloaded(link: URL, contentMode mode: ContentMode = .scaleToFill) {
        if let cachedImage = imageCache.object(forKey: link as NSURL)  {
            debugPrint("loading fromm catch")
            self.image = cachedImage
            return
        }
        downloaded(urlString: link, contentMode: mode)
    }
}
*/
extension View {
    func hideNavigationBar() -> some View {
        modifier(HideNavigationBarModifier())
    }
}
struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("")
    }
}
