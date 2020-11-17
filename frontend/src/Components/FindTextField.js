import { useState, useEffect } from 'react'
import axios from 'axios'
import { TextField, CircularProgress } from '@material-ui/core'
import { Autocomplete } from '@material-ui/lab'

const FindTextField = ({addTag}) => {
  const [open, setOpen] = useState(false)
  const [options, setOptions] = useState([])
  const loading = open && options.length === 0

  useEffect(() => {
    let active = true

    if (!loading) return undefined

    const fetchTags = async () => {
      try {
        const url = `/tags`
        const res = await axios.get(url)
        if (active && Array.isArray(res.data)) {
          setOptions(res.data)
        }
      } catch (e) {
        console.error('Could not fetch tags')
        console.error(e)
      }
    }

    fetchTags()
    
    return () => {
      active = false
    }
  }, [loading])

  useEffect(() => {
    if (!open) {
      setOptions([])
    }
  }, [open])
    
  return (
    <Autocomplete
      id="find-text-field"
      style={{ width: 300 }}
      autoHighlight={true}
      open={open}
      onOpen={() => {
        setOpen(true)
      }}
      onClose={() => {
        setOpen(false)
      }}
      onChange={(event, newValue) => {
        if (newValue) {
          addTag(newValue)
        }
      }}
      getOptionSelected={(option, value) => option.tagText === value.tagText}
      getOptionLabel={option => option.tagText}
      options={options}
      loading={loading}
      renderInput={params => (
        <TextField
          {...params}
          label="tag"
          variant="outlined"
          InputProps={{
            ...params.InputProps,
            endAdornment: (
              <>
                {loading ? <CircularProgress color="inherit" size={20} /> : null}
                {params.InputProps.endAdornment}
              </>
            )
          }}
        />
      )}
    />
  )
}

export default FindTextField
