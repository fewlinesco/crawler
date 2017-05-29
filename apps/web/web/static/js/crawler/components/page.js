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
    const visibilityClass = this.state.open ? 'show' : 'hidden'
    const buildChild = (url, index) => {
      return <li key={index}><a href={url}>{url}</a></li>
    }

    return (
      <dl id={this.props.page.url} onClick={this.handleClick}>
        <dt>{this.props.page.url}</dt>
        <dd className={visibilityClass}>
          <ul>{Ramda.addIndex(Ramda.map)(buildChild, this.props.page.children)}</ul>
        </dd>
      </dl>
    )
  }
}
