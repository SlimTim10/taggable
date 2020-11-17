import { useState } from 'react'

const Find = ({findTags, setFindTags, tagInput, setTagInput, selectionTags}) => {
  const removeTag = tagID => (e) => {
    setFindTags(fts => fts.filter(ft => ft.tagID !== tagID))
  }

  const handleInput = (e) => {
    setTagInput(e.target.value)
  }
  
  const makeFindTag = findTag => (
    <li key={findTag.tagID}>
      <button onClick={removeTag(findTag.tagID)}>x</button> {findTag.tagText}
    </li>
  )
  
  return (
    <>
      <div>Find</div>
      <input onChange={handleInput} placeholder="tag"></input>
      <ul className="find-tags">
        {findTags.map(makeFindTag)}
      </ul>
    </>
  )
}

export default Find
