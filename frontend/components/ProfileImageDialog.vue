<template>
  <v-dialog v-model="isDisplay" width="920px">
    <validation-observer ref="observer" v-slot="{ invalid }">
      <form @submit.prevent="submit">
        <v-card>
          <v-card-title>{{ title }}</v-card-title>
          <v-row>
            <v-col cols="5" class="text-center">
              <v-card-text>
                <profileCard :user="user" :preview-flg="true" />
              </v-card-text>
            </v-col>
            <v-col cols="6">
              <v-row>
                <v-col cols="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="Name"
                    rules="required|max:35"
                  >
                    <v-text-field
                      v-model="name"
                      :counter="35"
                      :error-messages="errors"
                      label="Name"
                      required
                    ></v-text-field>
                  </validation-provider>
                </v-col>
                <v-col cols="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="Job"
                    rules="max:35"
                  >
                    <v-text-field
                      v-model="job"
                      :counter="35"
                      :error-messages="errors"
                      label="Job"
                    ></v-text-field>
                  </validation-provider>
                </v-col>
              </v-row>

              <validation-provider
                v-slot="{ errors }"
                name="email"
                rules="required|email"
              >
                <v-text-field
                  v-model="email"
                  :error-messages="errors"
                  label="E-mail"
                  required
                ></v-text-field>
              </validation-provider>
            </v-col>
          </v-row>
          <v-card-actions>
            <v-row justify="center">
              <v-col cols="6">
                <v-btn @click="isDisplay = false">Close</v-btn>
              </v-col>
              <v-col cols="6" class="text-right">
                <v-btn
                  class="mr-4"
                  type="submit"
                  :disabled="invalid"
                  color="orange darken-3"
                  @click="submit"
                >
                  更新
                </v-btn>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-card>
      </form>
    </validation-observer>
  </v-dialog>
</template>

<script>
import ProfileCard from '@/components/ProfileCard'
import { required, digits, email, max, regex } from 'vee-validate/dist/rules'
import {
  extend,
  ValidationObserver,
  ValidationProvider,
  setInteractionMode,
} from 'vee-validate'

setInteractionMode('eager')

extend('digits', {
  ...digits,
  message: '{_field_} needs to be {length} digits. ({_value_})',
})

extend('required', {
  ...required,
  message: '{_field_} は必ず入力して下さい',
})

extend('max', {
  ...max,
  message: '{_field_} may not be greater than {length} characters',
})

extend('regex', {
  ...regex,
  message: '{_field_} {_value_} does not match {regex}',
})

extend('email', {
  ...email,
  message: 'Emailの形式が間違っています',
})

export default {
  components: {
    ProfileCard,
    ValidationProvider,
    ValidationObserver,
  },
  props: {
    // Object形に変換
    user: Object,
  },
  data: () => ({
    isDisplay: false,
    title: '',
  }),
  mounted() {
    this.title = 'プロフィール画像変更'
  },
  methods: {
    submit() {
      this.isDisplay = false
      this.$emit('method')
    },
    closeDisplay() {
      this.isDisplay = false
    },
  },
}
</script>
