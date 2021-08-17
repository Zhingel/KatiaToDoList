//
//  cardData.swift
//  KatiaToDoList
//
//  Created by Стас Жингель on 15.08.2021.
//

import SwiftUI

struct cardData: View {
    @ObservedObject var homeData = HomeViewModel()
    @Environment(\.managedObjectContext) var context
    var data : Task!
    var body: some View {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.title ?? "")
                                .font(.headline)
                            Spacer()
                            if data.toDo != "Edit text" && data.toDo != ""{
                                Text(data.toDo ?? "")
                                    .padding(.horizontal)
                                    .frame(width: 250, height: CGFloat(data.containerHeight+50), alignment: .topLeading)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding()
                            }
//                            AutoSizingTF(homeData: homeData)
//                                    .padding(.horizontal)
//                                    .frame(height:CGFloat(data.containerHeight))
//                                    .background(Color.white)
//                                    .cornerRadius(10)
//                                    .padding()
                                Button(action: {
                                    homeData.delete(context: context, item: data)

                                }, label: {
                                    Text( "Удалить")
                                })
                            }
                            
                        Spacer()
                        Button(action: {data.check.toggle()
                            if data.check {
                                homeData.EditCheck(item: data)
                                homeData.writeCheck(context: context)
                            }
                        }) {
                            Image(systemName: data.check ? "checkmark.circle.fill" : "circle")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
        }
}

