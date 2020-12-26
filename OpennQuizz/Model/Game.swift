//
//  Game.swift
//  OpennQuizz
//
//  Created by Sarah AURIBOT on 19/12/2020.
//

import Foundation

class Game {
    
    var score = 0
    
    private var question = [Question]()
    private var currentIndex = 0
    
    var currentQuestion: Question {
        return question[currentIndex]
    }
    
    var state: State = .ongoing

    enum State {
        case ongoing, over, win
    }
    
    func refresh () {
        score = 0
        currentIndex = 0
        state = .over
        
        QuestionManager.shared.get{(question) in // charge les question
            self.question = question
            self.state = .ongoing
            let name = Notification.Name(rawValue: "QuestionsLoaded")
            let notification = Notification(name: name)
            NotificationCenter.default.post(notification) // envoi de la notification
        }
        // on appelle la méthode get de la class QuestionManager et on passe en paramètre la méthode receiveQuestions. Lorsque les questions sont chargées, la méthode receiveQuestions est appelée. On a ensuite simlplifié en faisant une fermeture. A l'intérieur on fait une notification pour indiquer au modèle que les questions sont chargées
        
    }
 
    func answerCurrentQuestion (with answer: Bool) {
        if (currentQuestion.isCorrect == true && answer == true) || (!currentQuestion.isCorrect == true && !answer == true) {
            score += 1
        } 
        goToNextQuestion()
    }
    

    private func goToNextQuestion () {
        if currentIndex < question.count - 1 {
            currentIndex += 1
        } else {
            FinishGame()
        }
    }
    
    private func FinishGame () {
        if score == 10 {
            state = .win
        } else {
            state = .over
        }
    }
    
}

