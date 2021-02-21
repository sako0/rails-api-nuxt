<template>
  <v-dialog v-model="isDisplay" width="63%">
    <validation-observer ref="observer" v-slot="{ invalid }">
      <form @submit.prevent="submit">
        <v-card>
          <v-card-title>{{ title }}</v-card-title>
          <v-row>
            <v-col cols="12" sm="12" md="5" lg="5" xl="5" class="text-center">
              <v-card-text>
                <profileCard :user="user" :preview-flg="true" />
              </v-card-text>
            </v-col>
            <v-col cols="12" sm="12" md="6" lg="6" xl="6">
              <v-row justify="center">
                <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="Name"
                    rules="required|max:35"
                  >
                    <v-text-field
                      v-model="name"
                      append-icon="mdi-account-edit"
                      :counter="35"
                      :error-messages="errors"
                      label="Name"
                      required
                    ></v-text-field>
                  </validation-provider>
                </v-col>
                <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                  <validation-provider
                    v-slot="{ errors }"
                    name="Job"
                    rules="max:35"
                  >
                    <v-text-field
                      v-model="job"
                      append-icon="mdi-domain"
                      :counter="35"
                      :error-messages="errors"
                      label="Job"
                    ></v-text-field>
                  </validation-provider>
                </v-col>

                <v-col cols="11" sm="12" md="12" lg="12" xl="12">
                  <validation-provider
                    v-slot="{ errors }"
                    name="email"
                    rules="required|email"
                  >
                    <v-text-field
                      v-model="email"
                      append-icon="mdi-at"
                      disabled
                      :error-messages="errors"
                      label="E-mail"
                      required
                    ></v-text-field>
                  </validation-provider>
                </v-col>
                <v-col cols="11" sm="12" md="12" lg="12" xl="12">
                  <validation-provider
                    v-slot="{ errors }"
                    name="url"
                    rules="regex:https?://([\w-]+\.)+[\w-]+(/[\w- .?%&=]*)?"
                  >
                    <v-text-field
                      v-model="url"
                      append-icon="mdi-file-find-outline"
                      :error-messages="errors"
                      label="URL"
                    ></v-text-field>
                  </validation-provider>
                </v-col>
                <v-col cols="11" sm="11" md="12" lg="12" xl="12">
                  <validation-provider
                    v-slot="{ errors }"
                    name="Skills"
                    rules="max:100"
                  >
                    <v-textarea
                      v-model="skills"
                      append-icon="mdi-head-dots-horizontal-outline"
                      :counter="100"
                      :error-messages="errors"
                      auto-grow
                      rows="1"
                      label="Skills"
                    ></v-textarea>
                  </validation-provider>
                </v-col>
                <v-col cols="11" sm="12" md="12" lg="12" xl="12">
                  <validation-provider
                    v-slot="{ errors }"
                    name="notes"
                    rules="max:220"
                  >
                    <v-textarea
                      v-model="notes"
                      append-icon="mdi-book-open-page-variant-outline"
                      :error-messages="errors"
                      label="Notes"
                      auto-grow
                      rows="1"
                      counter="220"
                    ></v-textarea>
                  </validation-provider>
                </v-col>
              </v-row>
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
  message: '{_field_} は {length} 文字以内で入力して下さい',
})

extend('regex', {
  ...regex,
  message: '{_field_} を正しく入力して下さい',
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
    this.title = 'プロフィール情報変更'
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
