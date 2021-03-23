<template>
  <div>
    <cameraDialog ref="cameraDlg" @code="code" />
    <Dialog
      ref="dialog"
      @code_exist="cameraUp"
      @no_code="dlgUp"
      @eatDelete="eatDelete($event)"
    />
    <FoodRegisterDialog
      ref="dlg"
      :number="num"
      @reGet="getFoodInfo"
      @codeSearch="codeSearch($event)"
      @reScan="cameraUp"
    />
    <FoodEditDialog ref="editDlg" :food-info="editData" @eatEdit="eatEdit" />
    <FoodRegisterListDialog
      ref="listDlg"
      :lists="lists"
      @selectedItem="selectedItem($event)"
    />
    <v-row>
      <v-col class="center">
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
            <v-row v-if="index === 0">
              <v-col cols="12" class="mt-5">
                <v-card>
                  <v-card-title>栄養分摂取量を登録する</v-card-title>
                  <v-row>
                    <v-col cols="2">
                      <v-btn
                        class="mx-2"
                        fab
                        dark
                        color="green darken-1"
                        @click="code_confirm_dialog"
                      >
                        <v-icon dark> mdi-plus</v-icon>
                      </v-btn>
                    </v-col>
                    <v-col cols="9" class="text-right">
                      <v-card-text>{{ today }}</v-card-text>
                    </v-col>
                  </v-row>
                  <v-row justify="center">
                    <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                      <kcalBarChart
                        :calorie="todayCalorie"
                        :calorie-guideline="calorieGuideline"
                      />
                    </v-col>
                    <v-col cols="8" sm="8" md="5" lg="5" xl="5">
                      <gBarChart
                        :protein="todayProtein"
                        :protein-guideline="proteinGuideline"
                        :lipid="todayLipid"
                        :lipid-guideline="lipidGuideline"
                        :carbohydrate="todayCarbohydrate"
                        :carbohydrate-guideline="carbohydrateGuideline"
                      />
                    </v-col>
                  </v-row>
                </v-card>
              </v-col>
            </v-row>
            <v-row v-else>
              <v-col cols="12" class="mt-5">
                <v-card>
                  <v-card-title>今日食べた物一覧</v-card-title>
                  <v-list two-line>
                    <template v-for="(item, index) in data">
                      <v-list-item :key="index">
                        <v-list-item-content>
                          <v-list-item-title
                            class="green--text"
                            v-text="item.attributes.product_name"
                          ></v-list-item-title>

                          <v-list-item-subtitle
                            class="text--primary"
                            v-text="item.attributes.par"
                          ></v-list-item-subtitle>

                          <v-list-item-subtitle>
                            カロリー:{{ item.attributes.calorie }}kcal
                            たんぱく質:{{ item.attributes.protein }}g
                          </v-list-item-subtitle>
                          <v-list-item-subtitle>
                            脂質:{{ item.attributes.lipid }}g 炭水化物:{{
                              item.attributes.carbohydrate
                            }}g
                          </v-list-item-subtitle>
                        </v-list-item-content>

                        <v-list-item-action>
                          <v-list-item-action-text
                            v-text="dateTime(item.attributes.created_at)"
                          ></v-list-item-action-text>
                          <v-list-item-icon>
                            <v-btn icon @click="editDlgView(item)">
                              <v-icon color="green darken-1">
                                mdi-tooltip-edit
                              </v-icon>
                            </v-btn>
                            <v-btn icon>
                              <v-icon
                                color="red darken-3"
                                elevation="5"
                                @click="deleteDlgView(index)"
                              >
                                mdi-delete
                              </v-icon>
                            </v-btn>
                          </v-list-item-icon>
                        </v-list-item-action>
                      </v-list-item>

                      <v-divider
                        v-if="index < data.length - 1"
                        :key="`third-` + index"
                      ></v-divider>
                    </template>
                  </v-list>
                </v-card>
              </v-col>
            </v-row>
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
  </div>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import FoodRegisterDialog from '@/components/FoodRegisterDialog'
import Dialog from '@/components/Dialog'
import KcalBarChart from '@/components/KcalBarChart'
import GBarChart from '@/components/GBarChart'
import FoodEditDialog from '@/components/FoodEditDialog'
import FoodRegisterListDialog from '@/components/FoodRegisterListDialog'

export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    Dialog,
    KcalBarChart,
    GBarChart,
    FoodEditDialog,
    FoodRegisterListDialog,
  },
  middleware: 'auth',
  data() {
    return {
      num: null,
      todayCalorie: 0,
      todayProtein: 0,
      todayLipid: 0,
      todayCarbohydrate: 0,
      calorieGuideline: 0,
      proteinGuideline: 0,
      lipidGuideline: 0,
      carbohydrateGuideline: 0,
      today: null,
      tab: 0,
      items: [
        { title: '登録', icon: 'mdi-pencil-plus' },
        { title: 'リスト', icon: 'mdi-file-document' },
      ],
      selected: [],
      todayItems: [],
      data: null,
      editData: null,
      lists: null,
    }
  },
  created() {
    this.getFoodInfo()
    this.getGuideline()
  },
  methods: {
    code(code) {
      this.$refs.dlg.reset()
      this.num = code
      this.$axios.get('/api/v1/foods/' + this.num).then((response) => {
        this.dlgUp(response)
      })
    },
    cameraUp() {
      this.$refs.cameraDlg.isDisplay = true
    },
    dlgUp(response) {
      console.log(response)
      if (response.data) {
        if (response.data.web_search) {
          if (response.data.content) {
            this.$refs.dlg.productName = response.data.product_name
            this.$refs.dlg.par = response.data.par
            this.$refs.dlg.calorie = response.data.calorie
            this.$refs.dlg.protein = response.data.protein
            this.$refs.dlg.lipid = response.data.lipid
            this.$refs.dlg.carbohydrate = response.data.carbohydrate
          }
          this.$refs.dlg.func = 'web'
          this.$refs.dlg.calendarDate = this.$moment().format('YYYY-MM-DD')
          this.$refs.dlg.isDisplay = true
        } else if (response.data.data.length > 0) {
          console.log(response)
          this.lists = response.data.data
          this.$refs.listDlg.isDisplay = true
        } else {
          this.$refs.dlg.productName =
            response.data.data.attributes.product_name
          this.$refs.dlg.par = response.data.data.attributes.par
          this.$refs.dlg.calorie = response.data.data.attributes.calorie
          this.$refs.dlg.protein = response.data.data.attributes.protein
          this.$refs.dlg.lipid = response.data.data.attributes.lipid
          this.$refs.dlg.carbohydrate =
            response.data.data.attributes.carbohydrate
          this.$refs.dlg.url = response.data.data.attributes.image
          this.$refs.dlg.post_id = parseInt(response.data.data.id)
          if (response.data.data.attributes.func === 'my') {
            this.$refs.dlg.func = 'my'
            this.$refs.dlg.tab = 1
          }
          if (response.data.data.attributes.func === 'used') {
            this.$refs.dlg.func = 'used'
            this.$refs.dlg.tab = 1
          }
          this.$refs.dlg.calendarDate = this.$moment().format('YYYY-MM-DD')
          this.$refs.dlg.isDisplay = true
        }
      } else {
        console.log(response)
      }
    },
    code_confirm_dialog() {
      this.$refs.dialog.type = 'foodRegister'
      this.$refs.dialog.isDisplay = true
    },
    getFoodInfo() {
      const today = this.$moment().format('YYYY-MM-DD')
      this.today = today
      const url = '/api/v1/food_eat/' + today
      this.$axios.get(url).then((response) => {
        console.log(response)
        if (response.data.data.length) {
          const calorieArray = response.data.data.map(
            (attribute) => attribute.attributes.calorie
          )
          this.todayCalorie = calorieArray.reduce(function (a, b) {
            return a + b
          })
          const proteinArray = response.data.data.map(
            (attribute) => attribute.attributes.protein
          )
          this.todayProtein = proteinArray.reduce(function (a, b) {
            return a + b
          })
          const lipidArray = response.data.data.map(
            (attribute) => attribute.attributes.lipid
          )
          this.todayLipid = lipidArray.reduce(function (a, b) {
            return a + b
          })
          const carbohydrateArray = response.data.data.map(
            (attribute) => attribute.attributes.carbohydrate
          )
          this.todayCarbohydrate = carbohydrateArray.reduce(function (a, b) {
            return a + b
          })
          this.data = response.data.data.slice().reverse()
        } else {
          this.reset()
          this.today = today
          this.getGuideline()
        }
      })
    },
    getGuideline() {
      const url = '/api/v1/guideline'
      this.$axios.get(url).then((response) => {
        console.log(response)
        this.calorieGuideline = response.data.recommended_calorie
        this.proteinGuideline = response.data.recommended_protein
        this.lipidGuideline = response.data.recommended_lipid
        this.carbohydrateGuideline = response.data.recommended_carbohydrate
      })
    },
    editDlgView(item) {
      this.editData = item
      this.$refs.editDlg.isDisplay = true
    },
    eatEdit() {
      this.reset()
      this.getFoodInfo()
      this.getGuideline()
    },
    deleteDlgView(index) {
      this.$refs.dialog.type = 'eatDelete'
      this.$refs.dialog.id = index
      this.$refs.dialog.isDisplay = true
    },
    eatDelete(id) {
      const eatData = this.data[id]
      console.log(eatData.id)
      const url = '/api/v1/food_eat/' + eatData.id
      this.$axios.delete(url).then((response) => {
        console.log(response)
        this.reset()
        this.getFoodInfo()
        this.getGuideline()
      })
    },
    selectedItem(item) {
      console.log(item)
      this.$refs.dlg.reset()
      this.$refs.dlg.func = 'used'
      this.num = item.attributes.food_code
      this.$refs.dlg.begin = 100
      this.$refs.dlg.productName = item.attributes.product_name
      this.$refs.dlg.par = item.attributes.par
      this.$refs.dlg.calorie = item.attributes.calorie
      this.$refs.dlg.protein = item.attributes.protein
      this.$refs.dlg.lipid = item.attributes.lipid
      this.$refs.dlg.carbohydrate = item.attributes.carbohydrate
      this.$refs.dlg.post_id = parseInt(item.id)
      this.$refs.dlg.tab = 1
      this.$refs.dlg.calendarDate = this.$moment().format('YYYY-MM-DD')
      this.$refs.dlg.isDisplay = true
    },
    codeSearch(code) {
      this.$refs.listDlg.reset()
      this.num = code
      const url = '/api/v1/get_list_by_code/' + code
      this.$axios.get(url).then((response) => {
        this.lists = response.data.data
        this.$refs.listDlg.isDisplay = true
      })
    },
    dateTime(datetime) {
      const now = this.$moment()
      const target = this.$moment(datetime)
      const difference = now.diff(target, 'minutes')
      if (difference < 60) {
        if (difference < 2) {
          const seconds = now.diff(target, 'seconds').toString()
          return seconds + '秒前'
        } else {
          const minutes = difference.toString()
          return minutes + '分前'
        }
      } else {
        return target.format('hh:mm')
      }
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
