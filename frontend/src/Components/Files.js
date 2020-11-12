import File from './File'

const Files = ({files}) => {
  const makeFile = file => <File key={file.fileID} {...{file}} />

  return <ul className="files">{files.map(makeFile)}</ul>
}

export default Files
