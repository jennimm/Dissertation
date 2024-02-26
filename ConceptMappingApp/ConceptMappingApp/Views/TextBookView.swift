//
//  TextBookView.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 16/11/2022.
//

import PDFKit
import SwiftUI
// code taken from: https://stackoverflow.com/questions/74959327/is-there-any-way-where-we-can-get-the-current-page-number-in-pdfview-and-use-it

struct PDFKitView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let data: Data
    let pdfView = PDFView()
    
    func makeUIView(context: Context) -> PDFView {
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        return pdfView
    }

    func updateUIView(_ view: UIViewType, context: Context) {
        view.document = PDFDocument(data: data)    }
}


struct TextBookView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(data: Data())
    }
}
