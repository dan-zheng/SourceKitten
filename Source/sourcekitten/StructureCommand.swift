//
//  Structure.swift
//  SourceKitten
//
//  Created by JP Simard on 2015-01-07.
//  Copyright (c) 2015 SourceKitten. All rights reserved.
//

import Commandant
import Foundation
import Result
import SourceKittenFramework

struct StructureCommand: CommandType {
    let verb = "structure"
    let function = "Print Swift structure information as JSON"

    struct Options: OptionsType {
        let file: String
        let text: String

        static func create(file: String) -> (text: String) -> Options {
            return { text in
                self.init(file: file, text: text)
            }
        }

        static func evaluate(m: CommandMode) -> Result<Options, CommandantError<SourceKittenError>> {
            return create
                <*> m <| Option(key: "file", defaultValue: "", usage: "relative or absolute path of Swift file to parse")
                <*> m <| Option(key: "text", defaultValue: "", usage: "Swift code text to parse")
        }
    }

    func run(options: Options) -> Result<(), SourceKittenError> {
        if !options.file.isEmpty {
            if let file = File(path: options.file) {
                print(Structure(file: file))
                return .Success()
            }
            return .Failure(.ReadFailed(path: options.file))
        }
        if !options.text.isEmpty {
            print(Structure(file: File(contents: options.text)))
            return .Success()
        }
        return .Failure(
            .InvalidArgument(description: "either file or text must be set when calling structure")
        )
    }
}
