//
//  MainVC.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import UIKit
import RxSwift

class MainVC: BaseViewController, StoryboardInstantiable, Alertable {
    
    private var delegate: MainVC!
    
    @IBOutlet var mainView: MainView!
    private var viewModel: MainVM!
    static let myNotification = Notification.Name(ConstantKey.KEY_LAYOUT_MAIN)
    
    var songList: [SongModel] = []
    private var currentSearchTerm: String = ""
    private var searchDebounceTimer: Timer?
    
    private let playerBarView: PlayerBarView = {
        let view = PlayerBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    static func create(with viewModel: MainVM) -> MainVC {
        let view = MainVC.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerProtocolers()
        setupViews()
        setupPlayerBar()
        initDataResponse()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationDialog(notification:)), name: MainVC.myNotification, object: nil)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: MainVC.myNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if songList.isEmpty {
            loadInitialData()
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        mainView.tfSearch.delegate = self
        mainView.tfSearch.returnKeyType = .search
        mainView.tfSearch.clearButtonMode = .whileEditing
        mainView.tfSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        mainView.tblListSongs.contentInset.bottom = 120
        mainView.scrlView.contentInset.bottom = 120
    }
    
    private func setupPlayerBar() {
        view.addSubview(playerBarView)
        
        NSLayoutConstraint.activate([
            playerBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playerBarView.heightAnchor.constraint(equalToConstant: 105)
        ])
        
        playerBarView.isHidden = true
        
        AudioPlayerService.shared.delegate = self
        
        playerBarView.onPlayPauseTapped = {
            AudioPlayerService.shared.togglePlayPause()
        }
        
        playerBarView.onNextTapped = {
            AudioPlayerService.shared.playNext()
        }
        
        playerBarView.onPreviousTapped = {
            AudioPlayerService.shared.playPrevious()
        }
        
        playerBarView.onSeek = { progress in
            AudioPlayerService.shared.seek(to: progress)
        }
        
        playerBarView.onCloseTapped = { [weak self] in
            guard let self = self else { return }
            AudioPlayerService.shared.pause()
            UIView.animate(withDuration: 0.25, animations: {
                self.playerBarView.alpha = 0
                self.playerBarView.transform = CGAffineTransform(translationX: 0, y: 40)
            }) { _ in
                self.playerBarView.isHidden = true
                self.playerBarView.transform = .identity
            }
            self.mainView.reloadTableData()
        }
    }
    
    private func loadInitialData() {
        currentSearchTerm = ""
        viewModel.getTopSongs()
    }
    
    private func performSearch(term: String) {
        let searchParam = SearchSongParam(term: term, media: "music", entity: "song", attribute: "songTerm", limit: 25)
        viewModel.getListSong(request: searchParam)
    }
    
    private func registerProtocolers() {
        mainView.delegate = self
        mainView.dataSource = self
    }
    
    // MARK: - NotificationCenterResponse
    @objc func onNotificationDialog(notification: Notification) {
    }
    
    // MARK: - initDataResponse
    private func initDataResponse() {
        viewModel.getListSongResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.mainView.refreshStop()
                
                switch result {
                case .isLoad(let state):
                    self.showLoadProgress(isLoad: state)
                case .Success(let model):
                    guard let result = model else { return }
                    if result.resultCount != 0 {
                        self.songList.removeAll()
                        self.songList.append(contentsOf: result.results)
                        self.mainView.reloadTableData()
                        self.mainView.tblListSongs.isHidden = false
                        self.mainView.vwNoListSongs.isHidden = true
                        
                        if AudioPlayerService.shared.currentSong == nil {
                            AudioPlayerService.shared.setPlaylist(self.songList, startAt: 0)
                        }
                    } else {
                        self.songList.removeAll()
                        self.mainView.reloadTableData()
                        self.mainView.tblListSongs.isHidden = true
                        self.mainView.vwNoListSongs.isHidden = false
                    }
                case .Error(let error):
                    self.erroHandler(self, error: error)
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - Delegate View
extension MainVC: MainViewDelegate {
    func RefreshLoad() {
        if currentSearchTerm.isEmpty {
            viewModel.getTopSongs()
        } else {
            performSearch(term: currentSearchTerm)
        }
    }
    
    func MainView(_ view: MainView, _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainView.tblListSongs {
            tableView.deselectRow(at: indexPath, animated: true)
            guard indexPath.row < songList.count else { return }
            
            if AudioPlayerService.shared.currentIndex == indexPath.row && AudioPlayerService.shared.playlist.count == songList.count {
                AudioPlayerService.shared.togglePlayPause()
            } else {
                AudioPlayerService.shared.setPlaylist(songList, startAt: indexPath.row)
            }
        }
    }
}

// MARK: - Delegate Data Source
extension MainVC: MainViewDataSource {
    func MainView(_ tableView: UITableView, view: MainView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainView.tblListSongs {
            return songList.count
        } else {
            return 0
        }
    }
    
    func MainView(_ view: MainView, cellForRowAt indexPath: IndexPath) -> SongItemInterface {
        return songList[indexPath.row]
    }
    
    func MainView(_ view: MainView, isCurrentPlayingAt indexPath: IndexPath) -> (isCurrent: Bool, isPlaying: Bool) {
        guard indexPath.row < songList.count else { return (false, false) }
        let currentSong = AudioPlayerService.shared.currentSong
        let isCurrent = currentSong?.id == songList[indexPath.row].id
        let isPlaying = AudioPlayerService.shared.isPlaying
        return (isCurrent, isPlaying)
    }
    
    func MainView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if songList.isEmpty { return nil }
        return currentSearchTerm.isEmpty ? "🔥 Top Trending Songs" : "Search Results (\(songList.count))"
    }
}

// MARK: - AudioPlayerDelegate
extension MainVC: AudioPlayerDelegate {
    func audioPlayerDidStartTrack(song: SongModel, index: Int) {
        if playerBarView.isHidden {
            playerBarView.alpha = 0
            playerBarView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.playerBarView.alpha = 1
            }
        }
        playerBarView.updateTrack(song: song)
        playerBarView.updatePlayState(isPlaying: true)
        mainView.reloadTableData()
    }
    
    func audioPlayerDidUpdateState(isPlaying: Bool) {
        playerBarView.updatePlayState(isPlaying: isPlaying)
        mainView.reloadTableData()
    }
    
    func audioPlayerDidUpdateProgress(currentTime: TimeInterval, duration: TimeInterval) {
        playerBarView.updateProgress(currentTime: currentTime, duration: duration)
    }
    
    func audioPlayerDidFinishPlaylist() {
        playerBarView.updatePlayState(isPlaying: false)
        mainView.reloadTableData()
    }
}

// MARK: - UITextFieldDelegate
extension MainVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchDebounceTimer?.invalidate()
        searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            self.currentSearchTerm = text
            if text.isEmpty {
                self.viewModel.getTopSongs()
            } else {
                self.performSearch(term: text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchDebounceTimer?.invalidate()
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        currentSearchTerm = text
        if text.isEmpty {
            viewModel.getTopSongs()
        } else {
            performSearch(term: text)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchDebounceTimer?.invalidate()
        currentSearchTerm = ""
        viewModel.getTopSongs()
        return true
    }
}

