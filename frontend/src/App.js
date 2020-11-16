import { useState, useEffect } from 'react'
import axios from 'axios'
// import logo from './logo.svg'
import './App.css'
import Header from './Layout/Header'
import LeftSidebar from './Layout/LeftSidebar'
import Main from './Layout/Main'

const App = () => {
  const [files, setFiles] = useState([])
  const [findTags, setFindTags] = useState([])

  const fetchFiles = async () => {
    try {
      const res = await axios.get('/files?tags=cat,birthday')
      // const res = await axios.get('/files')
      if (Array.isArray(res.data)) setFiles(res.data)
    } catch (e) {
      console.error('Could not fetch files')
      console.error(e)
    }
  }

  const filterFiles = async (findTags) => {
    console.log(findTags)
    // try {
    //   const q = findTags
    //         .map(t => t.tagText)
    //         .join(',')
    //   const res = await axios.get(`/files?q=${q}`)
    //   if (Array.isArray(res.data)) setFiles(res.data)
    // } catch (e) {
    //   console.error('Could not fetch files')
    //   console.error(e)
    // }
  }
  
  useEffect(() => {
    fetchFiles()
  }, [])

  useEffect(() => {
    filterFiles(findTags)
  }, [findTags])

  return (
    <div className="App">
      <Header />
      <LeftSidebar {...{findTags}} />
      <Main {...{files}} />
    </div>
  )
}

export default App
