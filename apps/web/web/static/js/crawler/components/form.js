import React from 'react'

export default class Form extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      url: props.url || '',
      power: 10
    }
  }

  handleSubmit = (event) => {
    event.preventDefault()

    this.props.onSubmit(this.state.url, this.state.power)
  }

  handleUpdatePower = value => {
    return () => {
      this.setState({ power: value })
    }
  }

  handleUpdateText = event => {
    this.setState({ url: event.target.value })
  }

  render() {
    const btnClassName = (value) => {
      return this.state.power == value ? 'btn btn-primary' : 'btn btn-default'
    }

    return (
      <div className="jumbotron">
        <div className="row">
          <div className="col-lg-12">
            <label htmlFor="power">Power &nbsp;</label>
            <div className="btn-group">
              <div className={btnClassName(5)} onClick={this.handleUpdatePower(5)}>5 🐌</div>
              <div className={btnClassName(10)} onClick={this.handleUpdatePower(10)}>10 🐴</div>
              <div className={btnClassName(20)} onClick={this.handleUpdatePower(20)}>20 🚌</div>
              <div className={btnClassName(50)} onClick={this.handleUpdatePower(50)}>50 🏎</div>
              <div className={btnClassName(100)} onClick={this.handleUpdatePower(100)}>100 🦄</div>
            </div>
          </div>
        </div>
        <div className="row">
          <div className="col-lg-12">
            <label htmlFor="url">Your URL</label>
            <div className="input-group">
              <input
                type="url"
                className="form-control"
                id="url"
                disabled={this.props.disabled}
                placeholder="https://www.groomgroom.co"
                onChange={this.handleUpdateText}
                value={this.state.url} />
              <span className="input-group-btn">
                <button
                  type="button"
                  className="btn btn-default"
                  disabled={this.props.disabled}
                  onClick={this.handleSubmit}
                >
                  Crawl!
                </button>
              </span>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
