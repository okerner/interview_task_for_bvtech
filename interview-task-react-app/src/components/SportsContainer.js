import React, { Component } from 'react'
import axios from 'axios'
import { apiConfig } from '../config/config'

const client = axios.create({
    baseURL: apiConfig.baseUrl,
    headers: {
     Accept: 'application/json',
    }
});

class SportsContainer extends Component {
    constructor(props) {
        super(props)
        this.state = {
          sports: [],
          isToggleOn: false
        }
    }
    getSports() {
        client.get('/sports')
        .then(response => {
            this.setState({sports: response.data})
        })
        .catch(error => console.log(error))
    }

    searchSportById(e) {
        client.get('/sports/' + e.target.value)
        .then(response => {
            console.log(response.data)
            this.setState({sports: [response.data]})
        })
        .catch(error => console.log(error))
    }
    
    handleClick() {
        this.setState({isToggleOn: !this.state.isToggleOn});
    }
    
    componentDidMount() {
        this.getSports()
    }
    render() {
        return (
        <div>
        <div className="inputContainer">
        <input className="sportIdInput" type="text" 
            placeholder="Search a sport by ID" maxLength="50" onKeyPress={this.searchSportById}/>
        </div>  	    
        <div className="listWrapper">
        <ul className="sportList">
            {this.state.sports.map((sport) => {
                return(
                    <li className="sport" sport={sport} key={sport.id}>
                        <label className="taskLabel">{sport.desc}</label>
                        <button onClick={this.handleClick}>
                            {this.state.isToggleOn ? '[-]' : '[+]'}
                        </button>
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