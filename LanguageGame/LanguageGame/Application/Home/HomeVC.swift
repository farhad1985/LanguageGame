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
    weak var delegateAppCoordinator: AppCoordinatorDelegate?
    
    private var viewModel: HomeViewModel?
    private var bindings = Set<AnyCancellable>()
    private let margin: CGFloat = 16.0
        
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
        
        viewModel?.resetGame()
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
        ])
    }

    private func makeTranslationRelatedLabels() {
        
        self.view.addSubview(wordLabel)
        self.view.addSubview(translationLabel)

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
            
            translationLabel.bottomAnchor.constraint(equalTo: wordLabel.topAnchor,
                                                     constant: -margin)
        ])
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
                    self?.setWord(currentWord)
                }
            })
            .store(in: &bindings)
        
        viewModel?.$isFinished
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isFinished in
                if isFinished {
                    self?.delegateAppCoordinator?.stopGame()
                }
            })
            .store(in: &bindings)
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

