//
//  openncard.swift
//  KatiaToDoList
//
//  Created by Стас Жингель on 16.08.2021.
//

import SwiftUI

struct openncard: View {
    @ObservedObject var homeData = HomeViewModel()
    @Environment(\.managedObjectContext) var context
    var data : Task!
    var body: some View {
                    HStack {
                        VStack {
                            Image("\(Int(data.colorIndex))")
                                .resizable()
                                .frame(width: 100, height:100)
                                .cornerRadius(10)
                            Spacer()
                        }
                          //  .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                            //    .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                        
                        VStack(alignment: .leading) {
                            Text(data.title ?? "")
                                .font(.headline)
                            Spacer()
                            if data.toDo != "Edit text" && data.toDo != ""{
                                Text(data.toDo ?? "")
                                  //  .padding(.horizontal)
                                    .frame(height: 20)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.bottom, 60)
                            }
      //                            AutoSizingTF(homeData: homeData)
//                                    .padding(.horizontal)
//                                    .frame(height:CGFloat(data.containerHeight))
//                                    .background(Color.white)
//                                    .cornerRadius(10)
//                                    .padding()
//                                Button(action: {
//                                    homeData.delete(context: context, item: data)
//
//                                }, label: {
//                                    Text( "Удалить")
//                                })
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

