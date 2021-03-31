<template>
  <div class="mt-3">
    <v-card class="mt-5 mx-auto" max-width="600">
      <v-form ref="form">
        <v-container>
          <v-row justify="center">
            <p cols="12" class="mt-3 grey--text font-weight-bold">ログイン</p>
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
            <v-col cols="10">
              <v-btn
                block
                class="grey white--text"
                @click="loginWithAuthModule"
              >
                ログイン
              </v-btn>
            </v-col>
            <v-col cols="10">
              <v-btn block class="green white--text" @click="guestLogin">
                ゲストログイン
              </v-btn>
            </v-col>
            <v-col cols="10">
              <v-btn block dark color="#1DA1F2" @click="twitterLogin">
                <v-icon>mdi-twitter</v-icon>Twitter
              </v-btn>
            </v-col>
          </v-row>
        </v-container>
      </v-form>
    </v-card>
  </div>
</template>

<script>
import { auth } from '@/plugins/firebase'

export default {
  layout: 'login',
  data() {
    return {
      login: {
        email: '',
        password: '',
      },
    }
  },
  beforeCreate() {
    if (this.$auth.loggedIn) {
      this.$router.push('/')
    }
  },
  methods: {
    async loginWithAuthModule() {
      try {
        await this.$auth.loginWith('local', {
          data: this.login,
        })
        location.reload()
      } catch (err) {
        console.log(err)
      }
    },
    guestLogin() {
      this.login.email = 'kodakoda@gmail.com'
      this.login.password = '11111111'
      this.loginWithAuthModule()
    },
    twitterLogin() {
      auth()
        .signInWithPopup(new auth.TwitterAuthProvider())
        .then((response) => {
          console.log(response)
          auth()
            .currentUser.getIdToken(/* forceRefresh */ true)
            .then((idToken) => {
              this.$auth.loginWith('local', {
                data: { token: idToken },
              })
            })
        })
        .catch(() => {
          console.log(
            '現在Twitterでのログインは使用できません。後ほどお試しください。'
          )
        })
    },
  },
}
</script>
