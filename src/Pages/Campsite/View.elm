module Pages.Campsite.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Pages.Campsite.Model exposing (..)
import App.ViewHelpers
import App.Update exposing (Msg)


view : Model -> Html Msg
view model =
    div [ class "campsite-detail-page" ]
        [ App.ViewHelpers.navBar model.campsite.name True True
        , div [ class "content" ]
            [ div [ class "container" ]
                [ div [ class "campsite-detail" ]
                    [ -- TODO: Add star
                      -- TODO: This should be the long name of the campsite here
                      h2 [] [ text model.campsite.name ]
                    ]
                ]
            ]
        ]



--   <p>in <Link to={"/parks/" + this.props.campsite.park.id}>{this.props.campsite.park.longName}</Link>.</p>
--   <div dangerouslySetInnerHTML={this.getDescription()}/>
--   <h2>Facilities</h2>
--   <p>{this.facilitiesText()}</p>
--   <h2>Access</h2>
--   <p>{this.accessText()}</p>
--   <a href={this.mapUrl()} className="directions btn btn-default" disabled={this.directionsEnabled() ? "" : "disabled"}>Directions to campsite</a>
