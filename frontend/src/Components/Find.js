import FindTextField from './FindTextField'

const Find = ({findTags, removeTag, addTag}) => {
  const makeFindTag = findTag => (
    <li key={findTag.tagID}>
      <button onClick={() => removeTag(findTag)}>x</button> {findTag.tagText}
    </li>
  )
  
  return (
    <>
      <div>Find</div>
      <FindTextField {...{addTag}}/>
      <ul className="find-tags">
        {findTags.map(makeFindTag)}
      </ul>
    </>
  )
}

export default Find
