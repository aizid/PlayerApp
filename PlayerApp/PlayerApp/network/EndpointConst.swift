//
//  EndpointConst.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public enum EndpointConst {
    case getPesertaByNik(nik: String)
    
    public var rawValue: String {
        switch self {
            // MARK: POST ENDPOINT
            
            // MARK: PUT ENDPOINT
            
            // MARK: GET ENDPOINT
        case .getPesertaByNik(let nik): return "\(GlobalFunc.getDapenEndpoint().EP_PESERTA_NIK!)/\(nik)"
        }
    }
}
