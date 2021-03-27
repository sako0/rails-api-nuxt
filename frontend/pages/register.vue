<template>
  <div>
    <v-snackbar v-model="snackbar" elevation="24" timeout="2000">
      {{ snackbarMsg }}

      <template #action="{ attrs }">
        <v-btn icon v-bind="attrs" @click="snackbar = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
    </v-snackbar>
    <div v-if="!pageOverlay">
      <cameraDialog ref="cameraDlg" @code="code" />
      <Dialog
        ref="dialog"
        @code_exist="cameraUp"
        @no_code="noCodeRegisterUp"
        @eatDelete="eatDelete($event)"
      />
      <FoodRegisterDialog
        ref="dlg"
        :number="num"
        :date="tabDate"
        @reGet="registerFinish"
        @codeSearch="codeSearch($event)"
        @reScan="cameraUp"
      />
      <FoodEditDialog ref="editDlg" :food-info="editData" @eatEdit="eatEdit" />
      <FoodRegisterListDialog
        ref="listDlg"
        :lists="lists"
        @selectedItem="selectedItem($event)"
      />
      <FoodRegisterNoCodeDialog
        ref="noCodeDlg"
        :date="tabDate"
        @reGet="registerFinish"
      />
      <v-row>
        <v-col class="center">
          <v-tabs
            v-model="tab"
            fixed-tabs
            background-color="green darken-1"
            dark
            center-active
            next-icon="mdi-arrow-right-bold-box-outline"
            prev-icon="mdi-arrow-left-bold-box-outline"
            show-arrows
          >
            <v-tabs-slider color="cyan accent-2"></v-tabs-slider>
            <v-tab v-for="item in items" :key="item.id">
              <div v-text="item.title"></div>
            </v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item
              v-for="item in items"
              :key="item.id"
              eager
              style="background-color: cornsilk"
            >
              <v-row>
                <v-col cols="12">
                  <v-card>
                    <v-card-title>栄養分摂取量を登録する</v-card-title>
                    <v-row>
                      <v-col cols="2">
                        <v-btn
                          class="mx-2"
                          fab
                          dark
                          color="green darken-1"
                          @click="code_confirm_dialog(item.date)"
                        >
                          <v-icon dark> mdi-plus</v-icon>
                        </v-btn>
                      </v-col>
                      <v-col cols="9" class="text-right">
                        <v-card-text>{{ item.date }}</v-card-text>
                      </v-col>
                    </v-row>
                    <v-row v-if="!tabChangeOverlay" justify="center">
                      <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                        <kcalBarChart
                          :calorie="arraySum(item.calorie)"
                          :calorie-guideline="calorieGuideline"
                        />
                      </v-col>
                      <v-col cols="8" sm="8" md="5" lg="5" xl="5">
                        <gBarChart
                          :protein="arraySum(item.protein)"
                          :protein-guideline="proteinGuideline"
                          :lipid="arraySum(item.lipid)"
                          :lipid-guideline="lipidGuideline"
                          :carbohydrate="arraySum(item.carbohydrate)"
                          :carbohydrate-guideline="carbohydrateGuideline"
                        />
                      </v-col>
                    </v-row>
                  </v-card>
                </v-col>
                <v-spacer></v-spacer>
                <v-col cols="12">
                  <v-card>
                    <v-container>
                      <v-card-title>食事内容</v-card-title>
                      <v-list two-line>
                        <v-divider></v-divider>
                        <template
                          v-for="(attributes, index) in item.attributes"
                        >
                          <v-list-item :key="index">
                            <v-list-item-content>
                              <v-list-item-title
                                class="green--text"
                                v-text="attributes.product_name"
                              ></v-list-item-title>

                              <v-list-item-subtitle
                                class="text--primary"
                                v-text="attributes.par"
                              ></v-list-item-subtitle>

                              <v-list-item-subtitle>
                                カロリー:{{ attributes.calorie }}kcal
                              </v-list-item-subtitle>
                              <v-list-item-subtitle>
                                たんぱく質:{{ attributes.protein }}g
                              </v-list-item-subtitle>
                              <v-list-item-subtitle>
                                脂質:{{ attributes.lipid }}g
                              </v-list-item-subtitle>
                              <v-list-item-subtitle>
                                炭水化物:{{ attributes.carbohydrate }}g
                              </v-list-item-subtitle>
                            </v-list-item-content>

                            <v-list-item-action>
                              <v-list-item-action-text
                                v-text="dateTime(attributes.created_at)"
                              ></v-list-item-action-text>
                              <v-list-item-icon>
                                <v-btn icon @click="editDlgView(attributes)">
                                  <v-icon color="green darken-1">
                                    mdi-tooltip-edit
                                  </v-icon>
                                </v-btn>
                                <v-btn icon>
                                  <v-icon
                                    color="red darken-3"
                                    elevation="5"
                                    @click="deleteDlgView(attributes.eat_id)"
                                  >
                                    mdi-delete
                                  </v-icon>
                                </v-btn>
                              </v-list-item-icon>
                            </v-list-item-action>
                          </v-list-item>
                          <v-divider
                            v-if="index < item.attributes.length - 1"
                            :key="`third-` + index"
                          ></v-divider>
                        </template>
                      </v-list>
                    </v-container>
                  </v-card>
                </v-col>
              </v-row>
            </v-tab-item>
          </v-tabs-items>
        </v-col>
      </v-row>
    </div>
    <div v-else>
      <v-overlay z-index="2">
        <v-progress-circular indeterminate size="80"></v-progress-circular>
      </v-overlay>
    </div>
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
import FoodRegisterNoCodeDialog from '@/components/FoodRegisterNoCodeDialog'

export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    Dialog,
    KcalBarChart,
    GBarChart,
    FoodEditDialog,
    FoodRegisterListDialog,
    FoodRegisterNoCodeDialog,
  },
  middleware: 'auth',
  data() {
    return {
      num: null,
      todayCalorie: [],
      todayProtein: [],
      todayLipid: [],
      todayCarbohydrate: [],
      calorieGuideline: 0,
      proteinGuideline: 0,
      lipidGuideline: 0,
      carbohydrateGuideline: 0,
      today: null,
      tabCount: 10,
      tab: 10,
      selected: [],
      todayItems: [],
      data: null,
      editData: null,
      lists: null,
      getFoodInfoLoading: true,
      getGuidelineLoading: true,
      sleepTime: 300,
      snackbar: false,
      snackbarMsg: null,
      foodLists: [],
      tabChangeOverlay: false,
      eatChangeOverlay: false,
      tabDate: null,
    }
  },
  computed: {
    pageOverlay() {
      if (this.getFoodInfoLoading || this.getGuidelineLoading) {
        return true
      } else {
        return false
      }
    },
    todayMoment() {
      return this.$moment().format('YYYY-MM-DD')
    },
    items() {
      const array = []
      for (let i = -this.tabCount; i < this.tabCount; i++) {
        const targetDay = this.$moment().add(i, 'days')
        const day = this.dayParse(targetDay.day())
        if (i === -1) {
          array.push({
            title: '昨日',
            date: targetDay.format('YYYY-MM-DD'),
            id: i,
            calorie: [],
            protein: [],
            lipid: [],
            carbohydrate: [],
            attributes: [],
          })
        } else if (i === 0) {
          array.push({
            title: '今日',
            date: targetDay.format('YYYY-MM-DD'),
            id: i,
            calorie: [],
            protein: [],
            lipid: [],
            carbohydrate: [],
            attributes: [],
          })
        } else if (i === 1) {
          array.push({
            title: '明日',
            date: targetDay.format('YYYY-MM-DD'),
            id: i,
            calorie: [],
            protein: [],
            lipid: [],
            carbohydrate: [],
            attributes: [],
          })
        } else {
          array.push({
            title: targetDay.format(day + ',MM/DD'),
            date: targetDay.format('YYYY-MM-DD'),
            id: i,
            calorie: [],
            protein: [],
            lipid: [],
            carbohydrate: [],
            attributes: [],
          })
        }
      }
      this.foodLists.forEach((foodEat) => {
        const targetDate = this.$moment(foodEat.attributes.date)
        const diff = this.$moment().diff(targetDate, 'days')
        let moment = 0
        if (targetDate.isBefore(this.$moment())) {
          moment = -diff
        } else {
          moment = diff
        }
        const tabNum = moment + this.tabCount
        array[tabNum].calorie.push(foodEat.attributes.calorie)
        array[tabNum].protein.push(foodEat.attributes.protein)
        array[tabNum].lipid.push(foodEat.attributes.lipid)
        array[tabNum].carbohydrate.push(foodEat.attributes.carbohydrate)
        array[tabNum].attributes.push(foodEat.attributes)
      })
      return array
    },
  },
  watch: {
    tab(val) {
      this.tabChangeOverlay = true
      this.tab = val
      setTimeout(() => {
        this.tabChangeOverlay = false
      }, 0.00001)
    },
  },
  created() {
    this.getFoodInfo()
  },
  methods: {
    code(code) {
      this.$refs.dlg.reset()
      this.$refs.dlg.foodRegisterOverlay = true
      this.$refs.listDlg.codeListOverlay = true
      this.num = code
      this.$axios
        .get('/api/v1/foods/' + this.num)
        .then((response) => {
          this.dlgUp(response)
        })
        .finally((response) => {
          setTimeout(() => {
            this.$refs.dlg.foodRegisterOverlay = false
            this.$refs.listDlg.codeListOverlay = false
          }, this.sleepTime)
        })
    },
    cameraUp() {
      this.$refs.cameraDlg.isDisplay = true
    },
    dlgUp(response) {
      if (response.data) {
        if (response.data.web_search) {
          if (response.data.content) {
            this.$refs.dlg.productData = response.data
            this.$refs.dlg.productName = response.data.product_name
            this.$refs.dlg.par = response.data.par
            this.$refs.dlg.calorie = response.data.calorie
            this.$refs.dlg.protein = response.data.protein
            this.$refs.dlg.lipid = response.data.lipid
            this.$refs.dlg.carbohydrate = response.data.carbohydrate
          }
          this.$refs.dlg.func = 'web'
          this.$refs.dlg.isDisplay = true
        } else if (response.data.data.length > 0) {
          this.lists = response.data.data
          this.$refs.listDlg.isDisplay = true
        } else {
          this.$refs.dlg.productData = response.data.data.attributes
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
          this.$refs.dlg.isDisplay = true
        }
      }
    },
    code_confirm_dialog(date) {
      this.tabDate = date
      this.$refs.dialog.type = 'foodRegister'
      this.$refs.dialog.isDisplay = true
    },
    getFoodInfo() {
      this.getFoodInfoLoading = true
      const today = this.$moment().format('YYYY-MM-DD')
      this.today = today
      const url = '/api/v1/food_eat/' + today
      this.$axios
        .get(url)
        .then((response) => {
          console.log(response)
          this.foodLists = response.data.data.slice().reverse()
          this.getGuideline()
        })
        .finally((response) => {
          setTimeout(() => {
            this.getFoodInfoLoading = false
          }, this.sleepTime)
        })
    },
    getGuideline() {
      this.getGuidelineLoading = true
      const url = '/api/v1/guideline'
      this.$axios
        .get(url)
        .then((response) => {
          this.calorieGuideline = response.data.recommended_calorie
          this.proteinGuideline = response.data.recommended_protein
          this.lipidGuideline = response.data.recommended_lipid
          this.carbohydrateGuideline = response.data.recommended_carbohydrate
        })
        .finally((response) => {
          setTimeout(() => {
            this.getGuidelineLoading = false
          }, this.sleepTime)
        })
    },
    editDlgView(item) {
      this.editData = item
      this.$refs.editDlg.reset()
      this.$refs.editDlg.isDisplay = true
    },
    eatEdit() {
      this.getFoodInfo()
      this.snackbarMsg = '更新しました'
      this.snackbar = true
    },
    deleteDlgView(eatId) {
      this.$refs.dialog.type = 'eatDelete'
      this.$refs.dialog.id = eatId
      this.$refs.dialog.isDisplay = true
    },
    eatDelete(eatId) {
      const url = '/api/v1/food_eat/' + eatId
      this.$axios.delete(url).then((response) => {
        this.getFoodInfo()
        this.snackbarMsg = '削除しました'
        this.snackbar = true
      })
    },
    selectedItem(item) {
      this.$refs.dlg.reset()
      this.$refs.dlg.func = 'used'
      this.num = item.attributes.food_code
      this.$refs.dlg.begin = 100
      this.$refs.dlg.productData = item.attributes
      this.$refs.dlg.productName = item.attributes.product_name
      this.$refs.dlg.par = item.attributes.par
      this.$refs.dlg.calorie = item.attributes.calorie
      this.$refs.dlg.protein = item.attributes.protein
      this.$refs.dlg.lipid = item.attributes.lipid
      this.$refs.dlg.carbohydrate = item.attributes.carbohydrate
      this.$refs.dlg.post_id = parseInt(item.id)
      this.$refs.dlg.tab = 1
      this.$refs.dlg.isDisplay = true
    },
    codeSearch(code) {
      this.$refs.listDlg.reset()
      this.$refs.listDlg.codeListOverlay = true
      this.$refs.listDlg.isDisplay = true
      this.num = code
      const url = '/api/v1/get_list_by_code/' + code
      this.$axios
        .get(url)
        .then((response) => {
          this.lists = response.data.data
        })
        .finally((response) => {
          setTimeout(() => {
            this.$refs.listDlg.codeListOverlay = false
          }, this.sleepTime)
        })
    },
    dateTime(datetime) {
      const now = this.$moment()
      const target = this.$moment(datetime)
      const difference = now.diff(target, 'minutes')
      const differenceDate = now.diff(target, 'days')
      if (differenceDate === 0 && difference < 60) {
        if (difference < 2) {
          const seconds = now.diff(target, 'seconds').toString()
          return seconds + '秒前'
        } else {
          const minutes = difference.toString()
          return minutes + '分前'
        }
      } else {
        return target.format('MM/DD hh:mm')
      }
    },
    noCodeRegisterUp() {
      this.$refs.noCodeDlg.reset()
      this.$refs.noCodeDlg.isDisplay = true
    },
    registerFinish() {
      this.getFoodInfo()
      this.snackbarMsg = '登録しました'
      this.snackbar = true
    },
    dayParse(val) {
      switch (val) {
        case 0:
          return '日'
        case 1:
          return '月'
        case 2:
          return '火'
        case 3:
          return '水'
        case 4:
          return '木'
        case 5:
          return '金'
        case 6:
          return '土'
      }
    },
    arraySum(array) {
      if (array.length) {
        const sum = array.reduce(function (a, b) {
          return a + b
        })
        return sum
      } else {
        return 0
      }
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
