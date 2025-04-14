import axios from 'axios'

const api = axios.create({
  baseURL: 'http://10.10.100.49/Record/server/',
  // baseURL: 'http://localhost/Record/server/',

  timeout: 5000
})

export default api