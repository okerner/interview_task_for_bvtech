import React, { Component } from 'react'
import axios from 'axios'
import { apiConfig } from '../config/config'
import { usePromiseTracker } from 'react-promise-tracker';
import { trackPromise } from 'react-promise-tracker';
import Loader from 'react-loader-spinner';

const client = axios.create({
    baseURL: apiConfig.baseUrl,
    headers: {
     Accept: 'application/json',
    }
});

const LoadingIndicator = props => {
    const { promiseInProgress } = usePromiseTracker();
    
    return (
         promiseInProgress && 
        <div
            style={{
                width: "100%",
                height: "100",
                display: "flex",
                justifyContent: "center",
                alignItems: "center"
            }}
        >
            <Loader type="ThreeDots" color="#2BAD60" height="100" width="100" />
        </div>
    );  
}

class SportsContainer extends Component {
    constructor(props) {
        super(props)
        this.state = {
          sports: [],
          loading: true,
        }
    }
    getSports() {
        trackPromise(
            client.get('/sports')
            .then(response => {
                response.data.forEach(sport => {
                    sport.isToggleOn = false
                });
                this.setState({sports: response.data, loading: false})
            })
            .catch(error => console.log(error))
        )
    }

    searchSportById(e) {
        if (e.target.value && e.target.value !== "") {
            client.get('/sports/' + e.target.value)
            .then(response => {
                if (response.data && response.data !== "") {
                    console.log(response.data)
                    response.data.isToggleOn = false
                    this.setState({sports: [response.data['sport']]})
                }
            })
            .catch(error => console.log(error))
        } else {
            this.getSports()
        }
    }
    
    searchEventsBySportId(sport_id, events_place) {
        client.get('/sports/' + sport_id)
        .then(response => {
            if (response.data && response.data !== "") {
                console.log(response.data)
                events_place.innerHTML = "<h4>Events:</h4>"
                Object.keys(response.data['events']).map(function(key) {
                    events_place.innerHTML  =  events_place.innerHTML + "<div class=\"event\"><p><span>Desc: </span><span>"+response.data['events'][key].desc+"</span></p><p><span>Event type: </span><span>"+response.data['events'][key].event_type+"</span></p></div>"
                }); 
            }
        })
        .catch(error => console.log(error))
    }
    
    handleClick(e) {
        e.target.parentNode.attributes[1].isToggleOn = !e.target.parentNode.attributes[1].isToggleOn
        e.target.textContent = e.target.parentNode.attributes[1].isToggleOn ? '[-]' : '[+]'
        
        e.target.parentNode.childNodes[2].style.display = e.target.parentNode.attributes[1].isToggleOn ? "block" : "none"

        if (e.target.parentNode.attributes[1].isToggleOn) {
            this.searchEventsBySportId(e.target.parentNode.attributes[1].value, e.target.parentNode.childNodes[2])
        }
    }
    
    componentDidMount() {
        this.getSports()
    }
    render() {
        return (
        <div>
        <div className="inputContainer">
        <input className="sportIdInput" type="text" 
            placeholder="Please write here a sport's ID and press ENTER for searching a sport by ID" maxLength="50" onKeyDown={this.searchSportById.bind(this)}/>
        </div>  	    
        <div className="listWrapper">
        <LoadingIndicator/>
        <ul className="sportList">
            {this.state.sports.map((sport) => {
                return( 
                    <li className="sport" custom-attribute={sport.id} key={sport.id}>
                        <label className="taskLabel">{sport.desc}</label>
                        <button className="detailssportBtn" onClick={this.handleClick.bind(this)}>
                            {sport.isToggleOn ? '[-]' : '[+]'}
                        </button>
                        <div className="details"></div>
                    </li>
                    )
            })}
        </ul>
        </div>
        </div>    
        )
    }
}

export default SportsContainer