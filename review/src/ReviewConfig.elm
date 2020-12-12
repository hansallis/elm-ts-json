module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import NoExposingEverything
import NoImportingEverything
import NoMissingTypeAnnotation
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Modules
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule exposing (Rule)


config : List Rule
config =
    [ NoUnused.Modules.rule
    , NoUnused.Exports.rule
    , NoUnused.Dependencies.rule
    , NoUnused.CustomTypeConstructorArgs.rule

    --, NoUnused.Variables.rule
    -- , NoUnused.CustomTypeConstructors.rule []
    , NoUnused.Parameters.rule

    --, NoUnused.Patterns.rule
    --, NoDebug.Log.rule
    --, NoDebug.TodoOrToString.rule
    , NoExposingEverything.rule

    --, NoImportingEverything.rule []
    --, NoMissingTypeAnnotation.rule
    ]
