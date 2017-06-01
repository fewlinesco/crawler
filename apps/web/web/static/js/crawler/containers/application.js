import { connect } from 'react-redux'
import { resetCrawler, startCrawler, stopCrawler } from '../actions/crawler'
import Application from '../components/application'
import React from 'react'

const mapStateToProps = (state, ownProps) => {
  return {
    channel: state.Crawler.channel,
    error: state.Crawler.error,
    loading: state.Crawler.loading,
    pages: state.Crawler.pages,
    power: state.Crawler.power,
    running: state.Crawler.running,
    url: state.Crawler.url
  }
}

const mapDispatchToProps = dispatch => {
  return {
    handleReset: () => {
      dispatch(resetCrawler())
    },
    handleStartCrawler: (url, power) => {
      dispatch(startCrawler(url, power))
    },
    handleStopCrawler: channel => {
      dispatch(stopCrawler(channel))
    }
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(Application)
