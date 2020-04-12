import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import SportsContainer from './components/SportsContainer'

class App extends Component {
  render() {
    return (
      <div className="container">
      <div className="header">
        <h1>Sport List</h1>
      </div>
        <SportsContainer />
      </div>
    );
  }
}

export default App;
