module Pages.Park.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.ViewHelpers
import Libs.SimpleFormat.Format
import App.Update
import Pages.Park.Model exposing (..)


view : Model -> Html App.Update.Msg
view model =
    -- <div className="park-detail-page">
    --   <Header title={park.shortName}/>
    --   <div className="content">
    --     <div className="park-detail">
    --       <div className="container">
    --         <h2>{this.props.park.longName}</h2>
    --         <div dangerouslySetInnerHTML={this.getDescription()}/>
    --       </div>
    --       <div className="park-campsite-list">
    --         <CampsiteList campsites={this.props.park.campsites} position={this.props.position} />
    --       </div>
    --     </div>
    --   </div>
    -- </div>
    div [ class "park-detail-page" ]
        [ App.ViewHelpers.navBar model.park.shortName True False
        , div [ class "content" ]
            [ div [ class "park-details" ]
                [ div [ class "container" ]
                    [ h2 [] [ text model.park.longName ]
                    , Libs.SimpleFormat.Format.format model.park.description
                      -- TODO: Add campsites list
                    , div [ class "park-campsite-list" ] []
                    ]
                ]
            ]
        ]
