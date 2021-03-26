<template>
  <v-dialog v-model="isDisplay" width="600px">
    <validation-observer ref="observer" v-slot="{ invalid }">
      <form>
        <v-card style="overflow-y: hidden">
          <v-card-title>{{ title }}</v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col
                  cols="12"
                  sm="12"
                  md="7"
                  lg="7"
                  xl="7"
                  class="text-center"
                >
                  <v-card-text>
                    <v-container>
                      <profilePreview
                        :user="user"
                        :preview-flg="true"
                        @backgroundFileGet="backgroundFileGet"
                        @imageFileGet="imageFileGet"
                      />
                    </v-container>
                  </v-card-text>
                </v-col>
                <v-col cols="12" sm="12" md="5" lg="5" xl="5">
                  <v-row justify="center">
                    <v-col cols="12" sm="12" md="12" lg="12" xl="12">
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
                    <v-col cols="6" sm="6" md="12" lg="12" xl="12">
                      <v-select
                        v-model="sex"
                        :items="sex_items"
                        item-text="text"
                        item-value="value"
                        label="性別"
                      ></v-select>
                    </v-col>
                    <v-col cols="6" sm="6" md="6" lg="6" xl="6">
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
                    <v-col cols="6" sm="6" md="6" lg="6" xl="6">
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
                    <v-col cols="6" sm="6" md="6" lg="6" xl="6">
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
                    <v-col cols="12" sm="12" md="6" lg="6" xl="6">
                      <v-select
                        v-model="action_level"
                        :items="action_level_items"
                        item-text="text"
                        item-value="value"
                        label="活動レベル"
                      ></v-select>
                    </v-col>
                    <v-col cols="12" sm="12" md="12" lg="12" xl="12">
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
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-container>
              <v-row justify="center">
                <v-col cols="6">
                  <v-btn @click="isDisplay = false">Close</v-btn>
                </v-col>
                <v-col cols="6" class="text-right">
                  <v-btn
                    class="mr-4"
                    :disabled="invalid"
                    dark
                    color="green darken-1"
                    @click="submit"
                  >
                    更新
                  </v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-card-actions>
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
      uploadImage: null,
      uploadBackground: null,
      name: this.user.name,
      age: this.user.profile.age,
      sex: this.user.profile.sex,
      sex_items: [
        { text: '男性', value: false },
        { text: '女性', value: true },
      ],
      height: this.user.profile.height,
      target_weight: this.user.profile.target_weight,
      action_level: this.user.profile.action_level,
      action_level_items: [
        { text: '低い', value: 1.5 },
        { text: '普通', value: 1.75 },
        { text: '高い', value: 2 },
      ],
      notes: this.user.profile.notes,
    }
  },
  mounted() {
    this.title = 'プロフィール情報変更'
  },
  methods: {
    submit() {
      this.isDisplay = false
      const url = '/api/v1/users/' + this.user.id
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
        this.uploadImage = null
      }
    },
    backgroundFileGet(value) {
      if (value) {
        this.uploadBackground = value
      } else {
        this.uploadBackground = null
      }
    },
    getUser() {
      this.$emit('getUser')
    },
  },
}
</script>
