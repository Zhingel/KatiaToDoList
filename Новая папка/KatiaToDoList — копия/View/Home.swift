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
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    habitBar(value: value)
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .frame(width: .none, height: homeData.isNewData ? 270 + 1.1*homeData.containerHeight : 70)
                            .animation(.linear)
                        VStack {
                        HStack {
                            Spacer()
                            Button(action: {homeData.isNewData.toggle()}, label: {
                                Image(systemName: "plus")
                                        .font(.largeTitle)
                                    .foregroundColor(Color(red: 0.631, green: 0.086, blue: 0.8))
                            })
                  //          .offset(x: 0, y:  homeData.isNewData ? -65 - 1.1*containerHeight/2 : 0)
                            Spacer()
                    }
                        .padding()
                        if homeData.isNewData {
                            
                                TextField("Бегать по утрам, спать 8 часов и т.п.", text: $homeData.title)
                                    .padding(.horizontal)
                                    .padding(.top,11)
                                    
                            AutoSizingTF(hint: "Editin", text: homeData.text)
                                    .padding(.horizontal)
                                    .frame(height: homeData.containerHeight)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .padding()
                                HStack {
                                    ForEach(0..<5) { current in
                                            Button(action: {
                                                homeData.colorIndex = Double(current)
                                            }, label: {
                                                Image(systemName: homeData.colorIndex == Double(current) ? "largecircle.fill.circle":"circle.fill")
                                                    .font(.largeTitle)
                                                    .foregroundColor(homeData.colorArray[current])
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

                            }
                           
                            
                        }
                        .padding(.horizontal)
                            
                    }
                    
                    
//                    .padding(.horizontal, 40)
//                    .contentShape(RoundedRectangle(cornerRadius: 40))
            
                    ForEach(resuts) { task in
                       
                        
                            cardData(data: task)
                        
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.vertical,5)
                        
                            
                      
                        }
                    
                   
                    }
                }
                        .background(Color(red: 0.949, green: 0.949, blue: 0.969))
                        .navigationTitle("Сегодня")
            
            }
            
        }

    }



struct AutoSizingTF: UIViewRepresentable {
    @StateObject var homeData = HomeViewModel()
    func makeCoordinator() -> Coordinator {
        return AutoSizingTF.Coordinator(parent: self)
    }
    
    var hint: String
    
    var  text: String
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
            textView.text = hint
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 20)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async {
            if homeData.containerHeight == 0 {
                homeData.containerHeight = uiView.contentSize.height
            }
        }
    }
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : AutoSizingTF
        init(parent : AutoSizingTF) {
            self.parent = parent
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.hint {
                textView.text = ""
                textView.textColor = UIColor(Color.primary)
                
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.homeData.containerHeight = textView.contentSize.height
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = parent.hint
                textView.textColor = .gray
            }
        }
    }
}
