//
//  PostView.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import SwiftUI

struct PostView: View {
    
    //MARK: - Property
    var post: Post
    //MARK: - Body
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text(post.title ?? "Title")
                .font(.system(.title, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical, 5)
            
            HStack(alignment: .center, spacing: 5) {
                Text(post.author!)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .multilineTextAlignment(.leading)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .background(
                    LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .top, endPoint: .bottom)
                    )
                .cornerRadius(5)
                
                Text(post.timestamp!.convert(startDate: post.date!))
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
            }
            .padding()
            
        } //: Vstack
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(20)
    }
    

    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
   
    
}



struct PostView_Previews: PreviewProvider {
    let postElement: Post
    static var previews: some View {
        PostView(post: .init())
    }
}
