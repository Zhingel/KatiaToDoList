//
//  HomeViewModel.swift
//  KatiaToDoList
//
//  Created by Стас Жингель on 14.08.2021.
//

import SwiftUI
import CoreData

class HomeViewModel : ObservableObject {
    @Published var title = ""
    @Published var colorIndex = 0.00
    @Published var check = false
    @Published var isNewData = false
    @Published var toDo = "Edit text"
@Published var isPressed = false
    @Published var updateItem: Task!
    @Published var taskDelete = false
    @Published var containerHeight: CGFloat = 50
    let colorArray = [Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)), Color(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))]
    
    func writeData(context: NSManagedObjectContext) {
        
        //updating
        if updateItem != nil {
            updateItem.colorIndex = colorIndex
            updateItem.title = title
            updateItem.toDo = toDo
            updateItem.containerHeight = Float(containerHeight)
            try! context.save()
            updateItem = nil
            isNewData.toggle()
        }
        
        else {
            let newTask = Task(context: context)
            newTask.title = title
            newTask.colorIndex = colorIndex
            newTask.toDo = toDo
            newTask.containerHeight = Float(containerHeight)
            
            do {
                try context.save()
                isNewData.toggle()
                title = ""
                toDo = "Edit text"
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func writeCheck(context: NSManagedObjectContext) {
        
        //updating
        if updateItem != nil {
            updateItem.check = check
            try! context.save()
            updateItem = nil
            
        }
        
    }
   func EditCheck(item: Task) {
        updateItem = item
        check = item.check


    }
    func isPressed(item: Task) {
        updateItem = item
        isPressed = item.isPressed

    }

//    func EditItem(item: Task) {
//        updateItem = item
//        colorIndex = item.colorIndex
//        toDo = item.toDo!
//        title = item.title!
//        isNewData.toggle()
//
//    }
    func delete(context: NSManagedObjectContext, item: Task)  {
        context.delete(item)
        try! context.save()
        
    }
    
}
struct AutoSizingTF: UIViewRepresentable {
    @StateObject var homeData = HomeViewModel()
    func makeCoordinator() -> Coordinator {
        return AutoSizingTF.Coordinator(parent: self)
    }
    
   
//    var  text: String
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.text = homeData.toDo
        textView.textColor = .gray
        textView.font = .systemFont(ofSize: 15)
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
            if textView.text == parent.homeData.toDo {
                textView.text = ""
                textView.textColor = UIColor(Color.primary)
               
                
            }
        }
        func textViewDidChange(_ textView: UITextView) {
            parent.homeData.toDo = textView.text
            parent.homeData.containerHeight = textView.contentSize.height
            
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = parent.homeData.toDo
                textView.textColor = .gray
               
            }
        }
    }
}


