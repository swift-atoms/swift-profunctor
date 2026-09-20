import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: some DeclGroupSyntax) -> [DeclSyntax] {
        do {
            return try Type.Syntax.Mapping.members(of: declaration, method: "dimap",
                parameters: [.init("MappedInput", backward: "input"), .init("MappedOutput", forward: "output")])
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Profunctor " + String(describing: error))))")] }
    }
}
