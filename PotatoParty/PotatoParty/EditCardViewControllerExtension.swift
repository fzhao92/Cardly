//
//  EditCardViewControllerExtension.swift
//  PotatoParty
//
//  Created by Forrest Zhao on 11/22/16.
//  Copyright © 2016 ForrestApps. All rights reserved.
//
import UIKit
import SnapKit

extension EditCardViewController {
    
    func layoutViewElements() {
        view.backgroundColor = UIColor.clear
        
        view.addSubview(playerView)
        playerView.frame = self.view.frame
        playerView.backgroundColor = UIColor.yellow
        playerView.playerLayer.frame = playerView.bounds
        
        playPauseButton.setTitle("Play", for: .normal)
        playPauseButton.backgroundColor = UIColor.red
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(self.playPauseButton.snp.width).dividedBy(2)
            make.bottomMargin.equalToSuperview().offset(-20)
            make.leadingMargin.equalToSuperview()
        }
        playPauseButton.addTarget(self, action: #selector(self.playPauseButtonPressed), for: .touchUpInside)
        
        saveButton.backgroundColor = UIColor.red
        saveButton.setTitle("Save", for: .normal)
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(playPauseButton.snp.height)
            make.width.equalTo(playPauseButton.snp.width)
            make.bottomMargin.equalToSuperview().offset(-20)
            make.trailingMargin.equalToSuperview()
        }
        saveButton.addTarget(self, action: #selector(self.navToSendCardVC), for: .touchUpInside)
    }
}
