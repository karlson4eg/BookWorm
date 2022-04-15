//
//  AddBookView.swift
//  Bookworm
//
//  Created by Evi St on 4/15/22.
//

import SwiftUI

extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var dateAdded = Date.now
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Name of the book", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre){
                        ForEach(genres, id: \.self){
                            Text($0)
                        }
                    }
                }
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        // add the book
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        
                        try? moc.save()
                        dismiss()
                    }
                    .disabled(addBookFieldsAreValid() == false)
                }
                
            }.navigationTitle("Add Book")
        }
        
    }
    
    
    func addBookFieldsAreValid() -> Bool{
        if title.isEmptyOrWhitespace() || author.isEmptyOrWhitespace() || genre.isEmpty {
            return false
        }
        return true
    }

}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
