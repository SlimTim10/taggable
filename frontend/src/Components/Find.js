const Find = ({findTags}) => {
  const makeFindTag = findTag => (
    <li key={findTag.tagID}><button>x</button> {findTag.tagText}</li>
  )
  
  return (
    <>
      <div>Find</div>
      <input placeholder="tag"></input>
      <ul className="find-tags">
        {findTags.map(makeFindTag)}
        <li><button>x</button> pets</li>
        <li><button>x</button> cat</li>
        <li><button>x</button> 2018</li>
        <li><button>x</button> cottage</li>
      </ul>
    </>
  )
}

export default Find
