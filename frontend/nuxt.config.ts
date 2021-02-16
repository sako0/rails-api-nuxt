export default {
    env: {},
    head: {
        title: "frontend",
        meta: [
            {charset: "utf-8"},
            {name: "viewport", content: "width=device-width, initial-scale=1"},
            {hid: "description", name: "description", content: "Nuxt.js TypeScript project"}
        ],
        link: [
            {rel: "icon", type: "image/x-icon", href: "/favicon.ico"}
        ]
    },
    loading: {color: "#3B8070"},
    css: ["~/assets/css/main.css", "element-ui/lib/theme-chalk/index.css"],
    build: {},
    generate: {
        // Nuxt.jsでビルドされるファイルの出力先を、publicに変更
        dir: '../public'
    },
    buildModules: ["@nuxt/typescript-build", '@nuxtjs/vuetify'],
    modules: [
        "@nuxtjs/axios",
        '@nuxtjs/proxy'
    ],
    plugins: [],
    axios: {
        prefix: '/api'
    },
    proxy: {
        '/api': {
            target: 'http://127.0.0.1:3000',
            pathRewrite: {
                '^/api': '/'
            }
        }
    }
}
