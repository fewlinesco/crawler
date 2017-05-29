import { render } from 'react-dom'
import Boot from './crawler/boot'
import React from 'react'

const rootElement = document.querySelector('.crawler-app')

if (rootElement) {
  render(<Boot/>, rootElement)
}
