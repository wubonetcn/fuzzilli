// Copyright 2019-2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Fuzzilli

let xsProfile = Profile(
    getProcessArguments: { (randomizingArguments: Bool, differentialTesting: Bool) -> [String] in
        return ["-f"]
    },

    processArgumentsReference: ["-f"],

    processEnv: ["UBSAN_OPTIONS":"handle_segv=0"],

    codePrefix: """
                function placeholder(){}
                function main() {
                const fhash = placeholder;
                """,

    codeSuffix: """
                gc();
                }
                main();
                """,

    ecmaVersion: ECMAScriptVersion.es6,

    crashTests: ["fuzzilli('FUZZILLI_CRASH', 0)", "fuzzilli('FUZZILLI_CRASH', 1)", "fuzzilli('FUZZILLI_CRASH', 2)"],

    differentialTests: ["fuzzilli_hash(fuzzilli('FUZZILLI_RANDOM'))",],

    differentialTestsInvariant: ["fuzzilli_hash(Math.random())",
                                 "fuzzilli_hash(Date.now())",],

    differentialPoison: [],

    additionalCodeGenerators: [],

    additionalProgramTemplates: WeightedList<ProgramTemplate>([]),

    disabledCodeGenerators: [],

    additionalBuiltins: [
        "gc"                  : .function([] => .undefined),
        "print"               : .function([.plain(.jsString)] => .undefined),
        "placeholder"         : .function([] => .undefined),
    ]
)
