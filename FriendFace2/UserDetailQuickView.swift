//
//  UserDetailQuickView.swift
//  FriendFace
//
//  Created by RqwerKnot on 11/03/2022.
//

import SwiftUI

struct UserDetailQuickView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let user: CachedUser
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    Image("userFace")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100)
                    
                    VStack(alignment: .leading) {
                        Text(user.nameUnwrapped)
                            .font(.title.bold())
                        
                        Text(user.emailUnwrapped)
                            .font(.headline)
                        
                        HStack {
                            Text("\(user.age) ans")
                                .font(.title3)

                            Text("working at: \(user.companyUnwrapped)")
                                .foregroundColor(.secondary)
                        }

                        Text(user.addressUnwrapped)
                            .font(.caption2)
                    }
                }
                
                List {
                    Section {
                        Text(user.aboutUnwrapped)
                    } header: {
                        Text("About me")
                    }
                    
                    Section {
                        ForEach(user.friendsArray) { friend in
                            Text(friend.nameUnwrapped)

                        }
                    } header: {
                        Text("My friends")
                    }
                    
                    Section {
                        ForEach(user.tagsUnwrapped) { tag in
                            Text(tag)
                        }
                    } header: {
                        Text("Tags")
                    }
                    
                }
                .listStyle(.grouped)
            }
            .navigationTitle(user.isActive ? "Online" : "Offline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close"){
                        dismiss()
                    }
                }
                
            }
        }
    }
}

//struct UserDetailQuickView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailQuickView(user: User.hawkins)
//    }
//}
