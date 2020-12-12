module PhotoGroove exposing (main)

--- "(..)" means expose everything from that module.

import Array exposing (Array)
import Browser
import Html exposing (Html, button, div, h1, h3, img, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias Photo =
    { url : String }


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb =
    img
        [ src (urlPrefix ++ thumb.url)
        , classList [ ( "selected", selectedUrl == thumb.url ) ]
        , onClick { description = "ClickedPhoto", data = thumb.url }
        ]
        []


viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label []
        [ input [ type_ "radio", name "size" ] []
        , text (sizeToString size)
        ]


sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"

        Medium ->
            "med"

        Large ->
            "large"


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Small
    }


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


type ThumbnailSize
    = Large
    | Medium
    | Small


type alias Msg =
    { description : String, data : String }


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photos" ]
        , button [ onClick { description = "ClickedSupriseMe", data = "" } ] [ text "Surprise Me!" ]
        , h3 [] [ text "Thumbnail Size:" ]
        , div [ id "choose-size" ]
            (List.map viewSizeChooser [ Small, Medium, Large ])
        , div [ id "thumbnails", class (sizeToString model.chosenSize) ]
            (List.map (viewThumbnail model.selectedUrl) model.photos)
        , img
            [ class "large"
            , src (urlPrefix ++ "large/" ++ model.selectedUrl)
            ]
            []
        ]


getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url

        Nothing ->
            ""


update msg model =
    case msg.description of
        "ClickedPhoto" ->
            { model | selectedUrl = msg.data }

        "ClickedSupriseMe" ->
            { model | selectedUrl = "2.jpeg" }

        _ ->
            model


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
