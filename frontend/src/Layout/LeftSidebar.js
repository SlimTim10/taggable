const LeftSidebar = () => {
  return (
    <div className="left-sidebar">
      <div>Find</div>
      <input placeholder="tag"></input>
      <ul className="find-tags">
        <li><button>x</button> pets</li>
        <li><button>x</button> cat</li>
        <li><button>x</button> 2018</li>
        <li><button>x</button> cottage</li>
      </ul>
    </div>
  )
}

export default LeftSidebar
