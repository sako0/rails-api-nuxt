import axios from 'axios'

export default function ({ $axios, redirect }) {
  $axios.setToken('access_token')
  $axios.defaults.timeout = 10000
  $axios.onResponse((response) => {
    $axios.setHeader(
      'Access-Control-Allow-Origin',
      process.env.NUXT_ENV_RAILS_URL
    )
  })
  $axios.onRequest((config) => {
    axios.defaults.headers.common.Authorization = '1'
    return config
  })
}
