//
//  Todo+CoreDataProperties.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//
//

import Foundation
import CoreData


extension Todo {
    
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var isChecked: Bool
    @NSManaged public var type: TodoType?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    static func saveNewTodo(title: String, type: TodoType, with context: NSManagedObjectContext) throws {
        let newTodo = self.init(context: context)
        newTodo.title = title
        newTodo.date  = Date()
        newTodo.isChecked = false
        newTodo.type = type
        try context.save()
    }
    
    static func deleteTodo(todo: Todo, with context: NSManagedObjectContext) throws {
        context.delete(todo)
        try context.save()
    }
    
    static func makeTodoChecked(todo: Todo, with context: NSManagedObjectContext) throws {
        todo.isChecked = true
        try context.save()
    }
    
    static func fetchAllCheckedTodos(of type: TodoType) -> NSFetchRequest<Todo> {
        return Self.fetchTodos(type: type, isChecked: true)
    }

    static func fetchAllUncheckedTodos(of type: TodoType) -> NSFetchRequest<Todo> {
        return Self.fetchTodos(type: type, isChecked: false)
    }
    
    //helper
    static private func fetchTodos(type: TodoType, isChecked: Bool) -> NSFetchRequest<Todo> {
        let titleSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let dateSortDescriptor  = NSSortDescriptor(key: "date", ascending: true)
        
        let predicate = NSPredicate(format: "%K == %@", "type.name", (type.name ?? ""))
        let isCheckedPredicate = NSPredicate(format: "%K == %@", "isChecked", NSNumber(value: isChecked))
        
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, isCheckedPredicate])
        let request = NSFetchRequest<Todo>(entityName: "Todo")
        
        request.predicate = combinedPredicate
        request.sortDescriptors = [titleSortDescriptor, dateSortDescriptor]
        return request
    }
    
}

extension Todo : Identifiable {}
