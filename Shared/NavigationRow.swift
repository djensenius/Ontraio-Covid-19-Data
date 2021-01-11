//
//  NavigationRow.swift
//  Ontario COVID-19 Data
//
//  Created by David Jensenius on 2021-01-10.
//

import SwiftUI

struct NavRow {
    var id: Int = 0
    var name: String = "Blah"

    var imageName: String = "Canada"
    var image: Image {
        Image(imageName)
    }

    init(id: Int, name: String, imageName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
    }
}

struct NavigationRow: View {
    var row: NavRow

    var body: some View {
        Label {
            Text(row.name)
        } icon: {
            Image(row.imageName)
        }
    }
}

/*
struct NavigationRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationRow()
    }
}
*/
