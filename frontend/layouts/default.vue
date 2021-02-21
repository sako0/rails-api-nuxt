<template>
  <v-app dark>
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
    </v-navigation-drawer>
    <v-app-bar :clipped-left="clipped" fixed app>
      <v-app-bar-nav-icon class="d-lg-none" @click.stop="drawer = !drawer" />
      <v-btn
        icon
        class="d-none d-lg-block"
        @click.stop="miniVariant = !miniVariant"
      >
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <!--      <v-btn icon @click.stop="clipped = !clipped">-->
      <!--        <v-icon>mdi-application</v-icon>-->
      <!--      </v-btn>-->
      <!--      <v-btn icon @click.stop="fixed = !fixed">-->
      <!--        <v-icon>mdi-minus</v-icon>-->
      <!--      </v-btn>-->
      <v-toolbar-title v-text="title" />
      <v-spacer />
      <div class="text-center">
        <v-menu offset-y>
          <template #activator="{ on, attrs }">
            <v-btn class="mx-2" fab dark color="gray" v-bind="attrs" v-on="on">
              <v-icon dark>mdi-format-list-bulleted-square</v-icon>
            </v-btn>
          </template>
          <v-list>
            <v-list-item
              v-for="(item, index) in userMenus"
              :key="index"
              @click="logout()"
            >
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </div>

      <v-btn
        class="mx-2"
        fab
        dark
        color="gray"
        @click.stop="rightDrawer = !rightDrawer"
      >
        <v-icon dark color="teal accent-2">mdi-account-check</v-icon>
      </v-btn>
    </v-app-bar>
    <v-main>
      <v-container>
        <nuxt />
      </v-container>
    </v-main>
    <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>
      <v-list>
        <v-list-item>
          <v-list-item-title>ログイン中のユーザ</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-footer :absolute="!fixed" app>
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      clipped: true,
      drawer: true,
      fixed: true,
      user: null,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Welcome',
          to: '/',
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Inspire',
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
      title: 'Vuetify.js',
    }
  },
  methods: {
    async logout() {
      await this.$auth.logout() // ログアウト
      location.reload()
    },
  },
}
</script>
