import Foundation
import SwiftRex

public final class MainStore: StoreBase<MainState> {
    public override init<M: Middleware>(initialState: MainState,
                                        reducer: Reducer<MainState>,
                                        middleware: M) where M.StateType == MainState {
        super.init(initialState: initialState, reducer: reducer, middleware: middleware)
    }
}
