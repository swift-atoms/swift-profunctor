import Profunctor_Macro
import Testing
@Profunctor private struct Arrow<A, B> { let run: (A) -> B }
@Test func dimapIdentityAndComposition() {
    let arrow = Arrow<Int, Int>(run: { $0 * 2 })
    let identity = arrow.dimap({ $0 }, { $0 })
    let twice = arrow.dimap({ $0 + 1 }, { $0 + 2 }).dimap({ $0 * 3 }, String.init)
    let once = arrow.dimap({ $0 * 3 + 1 }, { String($0 + 2) })
    for value in [-1, 0, 3] {
        #expect(identity.run(value) == arrow.run(value))
        #expect(twice.run(value) == once.run(value))
    }
}
