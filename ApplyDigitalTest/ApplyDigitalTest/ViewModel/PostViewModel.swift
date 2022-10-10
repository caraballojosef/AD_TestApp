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
    
    
//    func getDateTimeDiff(dateStr: String) -> String {
//
//        let formatter : DateFormatter = DateFormatter()
//
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//        let fmt = ISO8601DateFormatter()
//
//        let date1 = fmt.date(from: dateStr)!
//
//        let now = formatter.string(from: NSDate() as Date)
//
//        let endDate = formatter.date(from: now)
//
//        // *** create calendar object ***
//        var calendar = NSCalendar.current
//
//        // *** Get components using current Local & Timezone ***
//        print(calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1))
//
//        // *** define calendar components to use as well Timezone to UTC ***
//        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second])
//        calendar.timeZone = TimeZone(identifier: "UTC")!
//        let dateComponents = calendar.dateComponents(unitFlags, from: date1, to: endDate!)
//
//        // *** Get Individual components from date ***
//        let years = dateComponents.year!
//        let months = dateComponents.month!
//        let days = dateComponents.day!
//        let hours = dateComponents.hour!
//        let minutes = dateComponents.minute!
//        let seconds = dateComponents.second!
//
//        var timeAgo = ""
//
//        if (seconds > 0){
//            if seconds < 2 {
//                timeAgo = "1 sec ago"
//            }
//            else{
//                timeAgo = "\(seconds) secs ago"
//            }
//        }
//
//        if (minutes > 0){
//            if minutes < 2 {
//                timeAgo = "1 min Ago"
//            }
//            else{
//                timeAgo = "\(minutes) mins ago"
//            }
//        }
//
//        if(hours > 0){
//            if hours < 2 {
//                timeAgo = "1 hour ago"
//            }
//            else{
//                timeAgo = "\(hours) hours ago"
//            }
//        }
//
//        if (days > 0) {
//            if days < 2 {
//                timeAgo = "1 day ago"
//            }
//            else{
//                timeAgo = "\(days) days ago"
//            }
//        }
//
//        if(months > 0){
//            if months < 2 {
//                timeAgo = "1 month ago"
//            }
//            else{
//                timeAgo = "\(months) months ago"
//            }
//        }
//
//        if(years > 0){
//            if years < 2 {
//                timeAgo = "1 year ago"
//            }
//            else{
//                timeAgo = "\(years) years ago"
//            }
//        }
//
//        return timeAgo;
//    }

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
    
    
    func createPost(context: NSManagedObjectContext, hit: Hit) {
        let post = Post(context: context)
        post.id = UUID()
        
        if let title = hit.title {
            post.title = title
        } else {
            post.title = hit.storyTitle
        }
        
        if let url = hit.url {
            post.story_url = url
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
