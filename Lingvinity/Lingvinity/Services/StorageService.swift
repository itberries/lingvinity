//
//  StorageService.swift
//  Lingvinity
//
//  Created by Elena Oshkina on 09.12.2018.
//  Copyright © 2018 IT-Berries. All rights reserved.
//

import UIKit
import SQLite

// Сервис для работы с базой данных
class StorageService {

    
    var database : Connection!
    
    
     //-----------------------------------------
    //Создаем таблицу  words и колонки
    let wordsTable = Table("words")
    //Колонки для таблицы words
    let wordId  = Expression<Int>("word_id")
    let wordValue = Expression<String>("word_value")
    let wordDefinition = Expression<String>("word_definition")
    //-----------------------------------------
    
    
    //-----------------------------------------
    //Создаем таблицу  groups и колонки
    let groupsTable = Table("groups")
    //Колонки для таблицы words
    let groupId  = Expression<Int>("group_id")
    let groupValue = Expression<String>("group_value")
    //-----------------------------------------
    
    
    //-----------------------------------------
    //Создаем таблицу  wordsToGroups
    let wordsToGroups = Table("words_To_Groups")
    let wordGroupId  = Expression<Int>("word_group_id")
    //-----------------------------------------
    
    //Констуктор без параметров
    init()  {
        initDataBaseWork()
    }
    
    //Необходимые действия по установке соединения с БД
    func initDataBaseWork(){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //создаем файл words.sqlite3 - хранится локально
            let fileUrl = documentDirectory.appendingPathComponent("words").appendingPathExtension("sqlite")
            //создаем соединение с базой данной
            let database = try Connection(fileUrl.path)
            self.database = database
            
        } catch  {
            print(error)
        }
    }
    
    //Таблица уже создана
    func createTableWords() { // [wordId | wordValue| wordDefinition]
        print("CREATE TABLE")
        
        let createTable = self.wordsTable.create { (table) in
            table.column(self.wordId, primaryKey: true)
            table.column(self.wordValue)
            table.column(self.wordDefinition)
        }
        do{
            try self.database.run(createTable)
            print("Created Table Words")
        }catch{
            print(error)
        }
    }
    
    //Возможно, что потребуется добавить к таблице words еще один столбец image_id
//    func alterTableWords() { // [wordId | wordValue| wordDefinition|image_id]
//        print("ADD NEW COLUMN TABLE")
//        let imageId  = Expression<Int>("image_id")
//        do{
//            try self.database.run(self.wordsTable.addColumn(suffix)
//            print("Add new Column to Table Words")
//        }catch{
//            print(error)
//        }
//    }
    
    //Таблица уже создана
    func createTableGroups() { // [groupId | groupValue]
        print("CREATE TABLE GROUPS")
        
        let createTable = self.groupsTable.create { (table) in
            table.column(self.groupId, primaryKey: true)
            table.column(self.groupValue)
        }
        do{
            try self.database.run(createTable)
            print("Created Table Groups")
        }catch{
            print(error)
        }
    }
    
    //Таблица уже создана
    func createTableWordsToGroupsXref() { //многие ко многим [wordGroupId | wordId | groupId]
        print("CREATE TABLE WORD TO GROUPS XREF")
        
        let createTable = self.wordsToGroups.create { (table) in
            table.column(self.wordGroupId, primaryKey: true)
            table.column(self.groupId)
            table.column(self.wordId)
        }
        do{
            try self.database.run(createTable)
            print("Created Table Words to Groups")
        }catch{
            print(error)
        }
    }
    
    //insert в таблицу words -> слово на английском и перевод
    func addValueToTableWords(wordValue : String, wordDefinition : String ){
        let insertWord = self.wordsTable.insert(self.wordValue <- wordValue, self.wordDefinition<-wordDefinition)
        
        do{
            try self.database.run(insertWord)
            print("inserted word")
        }catch{
            print(error)
        }
    }
    
    //insert в таблицу groups -> наименование альбома на русском (альбом=группа)
    func addValueToTableGroups(groupValue : String){
        let insertGroupValue = self.groupsTable.insert(self.groupValue <- groupValue)
        do{
            try self.database.run(insertGroupValue)
            print("inserted group value")
        }catch{
            print(error)
        }
    }
    
    //добавление записей в таблицу многие ко многим (id слова, id группы)
    func addValueToTableWordsToGroups(wordId : Int, groupId : Int){
        let insertGroupValue = self.wordsToGroups.insert(self.groupId <- groupId, self.wordId <- wordId)
        do{
            try self.database.run(insertGroupValue)
            print("inserted groupId and wordId values to words_to_group table")
        }catch{
            print(error)
        }
    }
    
    //Показ содержимого таблицы words
    func listWords(){
        print("LIST WORDS TAPPED")
        
        do{
            let words = try self.database.prepare(self.wordsTable)
            for word in words{
                print("wordId: \(word[self.wordId]), word: \(word[self.wordValue]), definition: \(word[self.wordDefinition])")
            }
        }catch{
            print(error)
        }
    }
    
    //Показ содержимого таблицы groups
    func listGroups(){
        print("LIST GROUPS TAPPED")
        
        do{
            let groups = try self.database.prepare(self.groupsTable)
            for group in groups{
                print("groupId: \(group[self.groupId]), group value: \(group[self.groupValue])")
            }
        }catch{
            print(error)
        }
    }
    
    
    // update к таблице words, где id строки передается в параметре wordId
    //wordDefinition - перевод слова на русском, wordValue - значение на английском
    func updateTableWords(wordId : Int, wordDefinition : String, wordValue : String ) {
        
         let word = self.wordsTable.filter(self.wordId == wordId)
         let updateUser = word.update(self.wordDefinition<-wordDefinition, self.wordValue<-wordValue)
         
         do{
            try self.database.run(updateUser)
            print("word updated")
         }catch{
            print(error)
         }
    }
}