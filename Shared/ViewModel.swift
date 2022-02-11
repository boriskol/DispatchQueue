//
//  ViewModel.swift
//  DispatchQueue
//
//  Created by Borna Libertines on 09/02/22.
//

import Foundation

//
//  GifListViewModel.swift
//  Dispo Take Home
//
//  Created by Borna Libertines on 22/01/22.
//

import Foundation
import Combine
import SwiftUI

// MARK: MainViewModel
/*
 view model for MainViewController
 observe changes in values
 */

class MainViewModel: ObservableObject {
    
    // MARK:  Initializer Dependency injestion
    @Published var gifs = [GifCollectionViewCellViewModel]()
    @Published var gif: GifViewCellViewModel?
    @Published var gifDetail: Bool?
    
    var appiCall: ApiProvider?
    
    init(appiCall: ApiProvider = GifAPIClient()){
        self.appiCall = appiCall
    }
    
    func loadGift(){
        
        appiCall?.getRequest(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifAcces: Constants.trending, decodable: APIListResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
                })
                self.gifs = d
            }
        })
    }
    // MARK: Parameter Dependency injestion
    /*
    func search(search: String, with dependency: GifAPIClient){
        dependency.getRequest(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifAcces: Constants.search, decodable: APIListResponse.self , completion:{ result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url) })
                self.gifs.value = d
            }
        })
    }*/
    func search(search: String){
        appiCall?.getRequest(urlParams: [Constants.searchGif: search, Constants.limit: Constants.limitNum], gifAcces: Constants.search, decodable: APIListResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = linkdata.data.map({ return GifCollectionViewCellViewModel(id: $0.id, title: $0.title, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url) })
                self.gifs = d
            }
        })
    }
    
    func searchGifId(gifID: String){
        appiCall?.getRequest(urlParams: [:], gifAcces: gifID, decodable: APGifResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = GifViewCellViewModel(id: linkdata.data.id, title: linkdata.data.title, rating: linkdata.data.rating, Image: linkdata.data.images?.fixed_height?.url, video: linkdata.data.images?.fixed_height?.mp4, url: linkdata.data.url)
                self.gif = d
                self.gifDetail = true
            }
        })
    }
    deinit{
        debugPrint("MainViewModel deinit")
    }
}

// MARK: DetailViewModel
/*
 view model for DetailViewController
 */

class DetailViewModel: ObservableObject{
    
    @Published var gif: GifViewCellViewModel?
    
    // MARK: Property Dependency injestion
    var appiCall: ApiProvider? = GifAPIClient()
    
    /*init(appiCall: ApiProvider = GifAPIClient()){
        self.appiCall = appiCall
    }*/
    
    func searchGifId(gifID: String){
        appiCall?.getRequest(urlParams: [:], gifAcces: gifID, decodable: APGifResponse.self, completion: { result in
            switch result {
            case .failure(let error):
                debugPrint("server error : \(error.localizedDescription)")
            case .success(let linkdata):
                let d = GifViewCellViewModel(id: linkdata.data.id, title: linkdata.data.title, rating: linkdata.data.rating, Image: linkdata.data.images?.fixed_height?.url, video: linkdata.data.images?.fixed_height?.mp4, url: linkdata.data.url)
                self.gif = d
            }
        })
    }
}

