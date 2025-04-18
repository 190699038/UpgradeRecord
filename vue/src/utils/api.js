import axios from 'axios'

const api = axios.create({
  baseURL: 'https://record.gameyzy.com/server/',
  // baseURL: 'http://localhost/Record/server/',

  timeout: 5000
})

export default api