//
//  RegistroDelegate.swift
//  
//
//  Created by Massimiliano Bonafede on 12/06/2020.
//

import UIKit

protocol RegistroDataSourceProtocol {
    func dataForPrepareSegue (run: Running)
    func passAlert()
}


class RegistroDataSource: NSObject {
    
    var organizer: DataOrganizer
    var delegate: RegistroDataSourceProtocol?
    
    init (running: [Running]) {
        self.organizer = DataOrganizer(running: running)
    }
    
    func run (at index: IndexPath) -> Running {
        organizer.item(at: index)
    }
    
}

extension RegistroDataSource {
    
    struct DataOrganizer {
        
        private var running: [Running]
        private var runningCounting: Int
        
        init(running: [Running]) {
            self.running = running
            
            self.runningCounting = running.count
        }
        
        
        func counting () -> Int {
            running.count
        }
        
        func item (at index: IndexPath) -> Running {
            running[index.row]
        }
    }
}


extension RegistroDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        organizer.counting()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell()}
        
        let row = organizer.item(at: indexPath)
        cell.configureRow(at: row)
        cell.delegate = self
        cell.delegateAlert = self
        
        return cell
    }
}


extension TableViewCell {
    
    func configureRow (at run: Running) {
        myRun = run
        dataGiornoLbl.text = "\(run.dataRun)"
        inizioCorsaLbl.text = "\(run.oraInizio)"
        fineCorsaLbl.text = "\(run.oraFine)"
        tempoTotaleLbl.text = "\(run.tempoTotale)"
        mediaVelocitaLbl.text = "\((run.mediaVelocita).twoDecimalNumbers(place: 1))"
        percorsoTotaleLbl.text = "\((run.totaleKm).twoDecimalNumbers(place: 3))"
        usernameLbl.text = "\(run.username)"
        commentsLbl.text = "\(run.numComments)"
        numLike.text = "\(run.userLike.count)"
    }
}


extension RegistroDataSource: MyButtonDelegate, AlertDelegate{
    
    func likeTwice() {
        delegate?.passAlert()
    }
    
    func opneCommentVC(for run: Running) {
        delegate?.dataForPrepareSegue(run: run)
    }
}