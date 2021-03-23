<template>
  <v-dialog v-model="isDisplay" width="600px">
    <v-card>
      <v-card-title>編集</v-card-title>
      <validation-observer ref="observer" v-slot="{ invalid }">
        <form>
          <v-card-text>
            <v-container>
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
            </v-container>
          </v-card-text>

          <v-card-actions>
            <v-container>
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
                    dark
                    :disabled="invalid"
                    @click="submit"
                  >
                    OK
                  </v-btn>
                </v-col>
              </v-row>
            </v-container>
          </v-card-actions>
        </form>
      </validation-observer>
    </v-card>
  </v-dialog>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationObserver } from 'vee-validate'

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
    calendarDate: null,
    dateMenu: false,
  }),
  watch: {
    isDisplay(val) {
      if (val) {
        this.productName = this.$props.foodInfo.attributes.product_name
        this.number = this.$props.foodInfo.attributes.food_code
        this.par = this.$props.foodInfo.attributes.par
        this.calorie = this.$props.foodInfo.attributes.calorie
        this.protein = this.$props.foodInfo.attributes.protein
        this.lipid = this.$props.foodInfo.attributes.lipid
        this.carbohydrate = this.$props.foodInfo.attributes.carbohydrate
        this.percent_base = this.$props.foodInfo.attributes.percent
        this.begin = this.$props.foodInfo.attributes.percent
        this.calendarDate = this.$props.foodInfo.attributes.date
        this.calorie_total = (this.calorie * this.begin) / this.percent_base
        this.protein_total = (this.protein * this.begin) / this.percent_base
        this.lipid_total = (this.lipid * this.begin) / this.percent_base
        this.carbohydrate_total =
          (this.carbohydrate * this.begin) / this.percent_base
      }
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
      const url = '/api/v1/food_eat/' + this.$props.foodInfo.id
      const headers = { 'content-type': 'application/json' }
      const data = {
        id: this.$props.foodInfo.id,
        food_code: this.number,
        food_post_id: this.post_id,
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie_total,
        protein: this.protein_total,
        lipid: this.lipid_total,
        carbohydrate: this.carbohydrate_total,
        percent: this.begin,
        date: this.calendarDate,
      }
      this.$axios.put(url, data, { headers }).then((response) => {
        console.log(response)
        this.isDisplay = false
        this.$emit('eatEdit')
        this.reset()
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
