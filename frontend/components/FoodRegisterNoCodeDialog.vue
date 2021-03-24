<template>
  <div>
    <Dialog ref="dlg" @method="postDelete($event)" />
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
              <v-tab-item
                v-for="(item, index) in items"
                :key="`second-` + index"
              >
                <v-card v-if="index === 0" color="basil" flat>
                  <v-card-title>
                    <v-container>
                      <v-row justify="center">
                        <v-col cols="12" class="text-left"> 商品検索 </v-col>
                      </v-row>
                    </v-container>
                  </v-card-title>
                  <v-card-text>
                    <v-container>
                      <v-row justify="center">
                        <v-col cols="11">
                          <v-autocomplete
                            v-model="model"
                            :items="lists"
                            :loading="isLoading"
                            :search-input.sync="search"
                            :disabled="fixExceptNewFlg"
                            value="aaa"
                            color="green darken-1"
                            clearable
                            clear-icon="mdi-backspace"
                            no-data-text="データが存在しません"
                            hide-selected
                            auto-select-first
                            item-text="Description"
                            item-value="API"
                            label="商品検索"
                            placeholder="商品名を入力..."
                            prepend-icon="mdi-database-search"
                            return-object
                            @update:search-input="copyProductName"
                            @click:clear="searchClear"
                            @change="searchChange"
                          ></v-autocomplete>
                        </v-col>
                      </v-row>
                    </v-container>
                  </v-card-text>
                  <v-card-text> <v-divider></v-divider></v-card-text>
                  <v-card-title>
                    <v-container>
                      <v-row justify="center">
                        <v-col v-if="!model" cols="12" class="text-left">
                          新規作成
                        </v-col>
                        <v-col v-else cols="5" class="text-left">
                          商品情報
                        </v-col>
                        <v-col v-if="model && !fix" cols="7" class="text-right">
                          <v-btn
                            dark
                            color="green darken-1"
                            @click="fix = true"
                          >
                            <v-icon>mdi-pencil</v-icon>
                            編集と削除
                          </v-btn>
                        </v-col>
                        <v-col v-if="model && fix" cols="7" class="text-right">
                          <v-btn
                            dark
                            color="green darken-1"
                            @click="searchChange"
                          >
                            <v-icon>mdi-cancel</v-icon>
                            編集取消
                          </v-btn>
                        </v-col>
                      </v-row>
                    </v-container>
                  </v-card-title>
                  <v-card-text>
                    <v-container>
                      <v-row>
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
                        <v-col v-if="fix" cols="5" sm="5" md="5" lg="5" xl="5">
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
                          v-if="fix === false"
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
                        <v-col v-if="fix" cols="5" sm="5" md="5" lg="5" xl="5">
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
                          v-if="fix === false"
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
                        <v-col v-if="fix" cols="5" sm="5" md="5" lg="5" xl="5">
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
                          v-if="fix === false"
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
                        <v-col v-if="fix" cols="5" sm="5" md="5" lg="5" xl="5">
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
                          v-if="fix === false"
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
                    </v-container>
                  </v-card-text>

                  <v-card-actions>
                    <v-row justify="center">
                      <v-col cols="6">
                        <v-btn @click="closeDisplay">閉じる</v-btn>
                      </v-col>
                      <v-col cols="6" class="text-right">
                        <v-btn
                          v-if="!fix"
                          color="blue"
                          dark
                          elevation="6"
                          @click="nextTab"
                          >次へ</v-btn
                        >
                        <div v-else-if="fixExceptNewFlg">
                          <v-btn
                            dark
                            color="red darken-1"
                            :loading="postLoading"
                            @click="postDeleteDlgUp"
                          >
                            <v-icon>mdi-delete</v-icon>
                            削除
                          </v-btn>
                          <v-btn
                            color="green darken-1"
                            :dark="!invalid"
                            elevation="6"
                            :loading="postLoading"
                            :disabled="invalid"
                            @click="updatePost"
                          >
                            <v-icon>mdi-pencil</v-icon>
                            更新</v-btn
                          >
                        </div>

                        <v-btn
                          v-else
                          color="green darken-1"
                          :dark="!invalid"
                          elevation="6"
                          :disabled="invalid"
                          :loading="postLoading"
                          @click="createPost"
                        >
                          <v-icon>mdi-pencil</v-icon>
                          登録</v-btn
                        >
                      </v-col>
                    </v-row>
                  </v-card-actions>
                </v-card>
                <v-card v-if="index === 1 && !fix" color="basil" flat>
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
                  </v-row>

                  <v-card-actions>
                    <v-row justify="center">
                      <v-col cols="4" class="text-left">
                        <v-btn @click="isDisplay = false">閉じる</v-btn>
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
                          :disabled="invalid"
                          elevation="6"
                          :dark="!invalid"
                          @click="foodEat"
                        >
                          登録
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
  </div>
</template>

<script>
import { required, max, regex } from 'vee-validate/dist/rules'
import { extend, ValidationProvider, ValidationObserver } from 'vee-validate'
import Dialog from '@/components/Dialog'

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
    Dialog,
  },
  props: {
    number: String,
  },
  data: () => ({
    isDisplay: false,
    productName: null,
    par: '',
    calorie: null,
    calorie_total: null,
    protein: null,
    protein_total: null,
    lipid: null,
    lipid_total: null,
    carbohydrate: null,
    carbohydrate_total: null,
    tab: 0,
    fix: true,
    post_id: null,
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
    descriptionLimit: 30,
    entries: [],
    model: null,
    isLoading: false,
    search: null,
    postLoading: false,
  }),
  computed: {
    fields() {
      if (!this.model) return []

      return Object.keys(this.model).map((key) => {
        return {
          key,
          value: this.model[key] || 'n/a',
        }
      })
    },
    lists() {
      return this.entries.map((entry) => {
        const Description =
          entry.attributes.product_name.length > this.descriptionLimit
            ? entry.attributes.product_name.slice(0, this.descriptionLimit) +
              '...'
            : entry.attributes.product_name

        return Object.assign({}, entry.attributes, { Description })
      })
    },
    fixExceptNewFlg() {
      if (this.fix && this.model) return true
      else return false
    },
    items() {
      if (!this.fix) {
        return [
          { title: '商品情報', icon: 'mdi-briefcase-search' },
          { title: '登録', icon: 'mdi-pencil-plus' },
        ]
      } else {
        return [{ title: '商品情報', icon: 'mdi-briefcase-search' }]
      }
    },
  },
  watch: {
    isDisplay(val) {
      if (val) {
        this.calendarDate = this.$moment().format('YYYY-MM-DD')
        this.begin = 100
        this.calorie_total = (this.calorie * this.begin) / 100
        this.protein_total = (this.protein * this.begin) / 100
        this.lipid_total = (this.lipid * this.begin) / 100
        this.carbohydrate_total = (this.carbohydrate * this.begin) / 100
      }
    },
    search(val) {
      // lists have already been loaded
      if (this.lists.length > 0) return

      // lists have already been requested
      if (this.isLoading) return

      this.isLoading = true

      // Lazily load input lists
      this.postListsGet()
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
    nextTab() {
      this.tab = 1
    },
    closeDisplay() {
      this.isDisplay = false
      this.reset()
    },
    searchClear() {
      this.fix = true
      this.post_id = null
      this.productName = null
      this.par = null
      this.calorie = null
      this.protein = null
      this.lipid = null
      this.carbohydrate = null
    },
    searchChange() {
      if (this.model !== null) {
        console.log(this.model)
        this.fix = false
        this.post_id = this.model.post_id
        this.productName = this.model.product_name
        this.par = this.model.par
        this.calorie = this.model.calorie
        this.protein = this.model.protein
        this.lipid = this.model.lipid
        this.carbohydrate = this.model.carbohydrate
      }
    },
    copyProductName() {
      if (this.search) {
        this.productName = this.search
      }
    },
    postListsGet() {
      this.$axios
        .get('api/v1/food_posts')
        .then((response) => {
          this.count = response.data.data.length
          this.entries = response.data.data
        })
        .catch((err) => {
          console.log(err)
        })
        .finally(() => (this.isLoading = false))
    },
    createPost() {
      this.postLoading = true
      const url = '/api/v1/food_posts'
      const headers = { 'content-type': 'application/json' }
      const data = {
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie,
        protein: this.protein,
        lipid: this.lipid,
        carbohydrate: this.carbohydrate,
      }
      this.$axios
        .post(url, data, { headers })
        .then((response) => {
          this.post_id = response.data
          this.postListsGet()
          this.model = {
            Description: this.productName,
            post_id: this.post_id,
            product_name: this.productName,
            par: this.par,
            calorie: this.calorie,
            protein: this.protein,
            lipid: this.lipid,
            carbohydrate: this.carbohydrate,
          }
        })
        .finally((response) => {
          this.fix = false
          this.postLoading = false
          this.tab = 1
        })
    },
    updatePost() {
      this.postLoading = true
      const url = '/api/v1/food_posts'
      const headers = { 'content-type': 'application/json' }
      const data = {
        id: this.post_id,
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie,
        protein: this.protein,
        lipid: this.lipid,
        carbohydrate: this.carbohydrate,
      }
      this.$axios
        .post(url, data, { headers })
        .then((response) => {
          this.post_id = response.data
          this.postListsGet()
          this.model = {
            Description: this.productName,
            post_id: this.post_id,
            product_name: this.productName,
            par: this.par,
            calorie: this.calorie,
            protein: this.protein,
            lipid: this.lipid,
            carbohydrate: this.carbohydrate,
          }
        })
        .finally((response) => {
          this.fix = false
          this.postLoading = false
          this.tab = 1
        })
    },
    postDeleteDlgUp() {
      this.$refs.dlg.type = 'postDelete'
      this.$refs.dlg.id = this.productName
      this.$refs.dlg.isDisplay = true
    },
    postDelete(id) {
      this.postLoading = true
      const url = '/api/v1/food_posts/' + this.post_id
      const headers = { 'content-type': 'application/json' }
      this.$axios
        .delete(url, { headers })
        .then((response) => {
          this.searchClear()
          this.postListsGet()
        })
        .finally((response) => {
          this.model = false
          this.postLoading = false
        })
    },
    foodEat() {
      this.postLoading = true
      const url = '/api/v1/food_eat'
      const headers = { 'content-type': 'application/json' }
      const data = {
        product_name: this.productName,
        par: this.par,
        calorie: this.calorie_total,
        protein: this.protein_total,
        lipid: this.lipid_total,
        carbohydrate: this.carbohydrate_total,
        percent: this.begin,
        date: this.calendarDate,
      }
      this.$axios
        .post(url, data, { headers })
        .then((response) => {})
        .finally((response) => {
          this.postLoading = false
          this.isDisplay = false
          this.reset()
          this.$emit('reGet')
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
