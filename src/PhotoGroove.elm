module PhotoGroove exposing (main)

import Html exposing (div, h1, img, text)

--- "(..)" means expose everything from that module.
import Html.Attributes exposing (..) 

view model = 
    div [class "content"]
        [ h1 [] [text "Photos"]
        , div [ id "thumbnails"]
            [ img [ src "http://elm-in-action.com/1.jpeg" ] [] 
            , img [ src "http://elm-in-action.com/2.jpeg" ] [] 
            , img [ src "http://elm-in-action.com/3.jpeg" ] [] 
            ]
        ]

main =
 view "no model yet"
 