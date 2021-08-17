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
    @Published var toDo = ""
    @Published var text = ""
    @Published var updateItem: Task!
    @Published var taskDelete = false
    @Published var containerHeight: CGFloat = 100
    let colorArray = [Color(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)),Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))]
    
    func writeData(context: NSManagedObjectContext) {
        
        //updating
        if updateItem != nil {
            updateItem.colorIndex = colorIndex
            updateItem.title = title
            updateItem.toDo = toDo
            try! context.save()
            updateItem = nil
            isNewData.toggle()
        }
        
        else {
            let newTask = Task(context: context)
            newTask.title = title
            newTask.colorIndex = colorIndex
            newTask.toDo = toDo
            
            do {
                try context.save()
                isNewData.toggle()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    func EditCheck(item: Task) {
        updateItem = item
        check = item.check
        
    }
    func EditItem(item: Task) {
        updateItem = item
        colorIndex = item.colorIndex
        toDo = item.toDo!
        title = item.title!
        isNewData.toggle()
        
    }
    func delete(context: NSManagedObjectContext, item: Task)  {
        context.delete(item)
        try! context.save()
        
    }
    
}

