import { configureChannel } from '../../socket'

export const ADD_PAGE_TO_CRAWLER_SUCCEEDED = 'ADD_PAGE_TO_CRAWLER_SUCCEEDED'
export const RESET_CRAWLER_SUCCEEDED = 'RESET_CRAWLER_SUCCEEDED'
export const START_CRAWLER_FAILED = 'START_CRAWLER_FAILED'
export const START_CRAWLER_REQUESTED = 'START_CRAWLER_REQUESTED'
export const START_CRAWLER_SUCCEEDED = 'START_CRAWLER_SUCCEEDED'
export const STOP_CRAWLER_FAILED = 'STOP_CRAWLER_FAILED'
export const STOP_CRAWLER_REQUESTED = 'STOP_CRAWLER_REQUESTED'
export const STOP_CRAWLER_SUCCEEDED = 'STOP_CRAWLER_SUCCEEDED'

export const resetCrawler = () => {
  return (dispatch) => {
    dispatch(resetCrawlerSucceeded())
  }
}

export const startCrawler = (url, power) => {
  return (dispatch) => {
    dispatch(startCrawlerRequested(url))

    const socket = configureChannel()
    const channel = socket.channel('crawler:new')

    channel
      .join()
      .receive('ok', () => {
        channel.on('link_found', page => { dispatch(addPageToCrawlerSucceeded(page)) })
        channel.on('stopped', page => { dispatch(stopCrawlerSucceeded()) })

        channel.push('crawl', {url: url, power: power})

        dispatch(startCrawlerSucceeded(channel, power))
      })
      .receive('error', error => {
        dispatch(startCrawlerFailed(error))
      })
  }
}

export const stopCrawler = channel => {
  return (dispatch) => {
    dispatch(stopCrawlerRequested())

    channel.push('stop', {})
  }
}

export const resetCrawlerSucceeded = () => {
  return {
    type: RESET_CRAWLER_SUCCEEDED
  }
}

export const addPageToCrawlerSucceeded = page => {
  return {
    type: ADD_PAGE_TO_CRAWLER_SUCCEEDED,
    page: page
  }
}

export const startCrawlerFailed = error => {
  return {
    type: START_CRAWLER_FAILED,
    error: error
  }
}

export const startCrawlerRequested = url => {
  return {
    type: START_CRAWLER_REQUESTED,
    url: url
  }
}

export const startCrawlerSucceeded = (channel, power) => {
  return {
    type: START_CRAWLER_SUCCEEDED,
    channel: channel,
    power: power
  }
}

export const stopCrawlerFailed = error => {
  return {
    type: STOP_CRAWLER_FAILED,
    error: error
  }
}

export const stopCrawlerRequested = () => {
  return {
    type: STOP_CRAWLER_REQUESTED
  }
}

export const stopCrawlerSucceeded = () => {
  return {
    type: STOP_CRAWLER_SUCCEEDED
  }
}
