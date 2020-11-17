import Find from '../Components/Find'

const LeftSidebar = ({findTags, removeTag, addTag}) => {
  return (
    <div className="left-sidebar">
      <Find {...{findTags, removeTag, addTag}} />
    </div>
  )
}

export default LeftSidebar
