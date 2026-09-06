//
//  MainView.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import UIKit
import CRRefresh

protocol SongItemInterface: SongViewCellInterface {}

protocol MainViewDelegate: AnyObject {
    // Tabel
    func MainView(_ view: MainView, _ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func RefreshLoad()
    func LoadMore()
}

protocol MainViewDataSource: AnyObject {
    // Tabel
    func MainView(_ tableView: UITableView, view: MainView, numberOfRowsInSection section: Int) -> Int
    func MainView(_ view: MainView, cellForRowAt indexPath: IndexPath) -> SongItemInterface
    func MainView(_ view: MainView, isCurrentPlayingAt indexPath: IndexPath) -> (isCurrent: Bool, isPlaying: Bool)
    func MainView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
}

extension MainViewDataSource {
    func MainView(_ view: MainView, isCurrentPlayingAt indexPath: IndexPath) -> (isCurrent: Bool, isPlaying: Bool) {
        return (false, false)
    }
    func MainView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}

class MainView: UIView {
    
    @IBOutlet weak var tblListSongs: UITableView!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var vwNoListSongs: UIView!
    @IBOutlet weak var scrlView: UIScrollView!
    
    weak var delegate: MainViewDelegate?
    weak var dataSource: MainViewDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func reloadTableData() {
        tblListSongs.reloadData()
    }
    
    func refreshStop() {
        tblListSongs.cr.endHeaderRefresh()
        scrlView.cr.endHeaderRefresh()
        tblListSongs.cr.resetNoMore()
    }
    
    func refreshStart() {
        tblListSongs.cr.beginHeaderRefresh()
    }
    
    func endLoadingMore() {
        tblListSongs.cr.endLoadingMore()
    }
    
    func noticeNoMoreData() {
        tblListSongs.cr.noticeNoMoreData()
    }
    
    func resetNoMoreData() {
        tblListSongs.cr.resetNoMore()
    }
}

extension MainView {
    private func setupLayout() {
        setupLayoutConstraint()
        registerCell()
        registerListener()
        
        ivSearch?.image = UIImage(systemName: "magnifyingglass") ?? UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        ivSearch?.tintColor = .secondaryLabel
        
        tfSearch.placeholder = "Search songs, artists, or albums..."
        vwSearch.setSquaredTextCustom(radius: 8, brdrColor: "borderLine", bgColor: "bg_white")
        
        tblListSongs.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.actionRefreshListener()
        }
        
        tblListSongs.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.actionLoadMoreListener()
        }
        
        scrlView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            self?.actionRefreshListener()
        }
    }
    
    private func setupLayoutConstraint() {
        self.layoutIfNeeded()
    }
    
    private func registerCell() {
        // Tabel
        let songViewCell = UINib(nibName: "SongViewCell", bundle: nil)
        tblListSongs.register(songViewCell, forCellReuseIdentifier: "SongViewCell")
        tblListSongs.delegate = self
        tblListSongs.dataSource = self
        tblListSongs.separatorInset = .zero
        tblListSongs.directionalLayoutMargins = .zero
        tblListSongs.layoutMargins = .zero
    }
    
    private func registerListener() {
        //btn.addTarget(self, action: #selector(actionUpdateListener(_:)), for: .touchUpInside)
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.MainView(self, tableView, didSelectRowAt: indexPath)
    }
    
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.MainView(tableView, view: self, numberOfRowsInSection: section) ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongViewCell", for: indexPath) as? SongViewCell
        else { return UITableViewCell() }
        
        cell.interface = dataSource?.MainView(self, cellForRowAt: indexPath)
        if let playingInfo = dataSource?.MainView(self, isCurrentPlayingAt: indexPath) {
            cell.setPlayingState(isCurrent: playingInfo.isCurrent, isPlaying: playingInfo.isPlaying)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.MainView(tableView, titleForHeaderInSection: section)
    }
}

extension MainView {
    @objc private func actionRefreshListener() {
        delegate?.RefreshLoad()
    }
    
    @objc private func actionLoadMoreListener() {
        delegate?.LoadMore()
    }
}
