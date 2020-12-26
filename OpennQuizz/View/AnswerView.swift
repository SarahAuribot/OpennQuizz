//
//  AnswerView.swift
//  OpennQuizz
//
//  Created by Sarah AURIBOT on 23/12/2020.
//

import UIKit

class AnswerView: UIView {

    enum Style {
        case correct, incorrect, standard, over, win // 5 vues possibles
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(_style: style)
        }
    }
    
    private func setStyle (_style: Style) {
        switch style {
        case .correct:
            icon.image = UIImage(named: "Icon happy")
            label.text = "Correct !"
            icon.isHidden = false
            label.isHidden = false
        case .incorrect:
            icon.image = UIImage(named: "Icon unhappy")
            label.text = "Incorrect !"
            icon.isHidden = false
            label.isHidden = false
        case .standard:
            icon.isHidden = true
            label.isHidden = true
        case .over:
            icon.image = UIImage(named: "Icon over")
            label.isHidden = true
            icon.isHidden = false
        case .win:
            icon.image = UIImage(named: "Icon win")
            label.isHidden = true
            icon.isHidden = false
        }
    }
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
        
    
}
