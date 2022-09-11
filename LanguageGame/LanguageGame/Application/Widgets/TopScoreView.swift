//
//  TopScoreView.swift
//  LanguageGame
//
//  Created by Farhad on 9/10/22.
//

import UIKit

class TopScoreView: UIView {
    // MARK: - Views
    private var corretLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = .right
        lbl.font = .systemFont(ofSize: 14.0)
        return lbl
    }()
    
    private var wrongLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.textAlignment = .right
        lbl.font = .systemFont(ofSize: 14.0)
        return lbl
    }()
    
    private var topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8.0
        return stack
    }()
    
    // MARK: - Variables
    private let margin: CGFloat = 16.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - functions
    func setValue(score: Int, isCorrect: Bool) {
        if isCorrect {
            corretLabel.text = "\(NSLocalizedString("correctAttempts", comment: "correctAttempts")): \(score)"
        } else {
            wrongLabel.text = "\(NSLocalizedString("wrongAttempts", comment: "wrongAttempts")): \(score)"
        }
        
        topStack.layoutIfNeeded()
    }
    
    private func setupView() {
        topStack.addArrangedSubview(corretLabel)
        topStack.addArrangedSubview(wrongLabel)
        
        addSubview(topStack)
        
        NSLayoutConstraint.activate([
            topStack.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 0),
            
            topStack.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -margin),
            
            topStack.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: margin),
            
            topStack.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -margin),
            
        ])
    }
    
}
