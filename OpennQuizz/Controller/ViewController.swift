//
//  ViewController.swift
//  OpennQuizz
//
//  Created by Sarah AURIBOT on 18/12/2020.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() { // est appelée quand le contrôleur a fini d'être chargé, ici au lancement de l'app
        super.viewDidLoad()
        
        let name = Notification.Name(rawValue: "QuestionsLoaded")
        NotificationCenter.default.addObserver(self, selector: #selector(questionsLoaded), name: name, object: nil) // recherche des notifications
        
        startNewGame()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragQuestionView(_:)))     // reconnait le geste
        questionView.addGestureRecognizer(panGestureRecognizer) // précise la vue qui doit détecter le geste
    
        
    }
    
    
    override func didReceiveMemoryWarning() { // est appellée quand le contrôleur doit retenir trop d'infos et qu'il n'y a plus de place en mémoire pour les stocker
        super.didReceiveMemoryWarning()
    }
 
    var game = Game()
    @IBOutlet weak var newGameButton: UIButton! // il y a toujours un optionnel déballé après un outlet.
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionView: QuestionView!
    @IBOutlet weak var answerView: AnswerView!
    
    @IBAction func didTapNewGameButton(_ sender: Any) {
        startNewGame()
    }
    
    private func startNewGame() {
        
        newGameButton.isHidden = true
        activityIndicator.isHidden = false
        
        questionView.title = "Loading..."
        questionView.style = .standard
        
        answerView.style = .standard
        
        scoreLabel.text = "0 / 10"
        
        game.refresh()
        
    }
    
    @objc func questionsLoaded() {
        
        activityIndicator.isHidden = true
        newGameButton.isHidden = false
        questionView.title = game.currentQuestion.title
        
    }
    
    
    @IBAction func dragQuestionView(_ sender: UIPanGestureRecognizer) { // fonction permettant de déplacer la vue
        
        if game.state == .ongoing { // on peut déplacer la vue seulement si une partie est en cours
            
            switch sender.state {
            case .began, .changed: // la vue doit suivre le doigt
                transformQuestionViewWith(gesture: sender)
            case .ended, .cancelled: // on enregistre la réponse choisie
                answerQuestion()
            default:
                break
            }
            
        }
    
    }
    
    private func transformQuestionViewWith(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: questionView) // on récupère la translation effectuée par le doigt
        let translationTransform = CGAffineTransform(translationX: translation.x, y: translation.y) // on crée une transformation de notre vue qui est de type translation, les paramètres sont ceux de la translation du doigt
        
        let screenWidth = UIScreen.main.bounds.width // on récupère la taille de l'écran
        let translationPercent = translation.x/(screenWidth / 2) // on calcule où l'on est par rapport au bord de l'écran. Cette valeur varie entre +100% et -100%
        let rotationAngle = (CGFloat.pi / 6) * translationPercent // ensuite on applique Pi/6 pour faire une rotationde 30%
        let rotationTransform = CGAffineTransform(rotationAngle: rotationAngle) // création de la rotation en fonction de la position du doigt (plus le doigt est sur un bord plus la rotation est importante)
        
        
        let transform = translationTransform.concatenating(rotationTransform) // on associe les deux transformations
        questionView.transform = transform
        
        if translation.x > 0 { // en fonction de la position de x (positive ou négative) on affecte le type de vue
            questionView.style = .correct
        } else {
            questionView.style = .incorrect
        }
        
    }
    


    private func answerQuestion() {
        
        //En fonction de la réponse du joueur on appeler la méthode answerCurrentQuestion
        switch questionView.style {
        case .correct:
            game.answerCurrentQuestion(with: true)
        case .incorrect:
            game.answerCurrentQuestion(with: false)
        case .standard:
            break
        }
        
        scoreLabel.text = "\(game.score) / 10 " // on affiche le score qui s'est actualisé grâce à answerCurrentQuestion
        
        // si le jour a bien répondu, on le lui indique
        if(questionView.style == .correct && game.currentQuestion.isCorrect) || (questionView.style == .incorrect && !game.currentQuestion.isCorrect) {
            answerView.style = .correct
        } else {
            answerView.style = .incorrect
        }
                
        
        let screenWidth = UIScreen.main.bounds.width // on récupère la taille de l'écran
        var translationTransform: CGAffineTransform
        if questionView.style == .correct { // si affichage vrai alors on applique une translation de la taille de l'écran à droite pour que la vue sorte de l'écran, inversement si faux
            translationTransform = CGAffineTransform(translationX: screenWidth, y: 0)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        // on crée l'animation pour réalisation la translation souhaitée (utilsation de fermeture)
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.transform = translationTransform
        }, completion: { (success) in // success est vrai si l'animation s'est bien déroulée
            if success {
                self.showQuestionView()
            }
        })
    }
    
    
    private func showQuestionView() {
        
        questionView.transform = .identity // idendity permet de remettre la vue à son état d'origine
        questionView.style = .standard // on remet en place la vue standard
        answerView.style = .standard
      
        
        switch game.state {
        case .ongoing:
            questionView.title = game.currentQuestion.title // on affiche la nouvelle question
        case .over:
            questionView.title = "Game over"
            answerView.style = .over
        case .win:
            questionView.title = "Win !"
            answerView.style = .win
        }
        
        questionView.transform = .identity // on ramène la vue au centre de l'écran
        questionView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) // on réduit la vue pour la faire disparaitre
        
        // on fait une animation avec un effet "boing" pouçr la faire réapparaitre
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.questionView.transform = .identity
        }, completion:nil)
        
    }
}

