//
//  TagDetails.swift
//  FriendFace
//
//  Created by RqwerKnot on 14/03/2022.
//

import SwiftUI

struct TagDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // tag to show detailsa bout:
    let tag: String
    
    // Users that are tagged with this tag:
    let users: [CachedUser]
    
    var body: some View {
        NavigationView {
            VStack {              
                List {
                    Section {
                        Text("Occaecat consequat elit aliquip magna laboris dolore laboris sunt officia adipisicing reprehenderit sunt. Do in proident consectetur labore. Laboris pariatur quis incididunt nostrud labore ad cillum veniam ipsum ullamco. Dolore laborum commodo veniam nisi.")
                    } header: {
                        Text("Description")
                    }
                    
                    Section {
                        ForEach(users) { user in
                            Text(user.nameUnwrapped)
                        }
                    } header: {
                        Text("Members")
                    }

                }
            }
            .navigationTitle(Text("#\(tag)"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//struct TagDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        TagDetailsView(tag: "cillum", users: User.users)
//    }
//}
