//
//  ContentView.swift
//  Shared
//
//  Created by Borna Libertines on 09/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var gifs = MainViewModel()
    @State private var gifDetail = false
    
    let mySerialQueue = DispatchQueue(label: "serialqueue", attributes: .concurrent)
    
    private func loadTredingGifs(){
        debugPrint("load gifs")
       
            
        mySerialQueue.sync {
            debugPrint("Step 1")
            self.gifs.loadGift()
            print("Step 1 end")
        }
        
        mySerialQueue.asyncAfter(deadline: .now()+1, execute: {
            debugPrint("Step 2")
                //self.gifs.loadGift()
                self.gifs.search(search: "love")
            debugPrint("Step 2 end")
        })
        
        mySerialQueue.asyncAfter(deadline: .now()+2, execute: {
            //.sync {
            debugPrint("Step 3")
            print("Step 3 \(String(describing: self.gifs.gifs[10].title))")
            let searchId = self.gifs.gifs[10].id
            self.gifs.searchGifId(gifID: searchId!)
            self.gifDetail = true
            debugPrint("Step 3 end")
        })
       
    }
    
    var body: some View {
        
        NavigationView{
            ScrollViewReader { proxy in
                GeometryReader { geometry in
                    if let tit = self.gifs.gif?.title{
                    NavigationLink(destination: VStack{Text("Detail View \(tit)")}, isActive: self.$gifDetail) {
                            Text("").frame(width: 0, height: 0)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        
                        // MARK: Gifs
                        Section(header: VStack(alignment: .leading, spacing: 8){
                            Text("Gifs Traiding").font(.body).foregroundColor(.purple).fontWeight(.bold)
                                .onAppear(perform: {
                                    self.loadTredingGifs()
                                })
                        }, content: {
                            if !self.gifs.gifs.isEmpty{
                                ScrollView(.vertical, showsIndicators: false) {
                                    LazyVStack(alignment: .center, spacing: 8) {
                                        ForEach(self.gifs.gifs, id: \.id) { gif in
                                            LazyVStack(alignment: .leading, spacing: 8) {
                                                if let im = gif.Image{
                                                    HStack(alignment: .center) {
                                                        UrlImageView(urlString: im)
                                                            .frame(width: geometry.size.width/4, height: geometry.size.width/4, alignment: .center)
                                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                                        
                                                        if let title = gif.title {
                                                            VStack{
                                                                HStack(alignment: VerticalAlignment.center, spacing: 8) {
                                                                    Text("\(title)")
                                                                }
                                                            }
                                                            Spacer()
                                                        }
                                                    }
                                                }
                                                
                                            }.background(Color.clear)
                                        }
                                    }
                                }.background(Color.clear)
                                    .listRowBackground(Color.clear)
                            }
                        })
                        Spacer()
                    }
                    )}.padding()
            }
            .hideNavigationBar()
        }
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
