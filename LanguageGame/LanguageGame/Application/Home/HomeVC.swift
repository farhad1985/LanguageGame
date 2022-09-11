//
//  HomeVC.swift
//  LanguageGame
//
//  Created by Farhad on 9/8/22.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    // MARK: - Views
    private var wordLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.text = "word"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20.0, weight: .semibold)
        return lbl
    }()
    
    private var translationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.text = "word"
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 23.0, weight: .bold)
        return lbl
    }()
    
    private var correctButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("correct", comment: "correct"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.systemGreen.cgColor
        return btn
    }()
    
    private var wrongButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("wrong", comment: "wrong"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.systemRed.cgColor
        return btn
    }()
    
    private var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private var topScoreView: TopScoreView = {
        let topScoreView = TopScoreView()
        topScoreView.translatesAutoresizingMaskIntoConstraints = false
        return topScoreView
    }()
    
    // MARK: - Variabels
    var delegateAppCoordinator: AppCoordinator?
    
    private var viewModel: HomeViewModel?
    private var bindings = Set<AnyCancellable>()
    private let margin: CGFloat = 16.0
    
    private var translationTopConstraint: NSLayoutConstraint?
    
    // MARK: - initialize
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        setupBindings()
        
        startGame()
    }
    
    // MARK: - Functions
    private func configView() {
        self.view.backgroundColor = .white
        
        makeTopScore()
        makeTranslationRelatedLabels()
        makeButtons()
    }
    
    private func makeTopScore() {
        view.addSubview(topScoreView)
        
        NSLayoutConstraint.activate([
            topScoreView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor),
            
            topScoreView.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor),
            
            topScoreView.topAnchor.constraint(
                equalTo: self.view.topAnchor,
                constant: margin),
            
            topScoreView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func makeTranslationRelatedLabels() {
        
        self.view.addSubview(wordLabel)
        self.view.addSubview(translationLabel)
        
        translationTopConstraint = translationLabel
            .topAnchor
            .constraint(equalTo: view.topAnchor, constant: 0)
        
        translationTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            wordLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: margin),
            
            wordLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -margin),
            
            wordLabel.centerYAnchor.constraint(
                equalTo: self.view.centerYAnchor,
                constant: -margin),
            
            translationLabel.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: margin),
            
            translationLabel.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -margin),
        ])
        
    }
    
    private func startAnimation() {
        translationTopConstraint?.constant = -30
        view.layoutIfNeeded()
        
        UIView.transition(with: self.translationLabel,
                          duration: TimeInterval(viewModel?.gameTime ?? 0),
                          options: .curveEaseIn) { [weak self] in
            
            self?.translationTopConstraint?.constant = UIScreen.main.bounds.height
            self?.view.layoutIfNeeded()
        }
        
    }
    
    private func stopAnimation() {
        translationLabel.layer.removeAllAnimations()
    }
    
    private func makeButtons() {
        correctButton.addTarget(self, action: #selector(correctTapped),
                                for: .touchUpInside)
        
        bottomStack.addArrangedSubview(correctButton)
        
        wrongButton.addTarget(self, action: #selector(wrongTapped),
                              for: .touchUpInside)
        
        bottomStack.addArrangedSubview(wrongButton)
        
        bottomStack.spacing = margin
        
        view.addSubview(bottomStack)
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            bottomStack.heightAnchor.constraint(equalToConstant: 40.0),
            
            bottomStack.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 2*margin),
            
            bottomStack.trailingAnchor.constraint(
                equalTo: self.view.trailingAnchor,
                constant: -2*margin),
            
            bottomStack.bottomAnchor.constraint(
                equalTo: margins.bottomAnchor,
                constant: -margin),
        ])
    }
    
    private func showFinishMatch() {
        let result = viewModel?.resultMatch ?? ""
        
        delegateAppCoordinator?
            .gameFinished(message: result) { [weak self] _ in
                self?.startGame()
            }
        
    }
    
    // MARK: - Binding
    private func setupBindings() {
        
        viewModel?.$correctAttempts
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] correctAttempts in
                self?.topScoreView.setValue(score: correctAttempts, isCorrect: true)
            })
            .store(in: &bindings)
        
        viewModel?.$wrongAttempts
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] wrongAttempts in
                self?.topScoreView.setValue(score: wrongAttempts, isCorrect: false)
            })
            .store(in: &bindings)
        
        viewModel?.$currentWord
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] currentWord in
                if currentWord != nil {
                    self?.stopAnimation()
                    self?.setWord(currentWord)
                    self?.startAnimation()
                }
            })
            .store(in: &bindings)
        
        viewModel?.$isFinished
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isFinished in
                if isFinished {
                    self?.stopGame()
                    self?.showFinishMatch()
                }
            })
            .store(in: &bindings)
    }
    
    private func stopGame() {
        viewModel?.stopGame()
        translationLabel.isHidden = true
        stopAnimation()
    }
    
    private func startGame() {
        translationLabel.isHidden = false
        viewModel?.resetGame()
    }
    
    private func setWord(_ word: RandomWord?) {
        translationLabel.text = word?.spanish
        wordLabel.text = word?.english
    }
    
    // MARK: - Selectors
    @objc private func correctTapped() {
        viewModel?.answer(isCorrect: true)
        viewModel?.restTimer()
    }
    
    @objc private func wrongTapped() {
        viewModel?.answer(isCorrect: false)
        viewModel?.restTimer()
    }
}
