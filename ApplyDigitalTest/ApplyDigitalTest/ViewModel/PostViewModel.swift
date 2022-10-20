//
//  PostViewModel.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import Foundation
import Combine
import CoreData
import SwiftUI

class PostViewModel: ObservableObject {
    
    //MARK: - Properties
    private let service: Service
    private var cancellables = Set<AnyCancellable>()
    @Published var showAlert = false
    @Published var alertMsg = ""
    @Published var isRefreshing = false
    @Published var isError = false
    
    init(service: Service) {
        self.service = service
    }

    //MARK: - Functions

    func getPost(context: NSManagedObjectContext) {
        isRefreshing = true
     
        let cancellable = service
            .requestNew(from: .getPost, type: Posts.self)
            .sink { res in
                switch res {

                case .finished:
                    //self.state = .success(content: self.users)
                  break
                case .failure(let error):
                    //self.state = .failed(error: error)
                    self.isError = true
                    if error.localizedDescription ==  APIError.decodingError.localizedDescription {
                        self.alertMsg = "Error de conexion, intente de nuevo!."
                    }
                    self.showAlert = true
                    print(error.localizedDescription)
                    self.isRefreshing = false
                }
            } receiveValue: { response in
                
                response.hits.forEach { hit in
                    self.createPost(context: context, hit: hit)
                }
                
                //self.createPost(context: context, hit: response.hits[0])
                self.isRefreshing = false
            }
        self.cancellables.insert(cancellable)
       
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    func createPost(context: NSManagedObjectContext, hit: Hit) {
        let post = Post(context: context)
        post.id = UUID()
        
        if let title = hit.title {
            post.title = nullToNil(value: title) as? String
        } else {
            post.title = hit.storyTitle
        }
        
        if let url = hit.url {
            post.story_url = nullToNil(value: url) as? String
        } else {
            post.story_url = hit.storyURL
        }
        post.author = hit.author
        post.date = hit.createdAt
        post.timestamp = Date()
        save(context: context)
    }
    
    func deleteItems(post: Post, context: NSManagedObjectContext) {
        withAnimation {
            context.delete(post)
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            showAlert = true
            alertMsg = "Updated Data!"
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
