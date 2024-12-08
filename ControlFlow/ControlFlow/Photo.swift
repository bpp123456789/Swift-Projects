//
//  Photo.swift
//  ControlFlow
//
//  Created by William Petrik on 12/4/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class Photo: Codable, Identifiable {
    @DocumentID var id: String?
    var imageURLString = ""
    
    init(id: String? = nil, imageURLString: String = "") {
        self.id = id
        self.imageURLString = imageURLString
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(id: "1", imageURLString: "https://experiencebasecamp.org/cdn/shop/products/iceclimbingfromglobearticle_629233aa-a0e9-47ac-8822-3a639cf80d91_1800x1800.jpg?v=1620057747")
        return newPhoto
    }
}
