//
//  QuestionView.swift
//  OpennQuizz
//
//  Created by Sarah AURIBOT on 20/12/2020.
//

import UIKit

class QuestionView: UIView {
    
    
    enum Style {
        case correct, incorrect, standard // 3 vues possibles
    }
    
    var style: Style = .standard {
        didSet {
            setStyle(_style: style)
        }
    }
    
    private func setStyle (_style: Style) {
        switch style {
            case .correct:
                backgroundColor = UIColor(red: 200/255, green: 236/255, blue: 160/235, alpha: 1) // on divise par 255 car il y a 255 tonalités de chacune des trois couleurs et on cherche en paramètre un nombre entre 0 et 1. alpha représente l'opacité, 1 = opaque
                icon.image = UIImage(named: "Icon Correct")
                icon.isHidden = false
            case .incorrect:
                backgroundColor = #colorLiteral(red: 0.9505828023, green: 0.5278267264, blue: 0.5829629302, alpha: 1) // autre méthode avec color litteral
                icon.image = #imageLiteral(resourceName: "Icon Error") // autre méthode avec image litteral
                icon.isHidden = false
            case .standard:
                backgroundColor = #colorLiteral(red: 0.5571179986, green: 0.5771594048, blue: 0.5853014588, alpha: 1)
                icon.isHidden = true // l'image est cachée
        }
    }
    
    var title = "" {
        didSet {
            label.text = title // dès que title est modifié, le text du label l'est également
        }
    }
    // observer les propriétés = faire une action quand elle est modifiée avec willSet (avant modification) et didSet (après)
    
    @IBOutlet private var label: UILabel! // optionnelle déballée : on ne connait pas la valeur mais on est sur que ce n'est pas nil
    @IBOutlet private var icon: UIImageView!
    

}
