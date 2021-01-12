module PhotoGroove exposing (main)

--- "(..)" means expose everything from that module.

import Browser
import Html exposing (Html, button, div, h1, h3, img, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onClick)
import Random


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
        , onClick (ClickedPhoto thumb.url)
        ]
        []


viewSizeChooser : ThumbnailSize -> ThumbnailSize -> Html Msg
viewSizeChooser default size =
    label []
        [ input [ type_ "radio", name "size", onClick (ClickedSize size), checked (default == size) ] []
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


type Status
    = Loading
    | Loaded (List Photo) String
    | Error String


type alias Model =
    { status : Status
    , chosenSize : ThumbnailSize
    }


initialModel : Model
initialModel =
    { status = Loading
    , chosenSize = Medium
    }


type ThumbnailSize
    = Large
    | Medium
    | Small


type Msg
    = ClickedPhoto String
    | ClickedSize ThumbnailSize
    | ClickedSurprise
    | GotRandomPhoto Photo


viewLoaded : List Photo -> String -> ThumbnailSize -> List (Html Msg)
viewLoaded photos selectedUrl chosenSize =
    [ h1 [] [ text "Photos" ]
    , button [ onClick ClickedSurprise ] [ text "Surprise Me!" ]
    , h3 [] [ text "Thumbnail Size:" ]
    , div [ id "choose-size" ]
        (List.map (viewSizeChooser chosenSize) [ Small, Medium, Large ])
    , div [ id "thumbnails", class (sizeToString chosenSize) ]
        (List.map (viewThumbnail selectedUrl) photos)
    , img
        [ class "large"
        , src (urlPrefix ++ "large/" ++ selectedUrl)
        ]
        []
    ]


view : Model -> Html Msg
view model =
    div [ class "content" ] <|
        case model.status of
            Loaded photos selectedUrl ->
                viewLoaded photos selectedUrl model.chosenSize

            Loading ->
                []

            Error errorMessage ->
                [ text ("Error: " ++ errorMessage) ]
        


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPhoto url ->
            ( { model | status = selectUrl url model.status }, Cmd.none )

        ClickedSurprise ->
           case model.status of
            Loaded (firstPhoto :: otherPhotos) _ -> 
                Random.uniform firstPhoto otherPhotos
                |> Random.generate GotRandomPhoto 
                |> Tuple.pair model
                
            Loaded [] _ -> 
                (model, Cmd.none)
            Loading -> 
                (model, Cmd.none)
            Error errorMessage -> 
                (model, Cmd.none)

                

        ClickedSize size ->
            ( { model | chosenSize = size }, Cmd.none )

        GotRandomPhoto photo ->
            ({ model | status = selectUrl photo.url model.status}, Cmd.none)

selectUrl : String -> Status -> Status
selectUrl url status = 
    case status of
        Loaded photos _ -> 
            Loaded photos url
        
        Loading -> 
            status

        Error errorMessage -> 
            status

main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
