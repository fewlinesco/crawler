import { applyMiddleware, createStore } from 'redux'
import createLogger from 'redux-logger'
import rootReducer from '../reducers/index'
import thunkMiddleware from 'redux-thunk'

const loggerMiddleware = createLogger()

let middlewares = [thunkMiddleware]

if (process.env.NODE_ENV !== 'production') {
  middlewares = [...middlewares, loggerMiddleware]
}

export default function configureStore(preloadedState) {
  return createStore(rootReducer, preloadedState, applyMiddleware(...middlewares))
}
