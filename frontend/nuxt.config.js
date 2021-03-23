import colors from 'vuetify/es5/util/colors'
require('dotenv').config()

const BASEURL = process.env.NUXT_ENV_RAILS_URL

export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  mode: 'spa',
  head: {
    titleTemplate: '%s - diet-reader',
    title: 'diet-reader',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },
  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [],
  generate: {
    // Nuxt.jsでビルドされるファイルの出力先を、publicに変更
    dir: '../public',
  },
  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [
    { src: '~/plugins/localStorage.js', ssr: false },
    '@/plugins/axios',
    '@/plugins/auth',
  ],
  build: {
    transpile: ['vee-validate'], // 追加 https://qiita.com/TK-C/items/9cab072c65d2f9ade5d0
    extend(config, ctx) {},
    quiet: true,
  },

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
    // https://go.nuxtjs.dev/vuetify
    '@nuxtjs/vuetify',
    '@nuxtjs/dotenv',
    '@nuxtjs/moment',
  ],
  moment: {
    // ここに@nuxtjs/momentのオプションが記述できる
    locales: ['ja'],
  },
  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    '@nuxtjs/proxy',
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://go.nuxtjs.dev/pwa
    '@nuxtjs/pwa',
    '@nuxtjs/auth-next',
    'nuxt-webfontloader',
  ],
  webfontloader: {
    google: {
      families: ['Hachi+Maru+Pop&display=swap'], // Loads Lato font with weights 400 and 700
    },
  },
  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    proxy: true,
    prefix: BASEURL,
    // baseURL: BASEURL,
    // browserBaseURL: BASEURL,
  },
  proxy: {
    '/api': {
      // ターゲット先のURLを指定
      target: BASEURL,
      pathRewrite: {
        '^/api': '/',
      },
    },
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      lang: 'ja',
    },
  },
  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: colors.blue.darken2,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
        },
      },
    },
  },
  router: {}, // ログイン画面も含めた全体のページに認証を必要とする。例外はauth: falseで設定する
  auth: {
    redirect: {
      login: '/login', // 未ログイン時に認証ルートへアクセスした際のリダイレクトURL
      logout: '/', // ログアウト時のリダイレクトURL
      callback: false, // Oauth認証等で必要となる コールバックルート
      home: '/login', // ログイン後のリダイレクトURL一度リダイレクトに成功しないとログインができないためlogin画面にリダイレクトさせている
    },
    strategies: {
      local: {
        token: {
          property: 'token',
          type: 'Bearer',
        },
        endpoints: {
          login: {
            url: '/api/v1/sessions',
            method: 'post',
            propertyName: 'access_token',
          },
          user: false,
          logout: false,
          clientId: true,
        },
      },
    },
  },
}
