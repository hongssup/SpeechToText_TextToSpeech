//
//  Languages.swift
//  SpeechTest
//
//  Created by SeoYeon Hong on 2021/12/29.
//

import Foundation
import NaverSpeech

//Languages for Naver CLOVA Speech Recognition(CSR)
open class Languages {
    
    public init() {
        languages = [.korean: "Korean", .japanese: "Japanese", .english: "English", .simplifiedChinese: "Simplified Chinese"]
    }
    
    // MARK: - public
    open var count: Int {
        return self.languages.count
    }
    open var selectedLanguageString: String {
        if let language = self.languages[self._selectedLanguage] {
            return language
        }
        return "Korean"
    }
    open var selectedLanguage: NSKRecognizerLanguageCode {
       return self._selectedLanguage
    }
    
    open func languageString(at index: Int) -> String {
        if let code = NSKRecognizerLanguageCode(rawValue: index),
            let string = self.languages[code] {
            return string
        }
        return "Korean"
    }
    
    open func selectLanguage(at index: Int) {
        if let language = NSKRecognizerLanguageCode(rawValue: index) {
            self._selectedLanguage = language
        }
    }

    // MARK: - private
    fileprivate let languages: [NSKRecognizerLanguageCode: String]
    fileprivate var _selectedLanguage: NSKRecognizerLanguageCode = .korean
    
}
