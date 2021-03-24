<template>
  <v-dialog v-model="isDisplay" width="600px">
    <validation-observer ref="observer" v-slot="{ invalid }">
      <form>
        <v-card>
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
              <v-card v-if="index === 0" color="basil" flat>
                <v-card-title>{{ item.title }}</v-card-title>
                <v-row justify="center">
                  <v-col cols="4" class="text-center">
                    <v-btn
                      v-if="func !== 'web' && fix === false"
                      dark
                      color="green darken-1"
                      @click="manualFix"
                    >
                      <v-icon>mdi-pencil</v-icon>
                      手動入力
                    </v-btn>
                  </v-col>
                  <v-col cols="4" class="text-center">
                    <v-btn dark color="green darken-1" @click="reScan">
                      <v-icon>mdi-barcode-scan</v-icon>
                      バーコード再読込
                    </v-btn>
                  </v-col>
                  <v-col cols="4" class="text-center">
                    <v-btn
                      v-if="func !== 'web'"
                      dark
                      color="green darken-1"
                      @click="codeSearch"
                    >
                      <v-icon>mdi-magnify</v-icon>
                      検索
                    </v-btn>
                  </v-col>
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
                  <v-col v-if="func !== 'web' && fix === false" cols="11">
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
                  <v-col v-if="func !== 'web' && fix === false" cols="11">
                    <v-text-field
                      v-model="par"
                      append-icon="mdi-beaker"
                      label="個数・単位"
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col cols="11" sm="11" md="11" lg="11" xl="11">
                    <v-text-field
                      :value="number"
                      append-icon="mdi-barcode"
                      disabled
                      label="商品コード"
                    ></v-text-field>
                  </v-col>
                  <v-col
                    v-if="func === 'web' || fix"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                    v-if="func !== 'web' && fix === false"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                  <v-col
                    v-if="func === 'web' || fix"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                    v-if="func !== 'web' && fix === false"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                  <v-col cols="1"></v-col>
                  <v-col
                    v-if="func === 'web' || fix"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                    v-if="func !== 'web' && fix === false"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                    v-if="func !== 'web' && fix === false"
                    cols="5"
                    sm="5"
                    md="5"
                    lg="5"
                    xl="5"
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
                  <v-col cols="1"> </v-col>
                </v-row>

                <v-card-actions>
                  <v-row justify="center">
                    <v-col cols="6">
                      <v-btn @click="closeDisplay">Close</v-btn>
                    </v-col>
                    <v-col cols="6" class="text-right">
                      <v-btn color="blue" dark elevation="6" @click="nextTab"
                        >次へ</v-btn
                      >
                    </v-col>
                  </v-row>
                </v-card-actions>
              </v-card>
              <v-card v-if="index === 1" color="basil" flat>
                <v-card-title>{{ item.title }}</v-card-title>
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
                  <v-col cols="5" sm="5" md="5" lg="5" xl="5">
                    <v-text-field
                      :value="number"
                      append-icon="mdi-barcode"
                      disabled
                      label="商品コード"
                    ></v-text-field>
                  </v-col>
                  <v-col cols="6" sm="6" md="6" lg="6" xl="6">
                    <v-menu
                      v-model="dateMenu"
                      :close-on-content-click="false"
                      :nudge-right="40"
                      transition="scale-transition"
                      offset-y
                      min-width="auto"
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
                        @input="dateMenu = false"
                      ></v-date-picker>
                    </v-menu>
                  </v-col>
                  <v-col cols="5" sm="5" md="5" lg="5" xl="5">
                    <v-text-field
                      v-model.number="calorie_total"
                      suffix="kcal"
                      append-icon="mdi-food-fork-drink"
                      type="number"
                      label="カロリー"
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col cols="5" sm="5" md="5" lg="5" xl="5">
                    <v-text-field
                      v-model.number="protein_total"
                      suffix="g"
                      append-icon="mdi-food-drumstick"
                      type="number"
                      label="たんぱく質"
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col cols="1"> </v-col>
                  <v-col cols="5" sm="5" md="5" lg="5" xl="5">
                    <v-text-field
                      v-model.number="lipid_total"
                      suffix="g"
                      append-icon="mdi-food-steak"
                      type="number"
                      label="脂質"
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col cols="5" sm="5" md="5" lg="5" xl="5">
                    <v-text-field
                      v-model.number="carbohydrate_total"
                      suffix="g"
                      append-icon="mdi-rice"
                      type="number"
                      label="炭水化物"
                      disabled
                    ></v-text-field>
                  </v-col>
                  <v-col cols="1"> </v-col>
                </v-row>

                <v-card-actions>
                  <v-row justify="center">
                    <v-col cols="4" class="text-left">
                      <v-btn @click="isDisplay = false">Close</v-btn>
                    </v-col>
                    <v-col cols="4" class="text-left">
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
                    <v-col cols="3" class="text-right">
                      <v-btn
                        color="green darken-1"
                        :dark="!invalid"
                        :disabled="invalid"
                        elevation="6"
                        @click="submit"
                      >
                        OK
                      </v-btn>
                    </v-col>
                  </v-row>
                </v-card-actions>
              </v-card>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </form>
    </validation-observer>
  </v-dialog>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationProvider, ValidationObserver } from 'vee-validate'

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
  },
  props: {
    number: String,
  },
  data: () => ({
    isDisplay: false,
    productName: '',
    par: '',
    calorie: null,
    calorie_total: null,
    protein: null,
    protein_total: null,
    lipid: null,
    lipid_total: null,
    carbohydrate: null,
    carbohydrate_total: null,
    func: null,
    tab: 0,
    items: [
      { title: '商品情報', icon: 'mdi-briefcase-search' },
      { title: '登録', icon: 'mdi-pencil-plus' },
    ],
    fix: false,
    post_id: null,
    food_code: null,
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
    begin: 100,
    calendarDate: null,
    dateMenu: false,
  }),
  watch: {
    isDisplay(val) {
      if (val) {
        this.begin = 100
        this.calorie_total = (this.calorie * this.begin) / 100
        this.protein_total = (this.protein * this.begin) / 100
        this.lipid_total = (this.lipid * this.begin) / 100
        this.carbohydrate_total = (this.carbohydrate * this.begin) / 100
      }
    },
    calorie(val) {
      this.calorie_total = (val * this.begin) / 100
    },
    protein(val) {
      this.protein_total = (val * this.begin) / 100
    },
    lipid(val) {
      this.lipid_total = (val * this.begin) / 100
    },
    carbohydrate(val) {
      this.carbohydrate_total = (val * this.begin) / 100
    },
    begin(val) {
      this.calorie_total = (this.calorie * val) / 100
      this.protein_total = (this.protein * val) / 100
      this.lipid_total = (this.lipid * val) / 100
      this.carbohydrate_total = (this.carbohydrate * val) / 100
    },
  },
  created() {
    this.begin = 100
    this.calorie_total = (this.calorie * this.begin) / 100
    this.protein_total = (this.protein * this.begin) / 100
    this.lipid_total = (this.lipid * this.begin) / 100
    this.carbohydrate_total = (this.carbohydrate * this.begin) / 100
  },
  methods: {
    async submit() {
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
        const headers = { 'content-type': 'multipart/form-data' }
        await this.$axios.post(url, data, { headers }).then((response) => {
          this.post_id = response.data
        })
        await this.food_eat()
        await this.post_used()
        this.$emit('reGet')
      } else {
        await this.food_eat()
        await this.post_used()
        this.$emit('reGet')
      }
      this.reset()
    },
    nextTab() {
      this.tab = 1
    },
    closeDisplay() {
      this.isDisplay = false
      this.reset()
    },
    async post_used() {
      const url = '/api/v1/foods'
      const headers = { 'content-type': 'application/json' }
      let data = ''
      if (this.func === 'my' || this.func === 'web') {
        data = {
          func: 'my',
          food_code: this.$props.number,
          food_post_id: this.post_id,
        }
      } else if (this.func === 'used') {
        data = {
          func: 'used',
          food_code: this.$props.number,
          food_post_id: this.post_id,
        }
      }
      await this.$axios.post(url, data, { headers }).then((response) => {})
    },
    async food_eat() {
      const url = '/api/v1/food_eat'
      const headers = { 'content-type': 'application/json' }
      const data = {
        food_code: this.$props.number,
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie_total,
        protein: this.protein_total,
        lipid: this.lipid_total,
        carbohydrate: this.carbohydrate_total,
        percent: this.begin,
        date: this.calendarDate,
      }
      await this.$axios.post(url, data, { headers }).then((response) => {})
    },
    codeSearch() {
      this.isDisplay = false
      this.$emit('codeSearch', this.$props.number)
    },
    manualFix() {
      this.fix = true
      this.func = 'my'
    },
    reScan() {
      this.isDisplay = false
      this.reset()
      setTimeout(() => {
        this.$emit('reScan')
      }, 200)
      this.reset()
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
