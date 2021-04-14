//
//  ViewController.swift
//  TextViewMaximumTest
//
//  Created by 위대연 on 2021/04/13.
//

import UIKit

struct FileInfo {
    let url:String
    var filePointer:UnsafeMutablePointer<FILE>? = nil
    var lineByteArrayPointer:UnsafeMutablePointer<CChar>? = nil
    var lineCap:Int = 0
    
    func close() {
        fclose(filePointer)
    }
}
class ViewController: UIViewController {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var nextButton:UIButton!
    
    var fileInfo:FileInfo!
    
    var textData:String? {
        let path = Bundle.main.path(forResource: "testFile", ofType: "txt")!
        return try? String(contentsOfFile: path)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.textView.isScrollEnabled = true
        let path = Bundle.main.path(forResource: "testFile", ofType: "txt")!
        guard let fP = fopen(path,"r") else {
            preconditionFailure("Could not open file at \(path)")
        }
        self.fileInfo = FileInfo(url: path, filePointer: fP, lineByteArrayPointer: nil, lineCap: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nextButton.isEnabled = true
        self.load(fileInfo: &self.fileInfo)
    }
    
    func load(fileInfo:inout FileInfo) {
        while (true) {
            print("\(fileInfo.lineCap): \(textView.contentSize.height) : \(self.textView.frame.height)")
            
            if self.textView.contentSize.height < self.textView.frame.height {
                let bytesRead = getline(&fileInfo.lineByteArrayPointer, &fileInfo.lineCap, fileInfo.filePointer)
                guard bytesRead > 0 else {
                    print("End")
                    self.nextButton.isEnabled = false
                    break;
                }
                let lineAsString = String.init(cString:fileInfo.lineByteArrayPointer!)
                self.textView.text.append(lineAsString)
            } else {
                break;
            }
        }
        textView.isScrollEnabled = false
    }
    
    @objc func buttonAction() {
        self.textView.text = ""
        self.textView.isScrollEnabled = true
        self.load(fileInfo: &fileInfo)
    }

    deinit {
        fileInfo.close()
    }
}

