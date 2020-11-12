const LeftSidebar = () => {
  return (
    <div className="left-sidebar">
      <div>Find</div>
      <input placeholder="tag"></input>
      <ul className="find-tags">
        <li>pets</li>
        <li>cat</li>
        <li>2018</li>
        <li>cottage</li>
      </ul>
    </div>
  )
}

export default LeftSidebar
