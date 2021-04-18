//
//  ViewController.swift
//  TextViewMaximumTest
//
//  Created by 위대연 on 2021/04/13.
//

import UIKit

class ViewConroller: UIViewController {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var nextButton:UIButton!
    
    var streamReader:StreamReader!
    var maxTextCount:Int = 1
    var testStringHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = Bundle.main.url(forResource: "testFile", withExtension: "txt")!
        self.streamReader = StreamReader(url: fileUrl)
        
        self.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.textView.font = UIFont.systemFont(ofSize: 17)
        
        self.textView.text = ""
        self.textView.contentSize = CGSize(width: self.textView.bounds.width, height: 0)
        let testString = NSString("A")
        
        self.testStringHeight = testString.size(withAttributes: [NSAttributedString.Key.font : self.textView.font! as UIFont]).height
        
        while self.textView.contentSize.height <= (self.textView.frame.height - self.testStringHeight) {
            textView.text += "A"
        }
        
        self.maxTextCount = self.textView.text.count
        self.textView.text = ""
        
        self.textView.isScrollEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.load(stream: &self.streamReader)
    }
    
    func load(stream:inout StreamReader) {
        while (true) {
            if textView.contentSize.height < (self.textView.frame.height - self.testStringHeight) {
                if let nextLine = stream.nextLine() {

                    self.textView.text += nextLine + "\n"
                } else {
                    print("end")
                    nextButton.isEnabled = false
                    break;
                }
            } else {
                break;
            }
        }
    }
    
    @objc func buttonAction() {
        self.textView.text = ""
        self.textView.isScrollEnabled = true
        self.load(stream: &self.streamReader)
    }

    deinit {
        self.streamReader = nil
    }
}
/*
class ViewController: UIViewController {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var textView:UITextView!
    @IBOutlet weak var nextButton:UIButton!
    
    var fileInfo:FileInfo!
    var maxTextCount:Int = 1
    var currentTextCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.textView.font = UIFont.systemFont(ofSize: 17)
        
        self.textView.text = ""
        self.textView.contentSize = CGSize(width: self.textView.bounds.width, height: 0)
        let testString = NSString("A")
        
        let testStringHeight = testString.size(withAttributes: [NSAttributedString.Key.font : self.textView.font! as UIFont]).height
        
        while textView.contentSize.height <= (self.textView.frame.height - testStringHeight) {
            textView.text += "A"
        }
        
        self.maxTextCount = textView.text.count
        self.textView.text = ""
        print(self.maxTextCount)
        
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
            if self.textView.contentSize.height < self.textView.frame.height {
                let bytesRead = getline(&fileInfo.lineByteArrayPointer, &fileInfo.lineCap, fileInfo.filePointer)
                print("\(fileInfo.filePointer) \(fileInfo.lineByteArrayPointer), \(fileInfo.lineCap): \(textView.contentSize.height) : \(self.textView.frame.height)")
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

*/
