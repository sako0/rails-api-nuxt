import colors from 'vuetify/es5/util/colors'
require('dotenv').config()

const BASEURL = process.env.NUXT_ENV_RAILS_URL

export default {

  modulesDir: ['./node_modules'],

  server: {
    host: '0.0.0.0',
    port: 80,
  },
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    titleTemplate: '%s - koda',
    title: 'ダイエットリーダー',
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
  plugins: ['@/plugins/axios', '@/plugins/auth', '@/plugins/scrollLock'],
  build: {
    transpile: ['vee-validate'], // 追加 https://qiita.com/TK-C/items/9cab072c65d2f9ade5d0
    extend(config, ctx) {},
    // ログの出力を減らす
    // quiet: true,
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
    '@nuxtjs/firebase',
    'nuxt-webfontloader'
  ],
  webfontloader: {
    google: {
      families: ['Noto+Sans+Japanese&display=swap'],
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
      secure: false,
      pathRewrite: {
        '^/api': '/',
      },
    },
  },

  // PWA module configuration: https://go.nuxtjs.dev/pwa
  pwa: {
    manifest: {
      name: 'ダイエットリーダ',
      lang: 'ja',
      display: 'standalone',
      start_url: '/register',
    },
  },
  ssr: true,
  // Vuetify module configuration: https://go.nuxtjs.dev/config-vuetify
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    treeShake: true,
    defaultAssets: {
      font: {
        family: 'Noto Sans Japanese',
      },
    },
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
      logout: '/login', // ログアウト時のリダイレクトURL
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
  firebase: {
    config: {
      apiKey: process.env.FIREBASE_API_KEY,
      authDomain: process.env.FIREBASE_AUTH_DOMAIN,
      databaseURL: process.env.FIREBASE_DATABASE_URL,
      projectId: process.env.FIREBASE_PROJECT_ID,
      storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
      messagingSenderId: process.env.FIREBASE_MESSSAGE_SENDER_ID,
      appId: process.env.FIREBASE_APP_ID,
      measurementId: process.env.FIREBASE_MEASUREMENT_ID,
    },
    services: {
      auth: {
        ssr: true, // default
      },
    },
  },
}
