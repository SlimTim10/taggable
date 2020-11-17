import { useState, useEffect } from 'react'
import axios from 'axios'
// import logo from './logo.svg'
import './App.css'
import Header from './Layout/Header'
import LeftSidebar from './Layout/LeftSidebar'
import Main from './Layout/Main'

const formatTagQuery = tags => tags
      .map(t => t.tagText)
      .join(',')
const empty = xs => xs.length === 0

const App = () => {
  const [files, setFiles] = useState([])
  const [selectionTags, setSelectionTags] = useState([])
  // const [findTags, setFindTags] = useState([])
  const [findTags, setFindTags] = useState([
    {tagID: 1, tagText: 'pets'},
    {tagID: 2, tagText: 'cat'},
    {tagID: 3, tagText: 'birthday'},
  ])
  const [tagInput, setTagInput] = useState('')

  useEffect(() => {
    const fetchTags = async () => {
      try {
        const url =
              empty(tagInput) ? `/tags`
              : `/tags?match=${tagInput}`
        const res = await axios.get(url)
        if (Array.isArray(res.data)) setSelectionTags(res.data)
      } catch (e) {
        console.error('Could not fetch tags')
        console.error(e)
      }
    }

    fetchTags()
  }, [tagInput])

  useEffect(() => {
    const fetchFiles = async () => {
      try {
        const url =
          empty(findTags) ? `/files`
          : `/files?tags=${formatTagQuery(findTags)}`
        const res = await axios.get(url)
        if (Array.isArray(res.data)) setFiles(res.data)
      } catch (e) {
        console.error('Could not fetch files')
        console.error(e)
      }
    }
    
    fetchFiles()
  }, [findTags])

  return (
    <div className="App">
      <Header />
      <LeftSidebar {...{findTags, setFindTags, tagInput, setTagInput, selectionTags}} />
      <Main {...{files}} />
    </div>
  )
}

export default App
