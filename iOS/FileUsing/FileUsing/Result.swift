//
//  Result.swift
//  FileUsing
//
//  Created by Ádám Bella on 1/31/18.
//  Copyright © 2018 Ádám Bella. All rights reserved.
//

import Foundation

public enum Result<T> {
    case Success(T)
    case Fail(T)
}
