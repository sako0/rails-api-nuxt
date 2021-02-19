<template>
  <div class="mt-3">
    <v-card class="mt-5 mx-auto" max-width="600">
      <v-form ref="form">
        <v-container>
          <v-row justify="center">
            <p cols="12" class="mt-3 display-1 grey--text">ログイン</p>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-text-field v-model="login.email" label="Eメールアドレス" />
              <p class="caption mb-0" />
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-text-field
                v-model="login.password"
                type="password"
                label="パスワード"
              />
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-btn
                block
                class="mr-4 blue white--text"
                @click="loginWithAuthModule"
              >
                ログイン
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-form>
    </v-card>
  </div>
</template>

<script>
export default {
  layout: 'login',
  middleware({ store, redirect }) {
    if (store.$auth.loggedIn) {
      redirect('/')
    }
  },
  data() {
    return {
      login: {
        email: '',
        password: '',
      },
    }
  },
  methods: {
    async loginWithAuthModule() {
      try {
        const response = await this.$auth.loginWith('local', {
          data: this.login,
        })
        console.log(response)
        location.reload()
      } catch (err) {
        console.log(err)
      }
    },
  },
}
</script>

// this.$auth.setUser(response.headers.uid) //
レスポンスで返ってきた、認証に必要な情報をSessionStorageに保存 //
this.$store.commit( // 'setAccessToken', // response.headers['access-token'] //
) // this.$store.commit('setClient', response.headers.client) //
this.$store.commit('setUid', response.headers.uid) //
this.$store.commit('setTokenType', response.headers['token-type']) //
this.$auth.strategy.token.set(response.headers['access-token']) //
this.$auth.strategy.token.set(response.headers['access-token']) //
this.$auth.setUserToken(response.headers['access-token']) //
console.log(this.$auth.user) // const a = this.$axios.get('/api/v1/users/' +
response.data.data.id) // console.log(a) // return response // }, // (error) =>
{ // return error // } // ) // }, // }, // }
