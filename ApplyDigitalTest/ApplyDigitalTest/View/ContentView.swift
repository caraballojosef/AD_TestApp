//
//  ContentView.swift
//  ApplyDigitalTest
//
//  Created by Jose Caraballo on 8/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - Properties
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var postViewModel: PostViewModel
    
    ///Loading saved data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Post.timestamp, ascending: true)],
        animation: .default)
    
    private var posts: FetchedResults<Post>

    //MARK: - Body
    
    var body: some View {
        NavigationView {
            Group {
                    ZStack {
                        List {
                            ForEach(posts) { item in
                                ZStack {
                                    NavigationLink(destination: WebView(urlString: item.story_url ?? "")) {
                                        EmptyView()
                                    }
                                    .opacity(0.0)
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    HStack {
                                        PostView(post: item)
                                    }
                                } //ZStack
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button(role: .destructive,
                                           action: { postViewModel.deleteItems(post: item, context: viewContext) } ) {
                                            Label("Delete", systemImage: "trash")
                                          }
                                }
                            } //Foreach
                            //.onDelete(perform: deleteItems)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear) // remove list background
                        } // List
                        .scrollContentBackground(.hidden)
                        .listStyle(InsetGroupedListStyle()) // change list style
                        .shadow(color: Color(red:0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                        .refreshable() {
                            postViewModel.getPost(context: viewContext)
                        }
                    } //Zstack
                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            EditButton()
//                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                //postViewModel.getPost(context: viewContext)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    } //toobar
                    .navigationTitle("Posts")
                    .toolbarBackground(
                        Color.green,
                        for: .navigationBar
                    ) //ToolbarStyle
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .top, endPoint: .bottom)
                            .ignoresSafeArea()
                    ) //background Gradient
                    .navigationViewStyle(StackNavigationViewStyle())
                    .onAppear {
                        if posts.isEmpty {
                            withAnimation(Animation.easeOut(duration: 0.8)) {
                                postViewModel.getPost(context: viewContext)
                            }
                        }
                        
                    }//: onAppear
                    .alert(postViewModel.isError ? Text("Error") : Text("Success"),
                           isPresented: $postViewModel.showAlert,
                           actions: {
                            Button("OK", role: .cancel) {
                                postViewModel.showAlert.toggle()
                            }
                    }, message:{
                        Text(postViewModel.alertMsg)
                            .font(.system(.headline, design: .rounded))
                    }) //Alert
                    .overlay {
                        if postViewModel.isRefreshing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                .padding()
                                .background(
                                    Color.gray
                                )
                                .cornerRadius(15)
                                .scaleEffect(3)
                        }
                    }
//                    .popover(isPresented: $postViewModel.added) {
//                        Text("Nuevo Post Guardado")
//                            .font(.headline)
//                            .padding()
//                    }
            } // Group
            
            
        } //: NAV
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { posts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

    //MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
