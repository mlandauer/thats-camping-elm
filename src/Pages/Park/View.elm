module Pages.Park.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import App.ViewHelpers


view park =
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
        [ App.ViewHelpers.navBar park.shortName True False
        , div [ class "content" ]
            [ div [ class "park-details" ]
                [ div [ class "container" ]
                    [ -- TODO: Add long name
                      h2 [] [ text "This is where the long name of the park goes" ]
                      -- TODO: Add description
                    , div []
                        [ p [] [ text "This is where the description goes" ] ]
                      -- TODO: Add campsites list
                    , div [ class "park-campsite-list" ] []
                    ]
                ]
            ]
        ]
