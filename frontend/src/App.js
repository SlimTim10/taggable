import { useState, useEffect } from 'react'
import axios from 'axios'
// import logo from './logo.svg'
import './App.css'
import Header from './Layout/Header'
import LeftSidebar from './Layout/LeftSidebar'
import Main from './Layout/Main'

const formatTagQuery = tags => tags
      .map(t => t.text)
      .join(',')
const empty = xs => xs.length === 0

const App = () => {
  const [files, setFiles] = useState([])
  // const [findTags, setFindTags] = useState([])
  const [findTags, setFindTags] = useState([
    {id: 1, text: 'pets'},
    {id: 2, text: 'cat'},
    {id: 3, text: 'birthday'},
  ])

  const removeTag = tag => {
    setFindTags(fts => fts.filter(ft => ft.id !== tag.id))
  }

  const addTag = tag => {
    if (!findTags.map(t => t.id).includes(tag.id)) {
      setFindTags(fts => [...fts, tag])
    }
  }

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
      <LeftSidebar {...{findTags, removeTag, addTag}} />
      <Main {...{files}} />
    </div>
  )
}

export default App
