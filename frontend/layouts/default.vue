<template>
  <v-app>
    <v-navigation-drawer
      v-show="!loading"
      v-model="drawer"
      :mini-variant="miniVariant"
      :clipped="clipped"
      fixed
      app
    >
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
      <v-list>
        <v-list-item @click="logout">
          <v-list-item-action>
            <v-icon>mdi-logout-variant</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>ログアウト</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar
      v-show="!loading"
      :clipped-left="clipped"
      fixed
      app
      dark
      color="green darken-1"
      elevation="6"
    >
      <v-btn
        icon
        class="d-none d-lg-block"
        @click.stop="miniVariant = !miniVariant"
      >
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <v-icon dark large>mdi-cat</v-icon>
      <v-toolbar-title class="font-weight-black" v-text="title" />
      <v-spacer />
      <v-app-bar-nav-icon class="d-lg-none" @click.stop="drawer = !drawer" />
    </v-app-bar>
    <v-main>
      <v-container v-if="loading">
        <v-overlay z-index="2">
          <v-progress-circular indeterminate size="80"></v-progress-circular>
        </v-overlay>
      </v-container>
      <v-container v-show="!loading">
        <nuxt />
      </v-container>
    </v-main>
    <v-footer
      v-if="!loading"
      class="d-none d-lg-block"
      :absolute="!fixed"
      app
      color="green darken-1"
      dark
      elevation="20"
    >
      <span class="d-none d-lg-block"
        >&copy; {{ new Date().getFullYear() }}</span
      >
    </v-footer>
    <v-bottom-navigation
      v-show="!loading"
      background-color="green darken-1"
      elevation="20"
      app
      fixed
      dark
      grow
      shift
      class="d-lg-none"
    >
      <v-btn to="/register">
        <span>登録</span>
        <v-icon>mdi-pencil-plus</v-icon>
      </v-btn>
      <v-btn to="/inspire">
        <span>データ</span>
        <v-icon>mdi-notebook-multiple</v-icon>
      </v-btn>
      <v-btn to="/">
        <span>info</span>
        <v-icon>mdi-information-outline</v-icon>
      </v-btn>
      <v-btn to="/inspire">
        <span>設定</span>
        <v-icon>mdi-cog</v-icon>
      </v-btn>
    </v-bottom-navigation>
  </v-app>
</template>
<script>
export default {
  data() {
    return {
      clipped: true,
      drawer: null,
      fixed: true,
      user: null,
      items: [
        {
          icon: 'mdi-information-outline',
          title: '使い方',
          to: '/',
        },
        {
          icon: 'mdi-pencil-plus',
          title: '食べた物を登録する',
          to: '/register',
        },
        {
          icon: 'mdi-cog',
          title: '設定',
          to: '/inspire',
        },
      ],
      userMenus: [
        {
          title: 'ユーザページ',
          to: '/',
        },
        {
          title: 'ログアウト',
          to: 'logout()',
        },
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      userPullDown: false,
      title: 'ダイエットリーダー',
      loading: true,
    }
  },
  mounted() {
    this.$vuetify.theme.dark = false
    this.$nextTick(() => {
      this.loading = false // DOM更新後にこのコードに到達する
    })
  },
  methods: {
    async logout() {
      await this.$auth.logout() // ログアウト
      location.reload()
    },
  },
}
</script>
<style scoped>
.v-application {
  background-color: cornsilk;
  font-family: 'Hachi Maru Pop', cursive;
  padding-bottom: 20px;
}
</style>
