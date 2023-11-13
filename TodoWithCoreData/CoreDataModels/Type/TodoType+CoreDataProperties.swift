//
//  TodoType+CoreDataProperties.swift
//  TodoWithCoreData
//
//  Created by Iskandarov shaxzod on 12.11.2023.
//
//

import Foundation
import CoreData


extension TodoType {
    
    @NSManaged public var name: String?
    @NSManaged public var todos: Set<Todo>?
    //Transient property
    @objc var todosCount: Int {
        willAccessValue(forKey: "todos")
        let count = todos?.count ?? 0
        didAccessValue(forKey: "todos")
        return count
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoType> {
        return NSFetchRequest<TodoType>(entityName: "TodoType")
    }

    static func fetchAllTypes() -> NSFetchRequest<TodoType> {
        return NSFetchRequest(entityName: "TodoType")
    }
    
    static func saveNewType(type name: String, with context: NSManagedObjectContext) throws {
        let newType = self.init(context: context)
        newType.name = name
        try context.save()
    }
    
    static func deleteType(type: TodoType, with context: NSManagedObjectContext) throws {
        context.delete(type)
        try context.save()
    }

}

// MARK: Generated accessors for todos
extension TodoType {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}

extension TodoType : Identifiable {}
