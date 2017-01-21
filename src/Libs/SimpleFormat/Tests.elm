module Libs.SimpleFormat.Tests exposing (..)

import Test exposing (..)
import Expect
import Html
import Libs.SimpleFormat.Format exposing (format)


all : Test
all =
    describe "SimpleFormat"
        [ test "Should wrap text without any linebreaks in p tag" <|
            \() ->
                let
                    expected =
                        Html.div []
                            [ Html.p [] [ Html.text "Some text" ]
                            ]
                in
                    Expect.equal (expected) (format "Some text")
        , test "should split paragraphs up" <|
            \() ->
                let
                    expected =
                        Html.div []
                            [ Html.p [] [ Html.text "Paragraph 1" ]
                            , Html.p [] [ Html.text "Paragraph 2" ]
                            ]
                in
                    Expect.equal (expected) (format "Paragraph 1\n\nParagraph 2")
        , test "should insert line breaks" <|
            \() ->
                let
                    expected =
                        Html.div []
                            [ Html.p []
                                [ Html.text "Paragraph"
                                , Html.br [] []
                                , Html.text "New line"
                                ]
                            ]
                in
                    Expect.equal (expected) (format "Paragraph\nNew line")
        , test "should work with cr and lf" <|
            \() ->
                let
                    expected =
                        Html.div []
                            [ Html.p []
                                [ Html.text "Paragraph"
                                , Html.br [] []
                                , Html.text "New line"
                                ]
                            , Html.p []
                                [ Html.text "Hello"
                                ]
                            ]
                in
                    Expect.equal (expected) (format "Paragraph\x0D\nNew line\x0D\n\x0D\nHello")
        ]
