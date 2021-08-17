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
        
            ZStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.white)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.title ?? "")
                                .font(.headline)
                            Spacer()
                            Text(data.toDo ?? "")
                                .padding(.horizontal)
                                .frame(height: homeData.containerHeight)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()
                            
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
                            }
                        }) {
                            Image(systemName: data.check ? "checkmark.circle.fill" : "circle")
                                .font(.largeTitle)
                        }
                    }
                    .padding()
                }
                .foregroundColor(homeData.colorArray[Int(data.colorIndex)])
                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
               
                
                }
               
                
            
        }
}

