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
    let syncDispatchQueue = DispatchQueue(label: "customqueue")
    let queue = OperationQueue()
    func asyncBlock(id: Int) {
        print("async block #\(id) start")
        Thread.sleep(forTimeInterval: 1)
        print("async block #\(id) end")
    }
    private func semafor(){
        let semaphore = DispatchSemaphore(value: 2)

        syncDispatchQueue.async {
            semaphore.wait()
            self.gifs.loadGift()
            semaphore.signal()
        }

        syncDispatchQueue.async {
            semaphore.wait()
            self.gifs.search(search: "love")
            semaphore.signal()
        }

        syncDispatchQueue.async {
            semaphore.wait()
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
            semaphore.signal()
        }
    }
    
    private func blockOperation(){
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.qualityOfService = .userInitiated
        let block1 = BlockOperation {
            self.gifs.loadGift()
        }

        let block2 = BlockOperation {
            self.gifs.search(search: "love")
        }

        let block4 = BlockOperation {
            
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }


        operationQueue.addOperations([block1, block2], waitUntilFinished: true)
        operationQueue.addBarrierBlock {
            //self.gifs.search(search: "borna")
            //operationQueue.waitUntilAllOperationsAreFinished()
            operationQueue.addOperations([block4], waitUntilFinished: true)
        }
        
    }
    private func entreWaitLeave(){
        let queue1 = DispatchQueue(label: "Test dispatch queue", attributes: .concurrent)
        let group1 = DispatchGroup()

        group1.enter()
        queue1.async {
            asyncBlock(id: 1)
            self.gifs.loadGift()
            group1.leave()
        }

        group1.enter()
        queue1.async {
            asyncBlock(id: 2)
            self.gifs.search(search: "love")
            group1.leave()
        }

        queue1.async {
            group1.wait()
            asyncBlock(id: 3)
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }
        
        
    }
    private func barrier(){
        let queue1 = DispatchQueue(label: "Test dispatch queue", attributes: .concurrent)
        queue1.sync {
            asyncBlock(id: 1)
            self.gifs.loadGift()
        }

        queue1.sync {
            asyncBlock(id: 2)
            self.gifs.search(search: "love")
        }

        queue1.async(flags: .barrier) {
            asyncBlock(id: 3)
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }
        
    }
    private func barrier2(){
        let queue1 = DispatchQueue(label: "Test dispatch queue", attributes: .concurrent)
    
        queue1.async {
            asyncBlock(id: 1)
            self.gifs.loadGift()
        }

        queue1.async {
            asyncBlock(id: 2)
            self.gifs.search(search: "love")
        }

        let dispatchWorkItem = DispatchWorkItem(qos: .default, flags: .barrier) {
            asyncBlock(id: 3)
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }

        queue1.async(execute: dispatchWorkItem)
        
        
    }
    private func dispatchQueue(){
        let queue1 = DispatchQueue(label: "Test dispatch queue", attributes: .concurrent)
        let group1 = DispatchGroup()

        queue1.async(group: group1) {
            asyncBlock(id: 1)
            self.gifs.loadGift()
        }

        queue1.async(group: group1) {
            asyncBlock(id: 2)
            self.gifs.search(search: "love")
        }

        group1.notify(queue: queue1) {
            asyncBlock(id: 3)
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }
    }
    //best
    private func operationQueue(){
        let operationQueue = OperationQueue()
        let block1 = BlockOperation {
            asyncBlock(id: 1)
            self.gifs.loadGift()
        }

        let block2 = BlockOperation {
            asyncBlock(id: 2)
            self.gifs.search(search: "love")
        }

        let block3 = BlockOperation {
            asyncBlock(id: 3)
            let searchId = self.gifs.gifs[0].id
            self.gifs.searchGifId(gifID: searchId!)
            
            self.gifDetail = true
        }
        block2.addDependency(block1)
        //block3.addDependency(block1)
        block3.addDependency(block2)

        operationQueue.addOperations([block1, block2, block3], waitUntilFinished: false)
    }
    private func loadTredingGifs(){
        debugPrint("load gifs")
        
       
        syncDispatchQueue.sync {
        //DispatchQueue.global(qos: .background).sync {
        //mySerialQueue.asyncAfter(deadline: .now(), execute: {
            //.sync {
            debugPrint("Step 1")
            self.gifs.loadGift()
            print("Step 1 end")
        //}//)
        }
        syncDispatchQueue.sync {
        //DispatchQueue.global(qos: .userInitiated).sync {
        //mySerialQueue.asyncAfter(deadline: .now()+1, execute: {
            debugPrint("Step 2")
                //self.gifs.loadGift()
                self.gifs.search(search: "love")
            debugPrint("Step 2 end")
        //}//)
        }
        //syncDispatchQueue.async {
        //DispatchQueue.global(qos: .utility).sync {
        mySerialQueue.asyncAfter(deadline: .now()+0.5, execute: {
            //.sync {
            debugPrint("Step 3")
            print("Step 3 \(String(describing: self.gifs.gifs[10].title))")
            let searchId = self.gifs.gifs[10].id
            self.gifs.searchGifId(gifID: searchId!)
            mySerialQueue.asyncAfter(deadline: .now()+2, execute: {
            self.gifDetail = true
            })
            debugPrint("Step 3 end")
        })
        //}
         
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
                                    //self.loadTredingGifs()
                                    //self.semafor()
                                    //self.blockOperation()
                                    //self.dispatchQueue()
                                    //self.entreWaitLeave()
                                    //self.barrier()
                                    //self.barrier2()
                                    self.operationQueue()
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
