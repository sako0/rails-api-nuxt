<template>
  <v-app>
    <v-navigation-drawer
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
      <template #append>
        <v-row>
          <v-col cols="8"> </v-col>
          <v-col cols="2" class="pb-5">
            <v-btn block><v-icon>mdi-tune</v-icon></v-btn>
          </v-col>
        </v-row>
      </template>
    </v-navigation-drawer>
    <v-app-bar
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
      <v-toolbar-title v-text="title" />
      <v-spacer />
      <v-app-bar-nav-icon class="d-lg-none" @click.stop="drawer = !drawer" />
    </v-app-bar>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <!--    <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>-->
    <!--      <v-list>-->
    <!--        <v-list-item>-->
    <!--          <v-list-item-title>ログイン中のユーザ</v-list-item-title>-->
    <!--        </v-list-item>-->
    <!--      </v-list>-->
    <!--    </v-navigation-drawer>-->
    <v-footer :absolute="!fixed" app color="green darken-1" dark elevation="20">
      <v-row justify="center" class="d-lg-none">
        <v-col cols="3">
          <v-btn text to="/register"><v-icon>mdi-pencil-plus</v-icon></v-btn>
        </v-col>
        <v-col cols="3">
          <v-btn text to="/inspire"
            ><v-icon>mdi-notebook-multiple</v-icon></v-btn
          >
        </v-col>
        <v-col cols="3">
          <v-btn text to="/"><v-icon>mdi-information-outline</v-icon></v-btn>
        </v-col>
        <v-col cols="3">
          <v-btn text to="/inspire"><v-icon>mdi-cog</v-icon></v-btn>
        </v-col>
      </v-row>
      <span class="d-none d-lg-block"
        >&copy; {{ new Date().getFullYear() }}</span
      >
    </v-footer>
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
    }
  },
  mounted() {
    this.$vuetify.theme.dark = false
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
}
</style>
