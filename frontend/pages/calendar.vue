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
        :date="selectedDate"
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
        :date="selectedDate"
        @reGet="registerFinish"
      />
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
          <v-container v-show="index === 0">
            <v-card-title>カレンダー</v-card-title>
            <v-sheet tile height="54" class="d-flex">
              <v-btn icon class="ma-2" @click="$refs.calendar[0].prev()">
                <v-icon>mdi-chevron-left</v-icon>
              </v-btn>
              <v-spacer></v-spacer>
              {{ calendarMonth }}
              <v-spacer></v-spacer>
              <v-btn icon class="ma-2" @click="$refs.calendar[0].next()">
                <v-icon>mdi-chevron-right</v-icon>
              </v-btn>
            </v-sheet>
            <v-sheet height="500">
              <v-calendar
                ref="calendar"
                v-model="value"
                :event-height="40"
                locale="jp-ja"
                :day-format="(timestamp) => new Date(timestamp.date).getDate()"
                :weekdays="weekday"
                :show-month-on-first="false"
                :type="type"
                :events="events"
                :event-overlap-mode="mode"
                :event-overlap-threshold="30"
                :value="selectedDate"
                @change="getEvents"
                @click:date="showFoodEat"
                @click:event="showFoodEat"
              ></v-calendar>
            </v-sheet>
          </v-container>
          <v-spacer></v-spacer>
          <v-container v-show="index === 1" v-if="selectedDateItem">
            <v-card-title>内容</v-card-title>
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
                        @click="code_confirm_dialog(selectedDate)"
                      >
                        <v-icon dark> mdi-plus</v-icon>
                      </v-btn>
                    </v-col>
                    <v-col cols="9" class="text-right">
                      <v-card-text>{{ selectedDate }}</v-card-text>
                    </v-col>
                  </v-row>
                  <v-row v-if="!tabChangeOverlay" justify="center">
                    <v-col cols="4" sm="4" md="3" lg="3" xl="3">
                      <kcalBarChart
                        :calorie="selectedDateItem.totals.calorie"
                        :calorie-guideline="calorieGuideline"
                      />
                    </v-col>
                    <v-col cols="8" sm="8" md="5" lg="5" xl="5">
                      <gBarChart
                        :protein="selectedDateItem.totals.protein"
                        :protein-guideline="proteinGuideline"
                        :lipid="selectedDateItem.totals.lipid"
                        :lipid-guideline="lipidGuideline"
                        :carbohydrate="selectedDateItem.totals.carbohydrate"
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
                    <v-list v-if="selectedDateItem.lists.length" two-line>
                      <v-divider></v-divider>
                      <template v-for="(item, index) in selectedDateItem.lists">
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
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                              たんぱく質:{{ item.attributes.protein }}g
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                              脂質:{{ item.attributes.lipid }}g
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                              炭水化物:{{ item.attributes.carbohydrate }}g
                            </v-list-item-subtitle>
                          </v-list-item-content>

                          <v-list-item-action>
                            <v-list-item-action-text
                              v-text="dateTime(item.attributes.created_at)"
                            ></v-list-item-action-text>
                            <v-list-item-icon>
                              <v-btn icon @click="editDlgView(item.attributes)">
                                <v-icon color="green darken-1">
                                  mdi-tooltip-edit
                                </v-icon>
                              </v-btn>
                              <v-btn icon>
                                <v-icon
                                  color="red darken-3"
                                  elevation="5"
                                  @click="deleteDlgView(item.attributes.eat_id)"
                                >
                                  mdi-delete
                                </v-icon>
                              </v-btn>
                            </v-list-item-icon>
                          </v-list-item-action>
                        </v-list-item>
                        <v-divider
                          v-if="index < selectedDateItem.lists.length - 1"
                          :key="`third-` + index"
                        ></v-divider>
                      </template>
                    </v-list>
                  </v-container>
                </v-card>
              </v-col>
            </v-row>
          </v-container>
          <v-container v-show="index === 1" v-else>
            <v-card>
              <v-card-text> まだ登録できません </v-card-text>
            </v-card>
          </v-container>
        </v-tab-item>
      </v-tabs-items>
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
      type: 'month',
      mode: 'stack',
      weekday: [0, 1, 2, 3, 4, 5, 6],
      weekdays: [
        { text: 'Sun - Sat', value: [0, 1, 2, 3, 4, 5, 6] },
        { text: 'Mon - Sun', value: [1, 2, 3, 4, 5, 6, 0] },
        { text: 'Mon - Fri', value: [1, 2, 3, 4, 5] },
        { text: 'Mon, Wed, Fri', value: [1, 3, 5] },
      ],
      value: '',
      events: [],
      colors: ['blue', 'deep-purple', 'orange', 'grey darken-1'],
      names: ['適正', '多い', '少ない', '判別中'],
      tab: 0,
      items: [
        { title: 'カレンダー', icon: 'mdi-calendar-month' },
        { title: '登録情報', icon: 'mdi-pencil-plus' },
      ],
      calorieGuideline: 0,
      proteinGuideline: 0,
      lipidGuideline: 0,
      carbohydrateGuideline: 0,
      today: null,
      selected: [],
      todayItems: [],
      data: null,
      editData: null,
      lists: null,
      getFoodInfoLoading: false,
      getGuidelineLoading: false,
      sleepTime: 50,
      snackbar: false,
      snackbarMsg: null,
      foodLists: [],
      tabChangeOverlay: false,
      eatChangeOverlay: false,
      tabDate: null,
      eatItems: [],
      calendarMonth: null,
      selectedDate: null,
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
    selectedDateItem() {
      const item = this.eatItems.find((t) => t.date === this.selectedDate)
      if (item) {
        return item
      } else {
        if (
          this.$moment(this.selectedDate).format('YYYY-MM-DD') <=
          this.$moment().add(9, 'days').format('YYYY-MM-DD')
        ) {
          return {
            date: this.selectedDate,
            lists: [],
            totals: {
              calorie: 0,
              protein: 0,
              lipid: 0,
              carbohydrate: 0,
            },
          }
        }
        return null
      }
    },
  },
  watch: {
    tab(val) {
      this.tabChangeOverlay = true
      this.tab = val
      setTimeout(() => {
        this.tabChangeOverlay = false
      }, 1)
    },
  },
  created() {
    this.selectedDate = this.$moment().format('YYYY-MM-DD')
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
      this.eatItems = []
      this.getFoodInfoLoading = true
      const url = '/api/v1/food_eat'
      this.$axios
        .get(url)
        .then((response) => {
          console.log(response)
          const foodLists = response.data.data.slice().reverse()
          this.itemsGet(foodLists)
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
    itemsGet(obj) {
      console.log(obj)
      if (obj) {
        Object.keys(obj).forEach((foodEat) => {
          const item = {
            id: obj[foodEat].attributes.eat_id,
            attributes: obj[foodEat].attributes,
          }
          const index = this.eatItems.findIndex(
            (t) => t.date === obj[foodEat].attributes.date
          )
          if (index > -1) {
            this.eatItems[index].lists.push(item)
            this.eatItems[index].totals.calorie +=
              obj[foodEat].attributes.calorie
            this.eatItems[index].totals.protein +=
              obj[foodEat].attributes.protein
            this.eatItems[index].totals.lipid += obj[foodEat].attributes.lipid
            this.eatItems[index].totals.carbohydrate +=
              obj[foodEat].attributes.carbohydrate
          } else {
            this.eatItems.push({
              date: obj[foodEat].attributes.date,
              lists: [item],
              totals: {
                calorie: obj[foodEat].attributes.calorie,
                protein: obj[foodEat].attributes.protein,
                lipid: obj[foodEat].attributes.lipid,
                carbohydrate: obj[foodEat].attributes.carbohydrate,
              },
            })
          }
        })
      }
    },
    getEvents({ start, end }) {
      this.calendarMonth = this.$refs.calendar[0].title + '年'
      const events = []
      this.eatItems.forEach((item) => {
        const day = this.$moment(item.date).format('YYYY-MM-DD')
        const today = this.$moment().format('YYYY-MM-DD')
        let check = 3
        if (day >= today) {
          check = 3
          // カロリー基準値を1000とした場合1300~900までなら正常値
        } else if (
          item.totals.calorie <= this.calorieGuideline + 300 &&
          this.calorieGuideline - 300 <= item.totals.calorie
        ) {
          check = 0
        } else if (item.totals.calorie >= this.calorieGuideline + 301) {
          check = 1
        } else if (this.calorieGuideline - 301 >= item.totals.calorie) {
          check = 2
        } else {
          check = 3
        }
        events.push({
          name: this.names[check],
          start: day,
          end: day,
          color: this.colors[check],
          timed: false,
        })
      })

      this.events = events
    },
    showFoodEat(selected) {
      if (selected.date) {
        this.selectedDate = selected.date
      } else if (selected.day.date) {
        this.selectedDate = selected.day.date
      }
      this.tab = 1
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
