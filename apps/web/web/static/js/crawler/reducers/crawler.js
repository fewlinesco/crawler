import {
  ADD_PAGE_TO_CRAWLER_SUCCEEDED,
  RESET_CRAWLER_SUCCEEDED,
  START_CRAWLER_FAILED,
  START_CRAWLER_REQUESTED,
  START_CRAWLER_SUCCEEDED,
  STOP_CRAWLER_FAILED,
  STOP_CRAWLER_REQUESTED,
  STOP_CRAWLER_SUCCEEDED
} from '../actions/crawler'
import Ramda from 'ramda'

const initialState = {
  channel: null,
  error: null,
  loading: false,
  pages: null,
  running: false,
  url: null
}

export default (state = initialState, action) => {
  switch (action.type) {
    case ADD_PAGE_TO_CRAWLER_SUCCEEDED:
      return {
        ...state,
        loading: false,
        pages: Ramda.append(action.page, state.pages)
      }
    case RESET_CRAWLER_SUCCEEDED:
      return initialState
    case START_CRAWLER_FAILED:
      return {
        ...state,
        error: action.error,
        loading: false,
        pages: null
      }
    case START_CRAWLER_REQUESTED:
      return {
        ...state,
        error: null,
        loading: true,
        pages: null,
        url: action.url
      }
    case START_CRAWLER_SUCCEEDED:
      return {
        ...state,
        channel: action.channel,
        error: null,
        loading: false,
        pages: [],
        running: true
      }
    case STOP_CRAWLER_FAILED:
      return {
        ...state,
        loading: false,
        error: action.error
      }
    case STOP_CRAWLER_REQUESTED:
      return {
        ...state,
        loading: true,
        error: null
      }
    case STOP_CRAWLER_SUCCEEDED:
      return {
        ...state,
        loading: false,
        error: null,
        running: false
      }
    default:
      return state
  }
}

