//
//  RxSwift+Extensions.swift
//  Core
//
//  Created by Luiz Rodrigo Martins Barbosa on 02.01.19.
//  Copyright © 2019 Luiz Rodrigo Martins Barbosa. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    public func unwrap<Wrapped>() -> Observable<Wrapped> where E == Optional<Wrapped> {
        return filter { $0 != nil }.map { $0! }
    }
}
