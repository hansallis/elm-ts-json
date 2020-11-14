module TsInteropDecodeTests exposing (..)

import Expect exposing (Expectation)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Test exposing (..)
import TsPort exposing (Encoder, property)


suite : Test
suite =
    describe "Interop decode"
        [ --test "object" <|
          --    \() ->
          --        TsPort.build
          --            |> property "first" (TsPort.string |> TsPort.map .first)
          --            |> property "last" (TsPort.string |> TsPort.map .last)
          --            |> TsPort.toEncoder
          --            |> expectEncodes
          --                { input = { first = "Dillon", last = "Kearns" }
          --                , output = """{"last":"Kearns","first":"Dillon"}"""
          --                , typeDef = "{ last : string; first : string }"
          --                }
          test "standalone string" <|
            \() ->
                string
                    |> expectDecodes
                        { input = "\"Dillon\""
                        , output = "Dillon"
                        , typeDef = "string"
                        }
        , test "list of strings" <|
            \() ->
                list string
                    |> expectDecodes
                        { input = """["Hello", "World"]"""
                        , output = [ "Hello", "World" ]
                        , typeDef = "string[]"
                        }
        ]


type TsType
    = String
    | List TsType


type InteropDecoder value
    = InteropDecoder (Decoder value) TsType


string : InteropDecoder String
string =
    InteropDecoder Decode.string String


list : InteropDecoder value -> InteropDecoder (List value)
list (InteropDecoder innerDecoder innerType) =
    --InteropDecoder Decode.string String
    InteropDecoder (Decode.list innerDecoder) (List innerType)


decoder : InteropDecoder value -> Decoder value
decoder (InteropDecoder decoder_ tsType_) =
    decoder_


tsTypeToString : InteropDecoder value -> String
tsTypeToString (InteropDecoder decoder_ tsType_) =
    tsTypeToString_ tsType_


tsTypeToString_ : TsType -> String
tsTypeToString_ tsType_ =
    case tsType_ of
        String ->
            "string"

        List listType ->
            tsTypeToString_ listType ++ "[]"


expectDecodes :
    { output : decodesTo, input : String, typeDef : String }
    -> InteropDecoder decodesTo
    -> Expect.Expectation
expectDecodes expect interop =
    expect.input
        |> Decode.decodeString (decoder interop)
        |> Expect.all
            [ \decoded -> decoded |> Expect.equal (Ok expect.output)
            , \decoded -> tsTypeToString interop |> Expect.equal expect.typeDef
            ]