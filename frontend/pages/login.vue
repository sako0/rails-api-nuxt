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
              <v-text-field v-model="email" label="Eメールアドレス" />
              <p class="caption mb-0" />
            </v-col>
          </v-row>
          <v-row justify="center">
            <v-col cols="12" md="10" sm="10">
              <v-text-field
                v-model="password"
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
  data() {
    return {
      password: '',
      email: '',
    }
  },
  methods: {
    async loginWithAuthModule() {
      await this.$auth
        .loginWith('local', {
          data: {
            email: this.email,
            password: this.password,
          },
        })
        .then(
          (response) => {
            console.log(response.headers.uid)
            this.$auth.setUser(response.headers.uid)
            // レスポンスで返ってきた、認証に必要な情報をSessionStorageに保存
            // this.$store.commit(
            //   'setAccessToken',
            //   response.headers['access-token']
            // )
            // this.$store.commit('setClient', response.headers.client)
            // this.$store.commit('setUid', response.headers.uid)
            // this.$store.commit('setTokenType', response.headers['token-type'])
            // this.$auth.strategy.token.set(response.headers['access-token'])
            this.$auth.strategy.token.set(response.headers['access-token'])
            this.$auth.setUserToken(response.headers['access-token'])
            console.log(this.$auth.user)
            console.log(this.$axios.get('/api/v1/users/' + 1))

            return response
          },
          (error) => {
            return error
          }
        )
    },
  },
}
</script>
