import { Provider } from 'react-redux'
import configureStore from './store/index'
import Application from './containers/application'
import React from 'react'

const store = configureStore()

export default () => {
  return (
    <Provider store={store}>
      <Application />
    </Provider>
  )
}
