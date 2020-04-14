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
          sports: []
        }
    }

    getSports() {
        trackPromise(
            client.get('/sports')
            .then(response => {
                const sports = response.data
                Promise.all(sports.map(async (sport) => {
                    sport.isToggleOn = false
                    const events = await client.get('/sports/' + sport.id)
                    const event_array = []
                    console.log(events.data['events'])
                    const keys = Object.keys(events.data['events'])
                    for (const key of keys) {
                        event_array.push(events.data['events'][key])
                    }
                    sport.events = event_array
                    console.log('events:')
                    console.log(events.data['events'])
                })).then(response => {
                    console.log('sports:')
                    console.log(sports)
                    this.setState({sports: sports})
                    }
                );
            })
            .catch(error => console.log(error))
        )
    }

    searchSportById(e) {
        if (e.target.value && e.target.value !== "") {
            trackPromise(
                client.get('/sports/' + e.target.value)
                .then(response => {
                    if (response.data && response.data !== "") {
                        console.log(response.data)
                        response.data.isToggleOn = false
                        response.data.events = this.searchEventsBySportId(response.data['sport'].id)
                        this.setState({sports: [response.data['sport']]})
                        
                    }
                })
                .catch(error => console.log(error))
            )
        } else {
            this.getSports()
        }
    }
    
    
    handleClick(e) {
        e.target.parentNode.attributes[1].isToggleOn = !e.target.parentNode.attributes[1].isToggleOn
        e.target.textContent = e.target.parentNode.attributes[1].isToggleOn ? '[-]' : '[+]'
        
        e.target.parentNode.childNodes[2].style.display = e.target.parentNode.attributes[1].isToggleOn ? "block" : "none"
    }

    showOutcomes(e) {
        const all_outcomes = document.querySelectorAll('.outcomes');
        e.target.parentNode.childNodes[1].style.display = e.target.parentNode.childNodes[1].style.display != 'block' ? 'block' : 'none'
        all_outcomes.forEach(element => {
            if (element != e.target.parentNode.childNodes[1]) {
                element.style.display = 'none'
            }
        })
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
                        <div className="details">
                            <h4>Events:</h4>
                            {sport.events.map((event) => {
                                return(<div className="event" key={event.id}>
                                    <div className="outcomesContainer">
                                        <a className="outcomesButton" onClick={this.showOutcomes.bind(this)}>Show outcomes</a>
                                        <div className="outcomes">
                                            <h3>Outcomes:</h3>
                                            {event.outcomes.map((outcome) => {
                                                return(
                                                    <div key={outcome.oid} className="outcome">
                                                        <p>
                                                            <span>Desc: </span>
                                                            <span>{outcome.d}</span>
                                                        </p>
                                                        <p>
                                                            <span>Fdp: </span>
                                                            <span>{outcome.fdp}</span>
                                                        </p> 
                                                        <p>
                                                            <span>Pr: </span>
                                                            <span>{outcome.pr}</span>
                                                        </p> 
                                                    </div>           
                                                )
                                            })}
                                        </div>
                                    </div>
                                    <p>
                                        <span>Desc: </span>
                                        <span>{event.desc}</span>
                                    </p>
                                    <p>
                                        <span>Event type: </span>
                                        <span>{event.event_type}</span>
                                    </p>
                                </div>)
                            })}
                        </div>
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