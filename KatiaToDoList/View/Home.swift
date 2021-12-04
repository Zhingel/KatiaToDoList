//
//  Home.swift
//  KatiaToDoList
//
//  Created by Стас Жингель on 14.08.2021.
//

import SwiftUI

struct Home: View { @Environment(\.presentationMode) var presentationMode
    @State var editText: String = ""
    var value: Float {
    let checkedHabitsCount = resuts.filter { ctask in
        ctask.check
    }.count
    return Float(checkedHabitsCount) / Float(resuts.count)
}
    @StateObject var homeData = HomeViewModel()
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "check", ascending: true)], animation: .spring()) var resuts: FetchedResults<Task>
    @GestureState var isDragging = false
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 0.949, green: 0.949, blue: 0.969).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    habitBar(value: value)
                
                        
                        if homeData.isNewData {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
        //                            .frame(width: .none, height: homeData.isNewData ? 270 + 1.1*homeData.containerHeight : 70)
             //                       .animation(.linear)
                                
                            VStack {
                            HStack {
                                Spacer()
                                Button(action: {
                                    if homeData.title == "" {
                                        homeData.isNewData.toggle()
                                    } else {
                                        homeData.writeData(context: context)
                                    }
                                }, label: {
                                    Image(systemName: "plus")
                                            .font(.largeTitle)
                                        .foregroundColor(Color(red: 0.631, green: 0.086, blue: 0.8))
                                })
                     
                                Spacer()
                        }
                            .padding()
                                TextField("Бегать по утрам, спать 8 часов и т.п.", text: $homeData.title)
                                    .padding(15)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top,11)
                                    .padding(.horizontal)
                                    .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                                    .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                            AutoSizingTF(homeData: homeData)
                                    .padding(.horizontal)
                                    .frame(height: homeData.containerHeight)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding()
                                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                                HStack {
                                    ForEach(0..<5) { current in
                                            Button(action: {
                                                homeData.colorIndex = Double(current)
                                            }, label: {
//                                                Image(systemName: homeData.colorIndex == Double(current) ? "largecircle.fill.circle":"circle.fill")
//                                                    .font(.largeTitle)
//                                                    .foregroundColor(homeData.colorArray[current])
                                                Image("\(current)")
                                                    .resizable()
                                                    .clipShape(Circle())
                                                    .frame(width: 50 , height: 50)
                                                    .overlay(  homeData.colorIndex == Double(current) ? Circle().stroke(Color.black, lineWidth: 3) : Circle().stroke(homeData.colorArray[current], lineWidth: 3))
                                                    .opacity(homeData.colorIndex == Double(current) ? 0.5 : 1)
                                                    
                                            })
                                            }
                                    Spacer()
                                }
                                .padding(.top)
                                .padding(.horizontal)
                                Button(action: {homeData.writeData(context: context)}) {
                                    Text("Сохранить")
                                }
                                .padding(.bottom)
                                .disabled(homeData.title == "" ? true : false)
                                .opacity(homeData.title == "" ? 0.5 : 1)
                                .padding(.top)
                            }.padding(.horizontal)
                        }
                        
                        } else { ZStack {
                            Rectangle()
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
   
                        HStack {
                            Spacer()
                            Button(action: {homeData.isNewData.toggle()}, label: {
                                Image(systemName: "plus")
                                        .font(.largeTitle)
                                    .foregroundColor(Color(red: 0.631, green: 0.086, blue: 0.8))
                            })
                 
                            Spacer()
                        }.padding(.vertical)
                        }}
                    
                    ForEach(resuts) { task in
                        ZStack {
                            Color.red
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.vertical,5)
                            HStack {
                                Spacer()
                                Button(action: {homeData.delete(context: context, item: task)}
                                       , label: {
                                    Image(systemName: "xmark.bin.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(.horizontal,40)
                                })
                            }
                            ZStack {
                                    Rectangle()
                                        .foregroundColor(Color.white)
                                        .cornerRadius(10)
                                        
                        //   if task.isPressed == false {
                                cardData(data: task)
//                            } else {
//                               cardDataChange(data: task)
//                           }
                                }
//                                    .onLongPressGesture(minimumDuration: 1.2) {
//                                    task.isPressed = true
//                                }
                           
                            .offset(x: CGFloat(task.offset))
                            .gesture(DragGesture() .updating($isDragging, body: {(value, state,_)  in
                                state = true
                                if value.translation.width < 0 && isDragging{
                                    task.offset = Float(value.translation.width)
                                }})
//                                        .onChanged {value in  if value.translation.width < 0 {
//                                task.offset = Float(value.translation.width)
//                            }}
                            .onEnded{value in withAnimation {
                                withAnimation(.easeOut) {
                                    if -value.translation.width >= 60  {
                                       task.offset = -80
                                   } else {
                                       task.offset = 0
                                           
                                   }
                                }
                            }})
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .padding(.vertical,5)
    //                            .onTapGesture {
    //                                task.isPressed.toggle()
    //                            }
                                .foregroundColor(homeData.colorArray[Int(task.colorIndex)])
                                .shadow(color: .black.opacity(0.08), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.08), radius: 5, x: -5, y: -5)
                        }
                        .onTapGesture(perform: {
                            task.offset = 0
                        })
                        
                        }
                    }
                        .navigationTitle("Сегодня")
            }
            }.onTapGesture {self.endTextEditing()}
            
        }
    }
}



extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}


