<template>
  <v-dialog v-model="isDisplay" width="600px">
    <validation-observer ref="observer" v-slot="{ invalid }">
      <form>
        <v-card>
          <v-tabs
            v-model="tab"
            background-color="transparent"
            color="basil"
            grow
          >
            <v-tabs-slider color="transparent"></v-tabs-slider>
            <v-tab v-for="item in items" :key="item"> </v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item v-for="item in items" :key="item">
              <v-card-title>{{ title }}</v-card-title>
              <v-row>
                <v-col
                  cols="12"
                  sm="12"
                  md="5"
                  lg="5"
                  xl="5"
                  class="text-center"
                >
                  <v-card-text>
                    <profilePreview
                      :user="user"
                      :preview-flg="true"
                      @backgroundFileGet="backgroundFileGet"
                      @imageFileGet="imageFileGet"
                    />
                  </v-card-text>
                </v-col>
                <v-col cols="12" sm="12" md="6" lg="6" xl="6">
                  <v-row justify="center">
                    <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="名前"
                        rules="required|max:35"
                      >
                        <v-text-field
                          v-model="name"
                          append-icon="mdi-account-edit"
                          :counter="35"
                          :error-messages="errors"
                          label="名前"
                          required
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                      <v-select
                        v-model="sex"
                        :items="sex_items"
                        label="性別"
                      ></v-select>
                    </v-col>
                    <v-col cols="11" sm="12" md="12" lg="12" xl="12">
                      <validation-provider
                        v-slot="{ errors }"
                        name="email"
                        rules="email"
                      >
                        <v-text-field
                          :value="user.user.email"
                          append-icon="mdi-at"
                          disabled
                          :error-messages="errors"
                          label="E-mail"
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="年齢"
                        rules="required|numeric|max:3"
                      >
                        <v-text-field
                          v-model.number="age"
                          append-icon="mdi-domain"
                          z
                          :error-messages="errors"
                          label="年齢"
                          required
                          type="number"
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="11" sm="12" md="6" lg="6" xl="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="身長"
                        rules="required|numeric|max:3|min:2"
                      >
                        <v-text-field
                          v-model.number="height"
                          append-icon="mdi-file-find-outline"
                          :error-messages="errors"
                          label="身長"
                          required
                          type="number"
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="目標体重"
                        rules="required|numeric|max:3|min:2"
                      >
                        <v-text-field
                          v-model="target_weight"
                          append-icon="mdi-head-dots-horizontal-outline"
                          :error-messages="errors"
                          label="目標体重"
                          required
                          type="number"
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="11" sm="11" md="6" lg="6" xl="6">
                      <v-select
                        v-model="action_level"
                        :items="action_level_items"
                        item-text="text"
                        item-value="value"
                        label="活動レベル"
                      ></v-select>
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
                          label="自己紹介"
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
                      :disabled="invalid"
                      color="orange darken-3"
                      @click="submit"
                    >
                      更新
                    </v-btn>
                  </v-col>
                </v-row>
              </v-card-actions>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </form>
    </validation-observer>
  </v-dialog>
</template>

<script>
import {
  required,
  digits,
  email,
  numeric,
  max,
  min,
  regex,
} from 'vee-validate/dist/rules'
import {
  extend,
  ValidationObserver,
  ValidationProvider,
  setInteractionMode,
} from 'vee-validate'
import ProfilePreview from './ProfilePreview'

setInteractionMode('eager')

extend('digits', {
  ...digits,
  message: '{_field_} needs to be {length} digits. ({_value_})',
})

extend('required', {
  ...required,
  message: '{_field_} は必ず入力して下さい',
})
extend('numeric', {
  ...numeric,
  message: '{_field_} は数字で入力して下さい',
})

extend('max', {
  ...max,
  message: '{_field_} は {length} 文字以内で入力して下さい',
})

extend('min', {
  ...min,
  message: '{_field_} は {length} 文字以上で入力して下さい',
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
    ProfilePreview,
    ValidationProvider,
    ValidationObserver,
  },
  props: {
    // Object形に変換
    user: Object,
  },
  data() {
    return {
      isDisplay: false,
      title: '',
      uploadImage: '',
      uploadBackground: '',
      name: this.user.user.name,
      age: this.user.user.profile.age,
      sex: this.user.user.profile.sex,
      sex_items: [
        { text: '男性', value: true },
        { text: '女性', value: false },
      ],
      height: this.user.user.profile.height,
      target_weight: this.user.user.profile.target_weight,
      action_level: this.user.user.profile.action_level,
      action_level_items: [1.25, 1.5, 1.75, 2.0],
      notes: this.user.user.profile.notes,
      tab: 0,
      items: [''],
    }
  },
  computed: {
    userComputed: {
      get() {
        return this.$props.user
      },
      set(value) {
        this.$emit('change', value)
      },
    },
  },
  mounted() {
    this.title = 'プロフィール情報変更'
  },
  methods: {
    submit() {
      this.isDisplay = false
      const url = '/api/v1/users/' + this.user.user.id
      const data = new FormData()
      if (this.uploadImage) {
        data.append('user[image]', this.uploadImage)
      }
      if (this.uploadBackground) {
        data.append('user[background]', this.uploadBackground)
      }
      data.append('user[name]', this.name)
      data.append(
        'user[profiles_attributes][age]',
        this.age === null ? '' : this.age
      )
      data.append(
        'user[profiles_attributes][sex]',
        this.sex === null ? '' : this.sex
      )
      data.append(
        'user[profiles_attributes][height]',
        this.height === null ? '' : this.height
      )
      data.append(
        'user[profiles_attributes][target_weight]',
        this.target_weight === null ? '' : this.target_weight
      )
      data.append(
        'user[profiles_attributes][action_level]',
        this.action_level === null ? '' : this.action_level
      )
      data.append(
        'user[profiles_attributes][notes]',
        this.notes === null ? '' : this.notes
      )
      const headers = { 'content-type': 'multipart/form-data' }
      this.$axios.put(url, data, { headers }).then((response) => {
        this.getUser()
      })
    },
    imageFileGet(value) {
      if (value) {
        this.uploadImage = value
      } else {
        this.uploadImage = ''
      }
    },
    backgroundFileGet(value) {
      if (value) {
        this.uploadBackground = value
      } else {
        this.uploadBackground = ''
      }
    },
    getUser() {
      this.$emit('getUser')
    },
  },
}
</script>
