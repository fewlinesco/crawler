import React from 'react'
import Error from '../components/error'
import Form from '../components/form'
import Loading from '../components/loading'
import Pages from '../components/pages'

export default ({ channel, handleReset, handleStartCrawler, handleStopCrawler, error, loading, pages, running, url }) => {
  const handleOnStop = (channel) => {
    return () => {
      handleStopCrawler(channel)
    }
  }

  return (
    <div>
      {error && <Error message={error} />}
      {loading && <Loading />}
      {pages ? <Pages channel={channel} pages={pages} running={running} url={url} onStop={handleOnStop} onReset={handleReset} /> :
               <Form disabled={loading} url={url} onSubmit={handleStartCrawler} />}
    </div>
  )
}
