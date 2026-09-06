//
//  MainVM.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//
import Foundation
import RxSwift

struct MainVMClosures {
    
}

protocol MainVMInput {
    func getListSong(request: SearchSongParam, isLoadMore: Bool)
    func getTopSongs(limit: Int, isLoadMore: Bool)
}

extension MainVMInput {
    func getListSong(request: SearchSongParam) {
        getListSong(request: request, isLoadMore: false)
    }
    func getTopSongs() {
        getTopSongs(limit: 25, isLoadMore: false)
    }
}

protocol MainVMOutput {
    
    var disposeBag: DisposeBag { get }
    
    var getListSongResponse: PublishSubject<Responses<Bool, ListSongModel?, String>> { get }
    
}

protocol MainVM: MainVMInput, MainVMOutput {}

final class DefaultMainVM: MainVM {

    private let mainUseCase: MainUseCase
    private let closures: MainVMClosures?
    internal let disposeBag: DisposeBag
    
    // MARK: - OUTPUT
    let getListSongResponse: PublishSubject<Responses<Bool, ListSongModel?, String>> = PublishSubject()
    
    // MARK: - Init
    init(mainUseCase: MainUseCase,
         closures: MainVMClosures? = nil) {
        self.disposeBag = DisposeBag()
        self.mainUseCase = mainUseCase
        self.closures = closures
    }
    
}

// MARK: - INPUT. View event methods
extension DefaultMainVM {
    
    func getListSong(request: SearchSongParam, isLoadMore: Bool = false) {
        if isInternetAvailable() {
            if !isLoadMore {
                self.getListSongResponse.onNext(.isLoad(true))
            }
            
            mainUseCase.getListSong(request: request)?
                .observe(on:MainScheduler.instance)
                .subscribe(
                    onNext: { result in
                        self.getListSongResponse.onNext(.Success(result))
                        if !isLoadMore {
                            self.getListSongResponse.onNext(.isLoad(false))
                        }
                    },
                    onError: { errorResponse in
                        let message = GlobalFunc.parseErrorByPartResponse(errorResponse.localizedDescription, needError: "message")
                        if !isLoadMore {
                            self.getListSongResponse.onNext(.isLoad(false))
                        }
                        self.getListSongResponse.onNext(.Error(message.isEmpty ? errorResponse.localizedDescription : message))
                    })
                .disposed(by: disposeBag)
        } else {
            if !isLoadMore {
                self.getListSongResponse.onNext(.isLoad(false))
            }
            self.getListSongResponse.onNext(.Error("No internet connection. Please check your network and try again."))
        }
    }
    
    func getTopSongs(limit: Int = 25, isLoadMore: Bool = false) {
        if isInternetAvailable() {
            if !isLoadMore {
                self.getListSongResponse.onNext(.isLoad(true))
            }
            
            mainUseCase.getTopSongs(limit: limit)?
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onNext: { result in
                        self.getListSongResponse.onNext(.Success(result))
                        if !isLoadMore {
                            self.getListSongResponse.onNext(.isLoad(false))
                        }
                    },
                    onError: { errorResponse in
                        let message = GlobalFunc.parseErrorByPartResponse(errorResponse.localizedDescription, needError: "message")
                        if !isLoadMore {
                            self.getListSongResponse.onNext(.isLoad(false))
                        }
                        self.getListSongResponse.onNext(.Error(message.isEmpty ? errorResponse.localizedDescription : message))
                    })
                .disposed(by: disposeBag)
        } else {
            if !isLoadMore {
                self.getListSongResponse.onNext(.isLoad(false))
            }
            self.getListSongResponse.onNext(.Error("No internet connection. Please check your network and try again."))
        }
    }
}

