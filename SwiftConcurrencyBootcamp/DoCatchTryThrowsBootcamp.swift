//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Christopher Walter on 8/31/23.
//

import SwiftUI

// do-catch
// try
// throws

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = true
    
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        }
        else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    // the keyword throws will allow us to throw an error and not necessarily return a String...
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT"
        } else {
            throw URLError(.badURL)
        }
        
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT"
        } else {
            throw URLError(.badURL)
        }
        
    }
}
class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        // Version 1
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
        */
        // Version 2
        /*
        let result = manager.getTitle2()
        switch result {
            case .success(let newTitle):
                self.text = newTitle
            case .failure(let error):
                self.text = error.localizedDescription
        }
         */
        // Version 3
        
        // try optionals do not need to be in do-catch statements
        let newTitle = try? manager.getTitle3()
        if let newTitle = newTitle {
            self.text = newTitle
        }
        do {
            // If you fail any of the try statements, you automatically jump to the catch and none of the code after the failed try in the do loop will not trigger. Marking the try as try? it will allow us to trigger both trys.
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
            
        } catch let error { // dont need to have let error if you want. the error is automatic...
            self.text = error.localizedDescription
        }
        
        
        
    }
}

struct DoCatchTryThrowsBootcamp: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
