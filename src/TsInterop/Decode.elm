module TsInterop.Decode exposing
    ( Decoder
    , succeed, fail
    , bool, float, int, string
    , field, at
    , list, array, nullable, oneOf, dict, keyValuePairs, oneOrMore, maybe, optionalField, optionalNullableField
    , index
    , map
    , map2, andMap
    , map3, map4, map5, map6, map7, map8
    , literal, null
    , andThen, staticAndThen, StaticAndThen, init, option
    , value
    , decoder, tsTypeToString
    )

{-|


## Decoders

@docs Decoder

@docs succeed, fail


## Built-Ins

@docs bool, float, int, string


## Objects

@docs field, at


## Composite Types

@docs list, array, nullable, oneOf, dict, keyValuePairs, oneOrMore, maybe, optionalField, optionalNullableField

@docs index


## Transformations

@docs map


## Combining

@docs map2, andMap

@docs map3, map4, map5, map6, map7, map8


## TypeScript Literals

@docs literal, null


## Continuation

@docs andThen, staticAndThen, StaticAndThen, init, option


## Using elm/json Decoders

If you have an exising decoder, you can use it with an `unknown` type in TypeScript.

You can also decode an arbitrary JSON value as with `elm/json`, and then use `elm/json` to process it further.

@docs value


## Using Decoders

@docs decoder, tsTypeToString

-}

import Array exposing (Array)
import Dict exposing (Dict)
import Json.Decode as Decode
import Json.Encode as Encode
import TsType exposing (TsType(..))


{-| -}
map : (value -> mapped) -> Decoder value -> Decoder mapped
map mapFn (Decoder innerDecoder innerType) =
    Decoder (Decode.map mapFn innerDecoder) innerType


{-| See <https://github.com/elm-community/json-extra/blob/2.0.0/docs/andMap.md>.
-}
andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap =
    map2 (|>)


{-| -}
map2 : (value1 -> value2 -> mapped) -> Decoder value1 -> Decoder value2 -> Decoder mapped
map2 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) =
    Decoder (Decode.map2 mapFn innerDecoder1 innerDecoder2) (TsType.intersect innerType1 innerType2)


{-| -}
map3 : (value1 -> value2 -> value3 -> mapped) -> Decoder value1 -> Decoder value2 -> Decoder value3 -> Decoder mapped
map3 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) =
    Decoder (Decode.map3 mapFn innerDecoder1 innerDecoder2 innerDecoder3)
        (TsType.intersect
            innerType1
            innerType2
            |> TsType.intersect innerType3
        )


{-| -}
map4 :
    (value1 -> value2 -> value3 -> value4 -> mapped)
    -> Decoder value1
    -> Decoder value2
    -> Decoder value3
    -> Decoder value4
    -> Decoder mapped
map4 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) (Decoder innerDecoder4 innerType4) =
    Decoder (Decode.map4 mapFn innerDecoder1 innerDecoder2 innerDecoder3 innerDecoder4)
        (TsType.Intersection
            [ innerType1
            , innerType2
            , innerType3
            , innerType4
            ]
        )


{-| -}
map5 :
    (value1 -> value2 -> value3 -> value4 -> value5 -> mapped)
    -> Decoder value1
    -> Decoder value2
    -> Decoder value3
    -> Decoder value4
    -> Decoder value5
    -> Decoder mapped
map5 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) (Decoder innerDecoder4 innerType4) (Decoder innerDecoder5 innerType5) =
    Decoder (Decode.map5 mapFn innerDecoder1 innerDecoder2 innerDecoder3 innerDecoder4 innerDecoder5)
        (TsType.Intersection
            [ innerType1
            , innerType2
            , innerType3
            , innerType4
            , innerType5
            ]
        )


{-| -}
map6 :
    (value1 -> value2 -> value3 -> value4 -> value5 -> value6 -> mapped)
    -> Decoder value1
    -> Decoder value2
    -> Decoder value3
    -> Decoder value4
    -> Decoder value5
    -> Decoder value6
    -> Decoder mapped
map6 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) (Decoder innerDecoder4 innerType4) (Decoder innerDecoder5 innerType5) (Decoder innerDecoder6 innerType6) =
    Decoder (Decode.map6 mapFn innerDecoder1 innerDecoder2 innerDecoder3 innerDecoder4 innerDecoder5 innerDecoder6)
        (TsType.Intersection
            [ innerType1
            , innerType2
            , innerType3
            , innerType4
            , innerType5
            , innerType6
            ]
        )


{-| -}
map7 :
    (value1 -> value2 -> value3 -> value4 -> value5 -> value6 -> value7 -> mapped)
    -> Decoder value1
    -> Decoder value2
    -> Decoder value3
    -> Decoder value4
    -> Decoder value5
    -> Decoder value6
    -> Decoder value7
    -> Decoder mapped
map7 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) (Decoder innerDecoder4 innerType4) (Decoder innerDecoder5 innerType5) (Decoder innerDecoder6 innerType6) (Decoder innerDecoder7 innerType7) =
    Decoder (Decode.map7 mapFn innerDecoder1 innerDecoder2 innerDecoder3 innerDecoder4 innerDecoder5 innerDecoder6 innerDecoder7)
        (TsType.Intersection
            [ innerType1
            , innerType2
            , innerType3
            , innerType4
            , innerType5
            , innerType6
            , innerType7
            ]
        )


{-| -}
map8 :
    (value1 -> value2 -> value3 -> value4 -> value5 -> value6 -> value7 -> value8 -> mapped)
    -> Decoder value1
    -> Decoder value2
    -> Decoder value3
    -> Decoder value4
    -> Decoder value5
    -> Decoder value6
    -> Decoder value7
    -> Decoder value8
    -> Decoder mapped
map8 mapFn (Decoder innerDecoder1 innerType1) (Decoder innerDecoder2 innerType2) (Decoder innerDecoder3 innerType3) (Decoder innerDecoder4 innerType4) (Decoder innerDecoder5 innerType5) (Decoder innerDecoder6 innerType6) (Decoder innerDecoder7 innerType7) (Decoder innerDecoder8 innerType8) =
    Decoder (Decode.map8 mapFn innerDecoder1 innerDecoder2 innerDecoder3 innerDecoder4 innerDecoder5 innerDecoder6 innerDecoder7 innerDecoder8)
        (TsType.Intersection
            [ innerType1
            , innerType2
            , innerType3
            , innerType4
            , innerType5
            , innerType6
            , innerType7
            , innerType8
            ]
        )


{-| -}
nullable : Decoder value -> Decoder (Maybe value)
nullable (Decoder innerDecoder innerType) =
    Decoder (Decode.nullable innerDecoder) (TsType.union [ innerType, TsType.null ])


{-| You can express quite a bit with `oneOf`! The resulting TypeScript types will be a Union of all the TypeScript types
for each Decoder in the List.

    import Json.Decode
    import Json.Encode

    runExample : Decoder value -> String -> { decoded : Result String value, tsType : String }
    runExample interopDecoder inputJson = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }


    "[1, 2, 3.14159, 4]"
        |> runExample ( list ( oneOf [ int |> map toFloat, float ] ) )
    --> { decoded = Ok [1.0, 2.0, 3.14159, 4.0]
    --> , tsType = """(number | number)[]"""
    --> }

-}
oneOf : List (Decoder value) -> Decoder value
oneOf decoders =
    Decoder
        (decoders
            |> List.map
                (\(Decoder innerDecoder _) ->
                    innerDecoder
                )
            |> Decode.oneOf
        )
        (decoders
            |> List.map
                (\(Decoder _ innerType) ->
                    innerType
                )
            |> TsType.union
        )


{-| -}
type Decoder value
    = Decoder (Decode.Decoder value) TsType


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    succeed "abcdefg"
        |> runExample "12345"
    --> { decoded = Ok "abcdefg"
    --> , tsType = "JsonValue"
    --> }

-}
succeed : value -> Decoder value
succeed value_ =
    Decoder (Decode.succeed value_) TsType.Unknown


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    field "version" int |> andThen (\versionNumber ->
        if versionNumber == 1 then
          field "payload" string
        else
          at [ "data", "payload" ] string
    )
        |> runExample """{"version": 1, "payload": "Hello"}"""
    --> { decoded = Ok "Hello"
    --> , tsType = "{ version : number }"
    --> }

-}
andThen : (a -> Decoder b) -> Decoder a -> Decoder b
andThen function (Decoder innerDecoder innerType) =
    let
        andThenDecoder =
            \value_ ->
                case function value_ of
                    Decoder innerDecoder_ innerType_ ->
                        innerDecoder_
    in
    Decoder (Decode.andThen andThenDecoder innerDecoder) innerType


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    example : StaticAndThen (Int -> Decoder String)
    example =
        init
            (\v1Decoder v2PlusDecoder version ->
                case version of
                    1 -> v1Decoder
                    _ -> v2PlusDecoder
            )
            |> option (field "payload" string)
            |> option (at [ "data", "payload" ] string)


    field "version" int |> staticAndThen example
        |> runExample """{"version": 1, "payload": "Hello"}"""
    --> { decoded = Ok "Hello"
    --> , tsType = "({ version : number } & { data : { payload : string } } | { payload : string })"
    --> }

-}
staticAndThen : StaticAndThen (value -> Decoder decodesTo) -> Decoder value -> Decoder decodesTo
staticAndThen (StaticAndThen function tsTypes) (Decoder innerDecoder innerType) =
    let
        andThenDecoder =
            \value_ ->
                case function value_ of
                    Decoder innerDecoder_ innerType_ ->
                        innerDecoder_
    in
    Decoder (Decode.andThen andThenDecoder innerDecoder) (TsType.intersect innerType (TsType.union tsTypes))


{-| -}
type StaticAndThen a
    = StaticAndThen a (List TsType)


{-| -}
init : a -> StaticAndThen a
init constructor =
    StaticAndThen constructor []


{-| -}
option :
    Decoder value
    -> StaticAndThen (Decoder value -> final)
    -> StaticAndThen final
option ((Decoder _ innerType) as interopDecoder) (StaticAndThen function tsTypes) =
    StaticAndThen (function interopDecoder) (innerType :: tsTypes)


{-| -}
value : Decoder Decode.Value
value =
    Decoder Decode.value TsType.Unknown


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    fail "Failure message"
        |> runExample "123.45"
    --> { decoded = Err "Problem with the given value:\n\n123.45\n\nFailure message"
    --> , tsType = "JsonValue"
    --> }

-}
fail : String -> Decoder value
fail message =
    Decoder (Decode.fail message) TsType.Unknown


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    null False |> runExample "null"
    --> { decoded = Ok False
    --> , tsType = "null"
    --> }

-}
null : value -> Decoder value
null value_ =
    literal value_ Encode.null


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    json : String
    json = """{ "name": "tom", "age": 42 }"""

    maybe (field "height" float) |> runExample json
    --> { decoded = Ok Nothing
    --> , tsType = "{ height : number } | JsonValue"
    --> }

    field "height" (maybe float) |> runExample json
    --> { decoded = Err "Problem with the given value:\n\n{\n        \"name\": \"tom\",\n        \"age\": 42\n    }\n\nExpecting an OBJECT with a field named `height`"
    --> , tsType = "{ height : number | JsonValue }"
    --> }

-}
maybe : Decoder value -> Decoder (Maybe value)
maybe interopDecoder =
    oneOf
        [ map Just interopDecoder
        , succeed Nothing
        ]


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    json : String
    json = """{ "name": "tom", "age": null }"""

    optionalField "height" float |> runExample json
    --> { decoded = Ok Nothing
    --> , tsType = "{ height? : number }"
    --> }

    optionalField "age" int |> runExample json
    --> { decoded = Err "Problem with the value at json.age:\n\n    null\n\nExpecting an INT"
    --> , tsType = "{ age? : number }"
    --> }

-}
optionalField : String -> Decoder value -> Decoder (Maybe value)
optionalField fieldName (Decoder innerDecoder innerType) =
    let
        finishDecoding json =
            case Decode.decodeValue (Decode.field fieldName Decode.value) json of
                Ok val ->
                    -- The field is present, so run the decoder on it.
                    Decode.map Just (Decode.field fieldName innerDecoder)

                Err _ ->
                    -- The field was missing, which is fine!
                    Decode.succeed Nothing
    in
    Decoder
        (Decode.value
            |> Decode.andThen finishDecoding
        )
        (TsType.TypeObject [ ( TsType.Optional, fieldName, innerType ) ])


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    json : String
    json = """{ "name": "tom", "age": null }"""

    optionalNullableField "height" float |> runExample json
    --> { decoded = Ok Nothing
    --> , tsType = "{ height? : number | null }"
    --> }

    optionalNullableField "age" int |> runExample json
    --> { decoded = Ok Nothing
    --> , tsType = "{ age? : number | null }"
    --> }

-}
optionalNullableField : String -> Decoder value -> Decoder (Maybe value)
optionalNullableField fieldName interopDecoder =
    optionalField fieldName (nullable interopDecoder)
        |> map (Maybe.andThen identity)


{-| TypeScript has support for literals.
-}
literal : value -> Encode.Value -> Decoder value
literal value_ literalValue =
    Decoder
        (Decode.value
            |> Decode.andThen
                (\decodeValue ->
                    if literalValue == decodeValue then
                        Decode.succeed value_

                    else
                        Decode.fail ("Expected the following literal value: " ++ Encode.encode 0 literalValue)
                )
        )
        (Literal literalValue)


{-|

    import Json.Decode

    runExample : Decoder value -> String -> { decoded : Result String value, tsType : String }
    runExample interopDecoder inputJson = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    exampleDecoder : Decoder String
    exampleDecoder =
        field "first" string

    """{"first":"James","middle":"Tiberius","last":"Kirk"}"""
        |> runExample exampleDecoder
    --> { decoded = Ok "James"
    --> , tsType = "{ first : string }"
    --> }

-}
field : String -> Decoder value -> Decoder value
field fieldName (Decoder innerDecoder innerType) =
    Decoder
        (Decode.field fieldName innerDecoder)
        (TsType.TypeObject [ ( TsType.Required, fieldName, innerType ) ])


{-|

    import Json.Decode
    import Json.Encode

    runExample : Decoder value -> String -> { decoded : Result String value, tsType : String }
    runExample interopDecoder inputJson = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    type Mode = DarkMode | LightMode

    modeDecoder : Decoder Mode
    modeDecoder =
        oneOf [ literal DarkMode <| Json.Encode.string "dark", literal LightMode <| Json.Encode.string "light" ]

    """{"options":
           { "mode": "dark" },
        "version": "1.2.3"}"""
        |> runExample (at [ "options", "mode" ] modeDecoder)
    --> { decoded = Ok DarkMode
    --> , tsType = """{ options : { mode : "dark" | "light" } }"""
    --> }

-}
at : List String -> Decoder value -> Decoder value
at location (Decoder innerDecoder innerType) =
    Decoder
        (Decode.at location innerDecoder)
        (location
            |> List.foldr
                (\fieldName typeSoFar ->
                    TsType.TypeObject [ ( TsType.Required, fieldName, typeSoFar ) ]
                )
                innerType
        )


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    string
        |> runExample """ "Hello!" """
    --> { decoded = Ok "Hello!"
    --> , tsType = "string"
    --> }

-}
string : Decoder String
string =
    Decoder Decode.string String


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    int
        |> runExample "1000"
    --> { decoded = Ok 1000
    --> , tsType = "number"
    --> }

-}
int : Decoder Int
int =
    Decoder Decode.int TsType.Number


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    float
        |> runExample "1.23"
    --> { decoded = Ok 1.23
    --> , tsType = "number"
    --> }

-}
float : Decoder Float
float =
    Decoder Decode.float TsType.Number


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    bool
        |> runExample "true"
    --> { decoded = Ok True
    --> , tsType = "boolean"
    --> }

-}
bool : Decoder Bool
bool =
    Decoder Decode.bool TsType.Boolean


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    list int
        |> runExample "[1,2,3]"
    --> { decoded = Ok [ 1, 2, 3 ]
    --> , tsType = "number[]"
    --> }

-}
list : Decoder value -> Decoder (List value)
list (Decoder innerDecoder innerType) =
    Decoder (Decode.list innerDecoder) (List innerType)


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    index 1 int
        |> runExample "[0,100,200]"
    --> { decoded = Ok 100
    --> , tsType = "[JsonValue,number,...JsonValue[]]"
    --> }

    map2 Tuple.pair
        ( index 1 int )
        ( index 3 string )
        |> runExample """[0,100,"a","b"]"""
    --> { decoded = Ok ( 100, "b" )
    --> , tsType = "[JsonValue,number,JsonValue,string,...JsonValue[]]"
    --> }

-}
index : Int -> Decoder value -> Decoder value
index n (Decoder innerDecoder innerType) =
    Decoder (Decode.index n innerDecoder) (TsType.ArrayIndex ( n, innerType ) [])


{-|

    import Json.Decode
    import Json.Encode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    oneOrMore (::) int
        |> runExample "[12345]"
    --> { decoded = Ok [ 12345 ]
    --> , tsType = """[ number, ...(number)[] ]"""
    --> }

    type TestResult
        = Pass
        | Fail String

    testCaseDecoder : Decoder TestResult
    testCaseDecoder =
        oneOf [
            field "tag" (literal Pass (Json.Encode.string "pass"))
          , map2 (\() message -> Fail message)
              ( field "tag" (literal () (Json.Encode.string "fail")) )
              ( field "message" string )
        ]

    oneOrMore (::) testCaseDecoder
        |> runExample """[ { "tag": "pass" } ]"""
    --> { decoded = Ok [ Pass ]
    --> , tsType = """[ { tag : "pass" } | { tag : "fail"; message : string }, ...({ tag : "pass" } | { tag : "fail"; message : string })[] ]"""
    --> }

-}
oneOrMore : (a -> List a -> value) -> Decoder a -> Decoder value
oneOrMore constructor (Decoder innerDecoder innerType) =
    Decoder (Decode.oneOrMore constructor innerDecoder) (Tuple [ innerType ] (Just innerType))


{-| Exactly the same as the `list` Decoder except that it wraps the decoded `List` into an Elm `Array`.
-}
array : Decoder value -> Decoder (Array value)
array (Decoder innerDecoder innerType) =
    Decoder (Decode.array innerDecoder) (List innerType)


{-|

    import Json.Decode
    import Json.Encode
    import Dict exposing (Dict)


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    dict int
        |> runExample """{"alice":42,"bob":99}"""
    --> { decoded = Ok (Dict.fromList [ ( "alice", 42 ), ( "bob", 99 ) ])
    --> , tsType = "{ [key: string]: number }"
    --> }

-}
dict : Decoder value -> Decoder (Dict String value)
dict (Decoder innerDecoder innerType) =
    Decoder (Decode.dict innerDecoder) (TsType.ObjectWithUniformValues innerType)


{-|

    import Json.Decode


    runExample : String -> Decoder value -> { decoded : Result String value, tsType : String }
    runExample inputJson interopDecoder = { tsType = tsTypeToString interopDecoder , decoded = Json.Decode.decodeString (decoder interopDecoder) inputJson |> Result.mapError Json.Decode.errorToString }

    keyValuePairs int
        |> runExample """{ "alice": 42, "bob": 99 }"""
    --> { decoded = Ok [ ( "alice", 42 ), ( "bob", 99 ) ]
    --> , tsType = "{ [key: string]: number }"
    --> }

-}
keyValuePairs : Decoder value -> Decoder (List ( String, value ))
keyValuePairs (Decoder innerDecoder innerType) =
    Decoder (Decode.keyValuePairs innerDecoder) (TsType.ObjectWithUniformValues innerType)


{-| Get a regular JSON Decoder that you can run using the `elm/json` API.
-}
decoder : Decoder value -> Decode.Decoder value
decoder (Decoder decoder_ _) =
    decoder_


{-| -}
tsTypeToString : Decoder value -> String
tsTypeToString (Decoder _ tsType_) =
    TsType.toString tsType_
