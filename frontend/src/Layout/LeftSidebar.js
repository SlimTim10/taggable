import Find from '../Components/Find'

const LeftSidebar = ({findTags, setFindTags}) => {
  return (
    <div className="left-sidebar">
      <Find {...{findTags, setFindTags}} />
    </div>
  )
}

export default LeftSidebar
