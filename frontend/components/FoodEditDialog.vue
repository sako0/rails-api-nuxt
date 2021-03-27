<template>
  <div>
    <FoodRegisterListDialog
      ref="listDlg"
      :lists="lists"
      @selectedItem="selectedItem($event)"
    />
    <v-dialog v-model="isDisplay" v-scroll-lock width="600px">
      <v-card style="overflow-y: hidden">
        <v-tabs
          v-model="tab"
          fixed-tabs
          background-color="green darken-1"
          dark
          icons-and-text
        >
          <v-tabs-slider color="cyan accent-2"></v-tabs-slider>
          <v-tab v-for="(item, index) in items" :key="`first-` + index">
            <div v-text="item.title"></div>
            <v-icon>{{ item.icon }}</v-icon>
          </v-tab>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item v-for="(item, index) in items" :key="`second-` + index">
            <validation-observer ref="observer" v-slot="{ invalid }">
              <form>
                <div v-if="item.title === '商品情報'">
                  <v-card-title>商品情報</v-card-title>

                  <v-row justify="center">
                    <v-col cols="6" class="text-center">
                      <v-btn
                        v-if="sameUserFlg && !fix"
                        dark
                        color="green darken-1"
                        @click="fix = true"
                      >
                        <v-icon>mdi-pencil</v-icon>
                        編集
                      </v-btn>
                      <v-btn
                        v-if="sameUserFlg && fix"
                        dark
                        color="green darken-1"
                        @click="editCancel"
                      >
                        <v-icon>mdi-cancel</v-icon>
                        編集取消
                      </v-btn>
                    </v-col>
                    <v-col cols="6" class="text-center">
                      <v-btn
                        v-if="number"
                        dark
                        color="green darken-1"
                        @click="codeSearch"
                      >
                        <v-icon>mdi-magnify</v-icon>
                        検索
                      </v-btn>
                    </v-col>
                  </v-row>
                  <v-row justify="center">
                    <v-col v-if="fix" cols="11">
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
                    <v-col v-if="fix === false" cols="11">
                      <v-text-field
                        v-model="productName"
                        append-icon="mdi-briefcase"
                        label="商品名"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="fix" cols="11">
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
                    <v-col v-if="fix === false" cols="11">
                      <v-text-field
                        v-model="par"
                        append-icon="mdi-beaker"
                        label="個数・単位"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col
                      v-if="number"
                      cols="11"
                      sm="11"
                      md="11"
                      lg="11"
                      xl="11"
                    >
                      <v-text-field
                        :value="number"
                        append-icon="mdi-barcode"
                        disabled
                        label="商品コード"
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="fix" cols="6">
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
                    <v-col v-if="fix === false" cols="6">
                      <v-text-field
                        v-model.number="calorie"
                        suffix="kcal"
                        append-icon="mdi-food-fork-drink"
                        type="number"
                        label="カロリー"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="fix" cols="5">
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
                    <v-col v-if="fix === false" cols="5">
                      <v-text-field
                        v-model.number="protein"
                        suffix="g"
                        append-icon="mdi-food-drumstick"
                        type="number"
                        label="たんぱく質"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="fix" cols="6">
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
                    <v-col v-if="fix === false" cols="6">
                      <v-text-field
                        v-model.number="lipid"
                        suffix="g"
                        append-icon="mdi-food-steak"
                        type="number"
                        label="脂質"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="fix" cols="5">
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
                    <v-col v-if="fix === false" cols="5">
                      <v-text-field
                        v-model.number="carbohydrate"
                        suffix="g"
                        append-icon="mdi-rice"
                        type="number"
                        label="炭水化物"
                        disabled
                      ></v-text-field>
                    </v-col>
                  </v-row>

                  <v-card-actions>
                    <v-row justify="center">
                      <v-col cols="6">
                        <v-btn @click="isDisplay = false">閉じる</v-btn>
                      </v-col>
                      <v-col cols="6" class="text-right">
                        <v-btn color="blue" dark elevation="6" @click="tab = 1"
                          >次へ</v-btn
                        >
                      </v-col>
                    </v-row>
                  </v-card-actions>
                </div>
                <div v-if="item.title === '編集'">
                  <v-card-title>編集</v-card-title>
                  <v-row justify="center">
                    <v-col cols="11">
                      <v-text-field
                        v-model="productName"
                        append-icon="mdi-briefcase"
                        label="商品名"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col cols="11">
                      <v-text-field
                        v-model="par"
                        append-icon="mdi-beaker"
                        label="個数・単位"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col v-if="number" cols="11">
                      <v-text-field
                        :value="number"
                        append-icon="mdi-barcode"
                        disabled
                        label="商品コード"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="6">
                      <v-text-field
                        v-model.number="calorie_total"
                        suffix="kcal"
                        append-icon="mdi-food-fork-drink"
                        type="number"
                        label="カロリー"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col cols="5">
                      <v-text-field
                        v-model.number="protein_total"
                        suffix="g"
                        append-icon="mdi-food-drumstick"
                        type="number"
                        label="たんぱく質"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col cols="5">
                      <v-text-field
                        v-model.number="lipid_total"
                        suffix="g"
                        append-icon="mdi-food-steak"
                        type="number"
                        label="脂質"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col cols="6">
                      <v-text-field
                        v-model.number="carbohydrate_total"
                        suffix="g"
                        append-icon="mdi-rice"
                        type="number"
                        label="炭水化物"
                        disabled
                      ></v-text-field>
                    </v-col>
                    <v-col cols="8">
                      <v-dialog
                        ref="dateDlg"
                        v-model="datePicker"
                        :return-value.sync="calendarDate"
                        width="290px"
                      >
                        <template #activator="{ on, attrs }">
                          <v-text-field
                            v-model="calendarDate"
                            label="日付"
                            prepend-icon="mdi-calendar"
                            required
                            readonly
                            v-bind="attrs"
                            v-on="on"
                          ></v-text-field>
                        </template>
                        <v-date-picker
                          v-model="calendarDate"
                          locale="jp-ja"
                          :day-format="(date) => new Date(date).getDate()"
                          color="light-blue darken-1"
                          :allowed-dates="allowedDate"
                          @change="$refs.dateDlg.save(calendarDate)"
                        >
                          <v-spacer></v-spacer>
                        </v-date-picker>
                      </v-dialog>
                    </v-col>
                  </v-row>
                  <v-card-actions>
                    <v-row justify="center">
                      <v-col cols="3" class="text-center">
                        <v-btn @click="isDisplay = false">閉じる</v-btn>
                      </v-col>
                      <v-col cols="5" class="text-center">
                        <v-select
                          v-model="begin"
                          :items="percent"
                          menu-props="auto"
                          label="Select"
                          hide-details
                          suffix="％"
                          append-icon="mdi-format-list-bulleted-triangle"
                          single-line
                        ></v-select>
                      </v-col>
                      <v-col cols="3" class="text-center">
                        <v-btn
                          color="green darken-1"
                          :dark="!invalid"
                          :disabled="invalid"
                          @click="submit"
                        >
                          更新
                        </v-btn>
                      </v-col>
                    </v-row>
                  </v-card-actions>
                </div>
              </form>
            </validation-observer>
          </v-tab-item>
        </v-tabs-items>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationProvider, ValidationObserver } from 'vee-validate'
import FoodRegisterListDialog from '@/components/FoodRegisterListDialog'

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
    ValidationObserver,
    ValidationProvider,
    FoodRegisterListDialog,
  },
  props: {
    foodInfo: Object,
  },
  data: () => ({
    isDisplay: false,
    productName: null,
    number: null,
    par: null,
    calorie: null,
    calorie_total: null,
    protein: null,
    protein_total: null,
    lipid: null,
    lipid_total: null,
    carbohydrate: null,
    carbohydrate_total: null,
    func: null,
    url: null,
    image: null,
    image_file: null,
    fix: false,
    post_id: null,
    food_code: null,
    tab: 0,
    items: [
      { title: '商品情報', icon: 'mdi-briefcase-search' },
      { title: '編集', icon: 'mdi-pencil-plus' },
    ],
    percent: [
      { text: 25 },
      { text: 50 },
      { text: 100 },
      { text: 150 },
      { text: 200 },
      { text: 300 },
      { text: 400 },
      { text: 500 },
      { text: 600 },
      { text: 700 },
      { text: 800 },
      { text: 900 },
      { text: 1000 },
    ],
    begin: null,
    percent_base: null,
    strDate: null,
    datePicker: false,
    lists: null,
    currentUserId: null,
    post_user_id: null,
    selectedFlg: false,
  }),
  computed: {
    calendarDate: {
      set(val) {
        this.strDate = this.$moment(val).format('YYYY-MM-DD')
      },
      get() {
        const date = Date.parse(this.strDate)
        return this.$moment(date).format('YYYY-MM-DD')
      },
    },
    sameUserFlg() {
      if (this.post_user_id !== null) {
        if (this.post_user_id === this.currentUserId) {
          return true
        } else {
          return false
        }
      } else {
        return false
      }
    },
    postChangeFlg() {
      if (this.selectedFlg || this.fix) {
        return true
      } else {
        return false
      }
    },
  },
  watch: {
    isDisplay(val) {
      if (val) {
        this.getUser()
        this.productName = this.$props.foodInfo.product_name
        this.number = this.$props.foodInfo.food_code
        this.par = this.$props.foodInfo.par
        this.percent_base = 100
        this.begin = this.$props.foodInfo.percent
        this.calorie =
          (this.$props.foodInfo.calorie / this.begin) * this.percent_base
        this.protein =
          (this.$props.foodInfo.protein / this.begin) * this.percent_base
        this.lipid =
          (this.$props.foodInfo.lipid / this.begin) * this.percent_base
        this.carbohydrate =
          (this.$props.foodInfo.carbohydrate / this.begin) * this.percent_base
        this.strDate = this.$props.foodInfo.date
        this.post_id = this.$props.foodInfo.post_id
        this.post_user_id = this.$props.foodInfo.post_user_id
        console.log(this.post_id)
      }
    },
    calorie(val) {
      this.calorie_total = (val * this.begin) / this.percent_base
    },
    protein(val) {
      this.protein_total = (val * this.begin) / this.percent_base
    },
    lipid(val) {
      this.lipid_total = (val * this.begin) / this.percent_base
    },
    carbohydrate(val) {
      this.carbohydrate_total = (val * this.begin) / this.percent_base
    },
    begin(val) {
      this.calorie_total = (this.calorie * val) / this.percent_base
      this.protein_total = (this.protein * val) / this.percent_base
      this.lipid_total = (this.lipid * val) / this.percent_base
      this.carbohydrate_total = (this.carbohydrate * val) / this.percent_base
    },
  },
  methods: {
    submit() {
      // this.isDisplay = false
      if (this.postChangeFlg) {
        if (this.sameUserFlg) {
          this.foodPost()
        } else if (this.number) {
          this.post_used()
        } else {
          this.foodPost()
        }
      } else {
        this.foodEat()
      }
    },
    allowedDate(val) {
      return (
        this.$moment(val).format('YYYY-MM-DD') <=
        this.$moment().add(9, 'days').format('YYYY-MM-DD')
      )
    },
    codeSearch() {
      this.fix = false
      this.$refs.listDlg.reset()
      this.$refs.listDlg.codeListOverlay = true
      this.$refs.listDlg.isDisplay = true
      const url = '/api/v1/get_list_by_code/' + this.number
      this.$axios
        .get(url)
        .then((response) => {
          this.lists = response.data.data
        })
        .finally((response) => {
          setTimeout(() => {
            this.$refs.listDlg.codeListOverlay = false
          }, 100)
        })
    },
    selectedItem(attributes) {
      const item = attributes.attributes
      console.log(item)
      this.selectedFlg = true
      this.post_user_id = item.post_user_id
      this.post_id = item.post_id
      this.productName = item.product_name
      this.number = item.food_code
      this.par = item.par
      this.calorie = item.calorie
      this.protein = item.protein
      this.lipid = item.lipid
      this.carbohydrate = item.carbohydrate
      this.calorie_total = (this.calorie * this.begin) / this.percent_base
      this.protein_total = (this.protein * this.begin) / this.percent_base
      this.lipid_total = (this.lipid * this.begin) / this.percent_base
      this.carbohydrate_total =
        (this.carbohydrate * this.begin) / this.percent_base
    },
    post_used() {
      const url = '/api/v1/foods'
      const headers = { 'content-type': 'application/json' }
      const data = {
        func: 'used',
        food_code: this.number,
        food_post_id: this.post_id,
      }
      this.$axios.post(url, data, { headers }).then((response) => {
        this.foodEat()
      })
    },
    foodEat() {
      console.log(this.productName)
      const url = '/api/v1/food_eat/' + this.$props.foodInfo.eat_id
      const headers = { 'content-type': 'application/json' }
      const data = {
        id: this.$props.foodInfo.eat_id,
        food_code: this.number,
        post_id: this.post_id,
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie_total,
        protein: this.protein_total,
        lipid: this.lipid_total,
        carbohydrate: this.carbohydrate_total,
        percent: this.begin,
        date: this.strDate,
      }
      this.$axios.put(url, data, { headers }).then((response) => {
        console.log(response)
        this.isDisplay = false
        setTimeout(() => {
          this.$emit('eatEdit')
        }, 200)
      })
    },
    getUser() {
      this.$axios.get('api/v1/sessions').then((response) => {
        this.currentUserId = response.data.user.id
      })
    },
    editCancel() {
      this.productName = this.$props.foodInfo.product_name
      this.number = this.$props.foodInfo.food_code
      this.par = this.$props.foodInfo.par
      this.calorie = this.$props.foodInfo.calorie
      this.protein = this.$props.foodInfo.protein
      this.lipid = this.$props.foodInfo.lipid
      this.carbohydrate = this.$props.foodInfo.carbohydrate
      this.percent_base = this.$props.foodInfo.percent
      this.begin = this.$props.foodInfo.percent
      this.strDate = this.$props.foodInfo.date
      this.fix = false
    },
    foodPost() {
      const url = '/api/v1/food_posts'
      let data = ''
      if (this.post_id) {
        data = {
          id: this.post_id,
          food_code: this.number,
          product_name: this.productName,
          par: this.par,
          calorie: this.calorie,
          protein: this.protein,
          lipid: this.lipid,
          carbohydrate: this.carbohydrate,
        }
      } else {
        data = {
          food_code: this.number,
          product_name: this.productName,
          par: this.par,
          calorie: this.calorie,
          protein: this.protein,
          lipid: this.lipid,
          carbohydrate: this.carbohydrate,
        }
      }
      const headers = { 'content-type': 'application/json' }
      this.$axios.post(url, data, { headers }).then((response) => {
        this.post_id = response.data
        console.log(response)
        if (this.number) {
          this.post_used()
        } else {
          this.foodEat()
        }
      })
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
<style>
.v-date-picker-table.v-date-picker-table--date
  > table
  > tbody
  tr
  td:nth-child(7)
  .v-btn__content {
  color: blue;
}
.v-date-picker-table.v-date-picker-table--date
  > table
  > tbody
  tr
  td:nth-child(1)
  .v-btn__content {
  color: red;
}
</style>
