//
//  ResponseResult.swift
//  PlayerApp
//
//  Created by IOS-Cakra on 06/09/26.
//

public enum ResponseResult <T, F> {
  case Success(T)
  case Error(F)
}

public enum DownloadResponseResult<P, T> {
  case Progress(P)
  case Finish(T)
}

public enum Responses<L, T, F> {
  case isLoad(L)
  case Success(T)
  case Error(F)
}

public enum StoreResponse<S, C> {
  case confirm(S)
  case cancel(C)
}

public enum ProgressResult<T, S> {
  case type(T)
  case state(S)
}
