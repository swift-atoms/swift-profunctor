import Type_Algebra_Syntax
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of structure: StructDeclSyntax) -> [DeclSyntax] {
        do {
            let shape = try GenericProduct(structure, arity: 2)
            let parameters = shape.parameters
            let fields = shape.properties.fields
            let forward: [String: String] = [parameters[1]: "output"]
            let backward: [String: String] = [parameters[0]: "input"]
            let arguments = try fields.enumerated().map { index, field in
                field.name + ": " + (try MappingExpression.apply(shape.fields[index], to: "self.\(field.name)", forward: forward, backward: backward))
            }.joined(separator: ", ")
            return [DeclSyntax(stringLiteral: """
                \(shape.access)func dimap<MappedInput, MappedOutput>(_ input: @escaping (MappedInput) -> \(parameters[0]), _ output: @escaping (\(parameters[1])) -> MappedOutput) -> \(structure.name.text)<MappedInput, MappedOutput> {
                    \(structure.name.text)<MappedInput, MappedOutput>(\(arguments))
                }
                """)]
        } catch { return [DeclSyntax(stringLiteral: "#error(\(String(reflecting: "@Profunctor " + String(describing: error))))")] }
    }
}
