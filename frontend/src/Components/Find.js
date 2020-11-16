const Find = ({findTags, setFindTags}) => {
  const removeTag = tagID => (e) => {
    setFindTags(fts => fts.filter(ft => ft.tagID !== tagID))
  }
  
  const makeFindTag = findTag => (
    <li key={findTag.tagID}>
      <button onClick={removeTag(findTag.tagID)}>x</button> {findTag.tagText}
    </li>
  )
  
  return (
    <>
      <div>Find</div>
      <input placeholder="tag"></input>
      <ul className="find-tags">
        {findTags.map(makeFindTag)}
      </ul>
    </>
  )
}

export default Find
