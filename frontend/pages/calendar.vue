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

      <v-container>
        <v-card-title>カレンダー</v-card-title>
        <v-sheet height="600">
          <v-calendar
            ref="calendar"
            v-model="value"
            locale="jp-ja"
            :day-format="(timestamp) => new Date(timestamp.date).getDate()"
            :weekdays="weekday"
            :show-month-on-first="false"
            :type="type"
            :events="events"
            :event-overlap-mode="mode"
            :event-overlap-threshold="30"
            :event-color="getEventColor"
            @change="getEvents"
          ></v-calendar>
        </v-sheet>
      </v-container>
      <v-spacer></v-spacer>
      <v-container>
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
                  <template v-for="(attributes, index) in item.attributes">
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
      </v-container>
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
      types: ['month', 'week'],
      mode: 'stack',
      modes: ['stack', 'column'],
      weekday: [0, 1, 2, 3, 4, 5, 6],
      weekdays: [
        { text: 'Sun - Sat', value: [0, 1, 2, 3, 4, 5, 6] },
        { text: 'Mon - Sun', value: [1, 2, 3, 4, 5, 6, 0] },
        { text: 'Mon - Fri', value: [1, 2, 3, 4, 5] },
        { text: 'Mon, Wed, Fri', value: [1, 3, 5] },
      ],
      value: '',
      events: [],
      colors: [
        'blue',
        'indigo',
        'deep-purple',
        'cyan',
        'green',
        'orange',
        'grey darken-1',
      ],
      names: [
        'Meeting',
        'Holiday',
        'PTO',
        'Travel',
        'Event',
        'Birthday',
        'Conference',
        'Party',
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
    item() {
      return this.eatItems[2].lists[0].attributes
    },
  },
  watch: {
    tab(val) {
      if (val === 11) {
        console.log(this.items)
      }
      this.tabChangeOverlay = true
      this.tab = val
      setTimeout(() => {
        this.tabChangeOverlay = false
      }, 1)
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
    itemsGet(obj) {
      if (obj) {
        Object.keys(obj).forEach((foodEat) => {
          const item = {
            id: obj[foodEat].attributes.eat_id,
            attributes: obj[foodEat].attributes,
          }
          const index =
            this.eatItems.findIndex(
              (t) => t.date === obj[foodEat].attributes.date
            ) - 1
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
          console.log(this.eatItems[index])
        })
        console.log(this.eatItems)
      }
    },
    getEvents({ start, end }) {
      const events = []

      const min = new Date(`${start.date}T00:00:00`)
      const max = new Date(`${end.date}T23:59:59`)
      const days = (max.getTime() - min.getTime()) / 86400000
      const eventCount = this.rnd(days, days + 20)

      for (let i = 0; i < eventCount; i++) {
        const allDay = this.rnd(0, 3) === 0
        const firstTimestamp = this.rnd(min.getTime(), max.getTime())
        const first = new Date(firstTimestamp - (firstTimestamp % 900000))
        const secondTimestamp = this.rnd(2, allDay ? 288 : 8) * 900000
        const second = new Date(first.getTime() + secondTimestamp)

        events.push({
          name: this.names[this.rnd(0, this.names.length - 1)],
          start: first,
          end: second,
          color: this.colors[this.rnd(0, this.colors.length - 1)],
          timed: !allDay,
        })
      }

      this.events = events
    },
    getEventColor(event) {
      return event.color
    },
    rnd(a, b) {
      return Math.floor((b - a + 1) * Math.random()) + a
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
