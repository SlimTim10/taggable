import Find from '../Components/Find'

const LeftSidebar = ({findTags}) => {
  return (
    <div className="left-sidebar">
      <Find {...{findTags}} />
    </div>
  )
}

export default LeftSidebar
