import Find from '../Components/Find'

const LeftSidebar = ({findTags, setFindTags, tagInput, setTagInput, selectionTags}) => {
  return (
    <div className="left-sidebar">
      <Find {...{findTags, setFindTags, tagInput, setTagInput, selectionTags}} />
    </div>
  )
}

export default LeftSidebar
