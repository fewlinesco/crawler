import Page from './page'
import Ramda from 'ramda'
import React from 'react'

export default ({ channel, onReset, onStop, pages, running, url }) => {
  const buildPage = (page, index) => {
    return <Page key={index} page={page} />
  }

  return (
    <div className="row">
      <div className="col-lg-10">
        <h1>{url} <small>Fetched {Ramda.length(pages)} pages</small></h1>
      </div>
      <div className="col-lg-2">
        {running && <a href="#" className="btn btn-default" onClick={onStop(channel)}>Stop</a>}
        {running || <a href="#" className="btn btn-default" onClick={onReset}>Reset</a>}
      </div>
      <div className="col-lg-12">
        {Ramda.addIndex(Ramda.map)(buildPage, pages)}
      </div>
    </div>
  )
}
