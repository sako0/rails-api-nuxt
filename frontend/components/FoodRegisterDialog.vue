<template>
  <v-dialog v-model="isDisplay" width="600px">
    <v-card>
      <v-tabs v-model="tab" background-color="transparent" color="basil" grow>
        <v-tabs-slider color="light-blue darken-1"></v-tabs-slider>
        <v-tab v-for="item in items" :key="item">
          {{ item }}
        </v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item v-for="(item, index) in items" :key="item">
          <v-card v-if="index === 0" color="basil" flat>
            <v-card-title>{{ item }}</v-card-title>
            <v-row justify="center">
              <v-col v-if="func === 'web' || fix" cols="11">
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:70"
                  name="商品名"
                >
                  <v-text-field
                    v-model="productName"
                    append-icon="mdi-briefcase"
                    :error-messages="errors"
                    :counter="35"
                    label="商品名"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col v-if="func === 'my' && fix === false" cols="11">
                <v-text-field
                  v-model="productName"
                  append-icon="mdi-briefcase"
                  label="商品名"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col v-if="func === 'web' || fix" cols="11">
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:70"
                  name="個数・単位"
                >
                  <v-text-field
                    v-model="par"
                    append-icon="mdi-beaker"
                    :error-messages="errors"
                    :counter="35"
                    label="個数・単位"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col v-if="func === 'my' && fix === false" cols="11">
                <v-text-field
                  v-model="par"
                  append-icon="mdi-beaker"
                  label="個数・単位"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col
                v-if="func === 'web' || fix"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:35"
                  name="カロリー"
                >
                  <v-text-field
                    v-model.number="calorie"
                    suffix="kcal"
                    append-icon="mdi-food-fork-drink"
                    :error-messages="errors"
                    type="number"
                    label="カロリー"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col
                v-if="func === 'my' && fix === false"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <v-text-field
                  v-model.number="calorie"
                  suffix="kcal"
                  append-icon="mdi-food-fork-drink"
                  type="number"
                  label="カロリー"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="6" sm="6" md="4" lg="4" xl="4">
                <v-text-field
                  :value="number"
                  append-icon="mdi-barcode"
                  disabled
                  label="商品コード"
                ></v-text-field>
              </v-col>
              <v-col cols="1" sm="1" md="4" lg="4" xl="4"> </v-col>
              <v-col
                v-if="func === 'web' || fix"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:35"
                  name="たんぱく質"
                >
                  <v-text-field
                    v-model.number="protein"
                    suffix="g"
                    append-icon="mdi-food-drumstick"
                    :error-messages="errors"
                    type="number"
                    label="たんぱく質"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col
                v-if="func === 'my' && fix === false"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <v-text-field
                  v-model.number="protein"
                  suffix="g"
                  append-icon="mdi-food-drumstick"
                  type="number"
                  label="たんぱく質"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col
                v-if="func === 'web' || fix"
                cols="3"
                sm="3"
                md="3"
                lg="3"
                xl="3"
              >
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:35"
                  name="脂質"
                >
                  <v-text-field
                    v-model.number="lipid"
                    suffix="g"
                    append-icon="mdi-food-steak"
                    :error-messages="errors"
                    type="number"
                    label="脂質"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col
                v-if="func === 'my' && fix === false"
                cols="3"
                sm="3"
                md="3"
                lg="3"
                xl="3"
              >
                <v-text-field
                  v-model.number="lipid"
                  suffix="g"
                  append-icon="mdi-food-steak"
                  type="number"
                  label="脂質"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col
                v-if="func === 'web' || fix"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <validation-provider
                  v-slot="{ errors }"
                  rules="required|max:35"
                  name="炭水化物"
                >
                  <v-text-field
                    v-model.number="carbohydrate"
                    suffix="g"
                    append-icon="mdi-rice"
                    :error-messages="errors"
                    type="number"
                    label="炭水化物"
                  ></v-text-field>
                </validation-provider>
              </v-col>
              <v-col
                v-if="func === 'my' && fix === false"
                cols="4"
                sm="4"
                md="3"
                lg="3"
                xl="3"
              >
                <v-text-field
                  v-model.number="carbohydrate"
                  suffix="g"
                  append-icon="mdi-rice"
                  type="number"
                  label="炭水化物"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="0" sm="0" md="2" lg="2" xl="2"> </v-col>
              <v-col v-if="func === 'web' || fix" cols="4">
                <v-file-input
                  v-model="image"
                  accept="image/jpeg,image/png,image/bmp"
                  placeholder="画像を選択して下さい"
                  @change="Preview_image"
                >
                </v-file-input>
              </v-col>
              <v-col cols="7">
                <v-img :src="url"></v-img>
              </v-col>
            </v-row>

            <v-card-actions>
              <v-row justify="center">
                <v-col cols="6">
                  <v-btn @click="isDisplay = false">Close</v-btn>
                </v-col>
                <v-col cols="6" class="text-right">
                  <v-btn color="blue" @click="nextTab">次へ</v-btn>
                </v-col>
              </v-row>
            </v-card-actions>
          </v-card>
          <v-card v-if="index === 1" color="basil" flat>
            <v-card-title>{{ item }}</v-card-title>
            <v-row justify="center">
              <v-col cols="11" sm="11" md="11" lg="11" xl="11">
                <v-text-field
                  v-model="productName"
                  append-icon="mdi-briefcase"
                  label="商品名"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="11" sm="11" md="11" lg="11" xl="11">
                <v-text-field
                  v-model="par"
                  append-icon="mdi-beaker"
                  label="個数・単位"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                <v-text-field
                  v-model.number="calorie"
                  suffix="kcal"
                  append-icon="mdi-food-fork-drink"
                  type="number"
                  label="カロリー"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="6" sm="6" md="4" lg="4" xl="4">
                <v-text-field
                  :value="number"
                  append-icon="mdi-barcode"
                  disabled
                  label="商品コード"
                ></v-text-field>
              </v-col>
              <v-col cols="1" sm="1" md="4" lg="4" xl="4"> </v-col>
              <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                <v-text-field
                  v-model.number="protein"
                  suffix="g"
                  append-icon="mdi-food-drumstick"
                  type="number"
                  label="たんぱく質"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="3" sm="3" md="3" lg="3" xl="3">
                <v-text-field
                  v-model.number="lipid"
                  suffix="g"
                  append-icon="mdi-food-steak"
                  type="number"
                  label="脂質"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                <v-text-field
                  v-model.number="carbohydrate"
                  suffix="g"
                  append-icon="mdi-rice"
                  type="number"
                  label="炭水化物"
                  disabled
                ></v-text-field>
              </v-col>
              <v-col cols="0" sm="0" md="2" lg="2" xl="2"> </v-col>
            </v-row>

            <v-card-actions>
              <v-row justify="center">
                <v-col cols="6">
                  <v-btn @click="isDisplay = false">Close</v-btn>
                </v-col>
                <v-col cols="6" class="text-right">
                  <v-btn color="red" @click="submit">OK</v-btn>
                </v-col>
              </v-row>
            </v-card-actions>
          </v-card>
        </v-tab-item>
      </v-tabs-items>
    </v-card>
  </v-dialog>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationProvider } from 'vee-validate'

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
export default {
  components: {
    ValidationProvider,
  },
  props: {
    number: String,
  },
  data: () => ({
    isDisplay: false,
    productName: '',
    par: '',
    calorie: null,
    protein: null,
    lipid: null,
    carbohydrate: null,
    func: null,
    tab: 0,
    items: ['商品情報', '登録'],
    url: null,
    image: null,
    image_file: null,
    fix: false,
    post_id: null,
    food_code: null,
  }),
  watch: {
    isDisplay(val) {
      if (val) {
        console.log(this.$props.number)
        this.$axios
          .get('/api/v1/foods/' + this.$props.number)
          .then((response) => {
            if (response.data) {
              if (response.data.web_search) {
                if (response.data.content) {
                  this.productName = response.data.product_name
                  this.par = response.data.par
                  this.calorie = response.data.calorie
                  this.protein = response.data.protein
                  this.lipid = response.data.lipid
                  this.carbohydrate = response.data.carbohydrate
                }
                this.func = 'web'
              } else {
                console.log(response.data)
                this.productName = response.data.data.attributes.product_name
                this.par = response.data.data.attributes.par
                this.calorie = response.data.data.attributes.calorie
                this.protein = response.data.data.attributes.protein
                this.lipid = response.data.data.attributes.lipid
                this.carbohydrate = response.data.data.attributes.carbohydrate
                this.url = response.data.data.attributes.image
                this.post_id = parseInt(response.data.data.id)
                this.post_user_id = response.data.data.attributes.user_id
                this.food_code = response.data.data.attributes.food_code
                if (response.data.data.attributes.func === 'my') {
                  this.func = 'my'
                  this.tab = 1
                }
              }
            } else {
              console.log(response)
            }
          })
      }
    },
  },
  methods: {
    submit() {
      this.isDisplay = false
      this.$emit('method')
      // fixフラグがonの場合のみバーコード情報の登録を行う
      if (this.func === 'web' || this.fix) {
        const url = '/api/v1/food_posts'
        const data = new FormData()
        data.append('food_posts[food_code]', this.$props.number)
        data.append('food_posts[product_name]', this.productName)
        data.append('food_posts[par]', this.par)
        data.append('food_posts[calorie]', this.calorie)
        data.append('food_posts[protein]', this.protein)
        data.append('food_posts[lipid]', this.lipid)
        data.append('food_posts[carbohydrate]', this.carbohydrate)
        if (this.image_file) {
          data.append('food_posts[image]', this.image_file)
        }
        const headers = { 'content-type': 'multipart/form-data' }
        this.$axios.post(url, data, { headers }).then((response) => {
          console.log(response)
        })
      } else {
        this.post_used()
      }
    },
    nextTab() {
      this.tab = 1
    },
    closeDisplay() {
      this.isDisplay = false
    },
    Preview_image(e) {
      if (e !== null) {
        this.image_file = e
        this.url = URL.createObjectURL(this.image)
      } else {
        this.url = ''
      }
    },
    post_used() {
      const url = '/api/v1/foods'
      const headers = { 'content-type': 'application/json' }
      let data = ''
      if (this.func === 'my') {
        data = {
          food_code: this.food_code,
          food_post_id: this.post_id,
          target_user_id: this.post_user_id,
        }
      }
      this.$axios.post(url, data, { headers }).then((response) => {
        console.log(response)
      })
    },
  },
}
</script>
