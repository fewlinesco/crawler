import Ramda from 'ramda'
import React from 'react'

export default class Page extends React.Component {
  constructor(props) {
    super(props)
    this.state = { open: false }
  }

  handleClick = (event) => {
    event.preventDefault()

    this.setState({ open: !this.state.open })
  }

  render() {
    return (
      <dl id={this.props.page.url} onClick={this.handleClick}>
        <dt>{this.props.page.url}</dt>
      </dl>
    )
  }
}
