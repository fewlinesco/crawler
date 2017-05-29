import React from 'react'

export default class Form extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      url: props.url || ''
    }
  }

  handleSubmit = (event) => {
    event.preventDefault()

    this.props.onSubmit(this.state.url)
  }

  handleUpdateText = event => {
    this.setState({ url: event.target.value })
  }

  render() {
    return (
      <div className="jumbotron">
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
