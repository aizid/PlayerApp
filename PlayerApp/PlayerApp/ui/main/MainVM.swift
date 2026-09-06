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
    func getListSong(request: SearchSongParam)
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
    
    func getListSong(request: SearchSongParam) {
        if isInternetAvailable() {
            self.getListSongResponse.onNext(.isLoad(true))
            
            mainUseCase.getListSong(request: request)?
                .observe(on:MainScheduler.instance)
                .subscribe(
                    onNext: { result in
                        self.getListSongResponse.onNext(.Success(result))
                        self.getListSongResponse.onNext(.isLoad(false))
                    },
                    onError: { errorResponse in
                        let errorStat = GlobalFunc.parseErrorByPartResponse(errorResponse.localizedDescription, needError: "errorStat")
                        let message = GlobalFunc.parseErrorByPartResponse(errorResponse.localizedDescription, needError: "message")
                        
                        
                        self.getListSongResponse.onNext(.isLoad(false))
                        self.getListSongResponse.onNext(.Error(message))
                    })
                .disposed(by: disposeBag)
        } else {
            
//            DialogControl.showStandardDialog(.noInternet, target: self, nsNotification: SplashVC.myNotification)
        }
    }
    
}

