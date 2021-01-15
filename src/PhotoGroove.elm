module PhotoGroove exposing (main)

--- "(..)" means expose everything from that module.

import Browser
import Html exposing (Html, button, div, h1, h3, img, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onClick)
import Http exposing (Error)
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
    | Errored String


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
    | GotPhotos (Result Http.Error String)


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

            Errored errorMessage ->
                [ text ("Error: " ++ errorMessage) ]


initialCmd : Cmd Msg
initialCmd =
    Http.get
        { url = "http://elm-in-action.com/photos/list"
        , expect = Http.expectString GotPhotos
        }


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
                    ( model, Cmd.none )

                Loading ->
                    ( model, Cmd.none )

                Errored errorMessage ->
                    ( model, Cmd.none )

        ClickedSize size ->
            ( { model | chosenSize = size }, Cmd.none )

        GotRandomPhoto photo ->
            ( { model | status = selectUrl photo.url model.status }, Cmd.none )

        -- GotPhotos is a http request, which reveils a result, which always holds two possible outcomes:
        -- either it's "ok" and we get the string we want or it is an error, which we need to handle in such a case.
        GotPhotos (Ok responseStr) ->
            case String.split "," responseStr of
                (firstUrl :: _) as urls ->
                    let
                        photos =
                            List.map (\url -> { url = url }) urls
                    in
                    ( { model | status = Loaded photos firstUrl }, Cmd.none )

                [] ->
                    ( { model | status = Errored "0 photos found" }, Cmd.none )

        GotPhotos (Err httpError) ->
            ( { model | status = Errored "Server error!" }, Cmd.none )


selectUrl : String -> Status -> Status
selectUrl url status =
    case status of
        Loaded photos _ ->
            Loaded photos url

        Loading ->
            status

        Errored errorMessage ->
            status


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, initialCmd )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
