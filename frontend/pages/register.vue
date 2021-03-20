<template>
  <v-row>
    <v-col class="center">
      <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
      <Dialog
        ref="dialog"
        :type="type"
        @code_exist="cameraUp"
        @no_code="dlgUp"
        @eatDelete="eatDelete($event)"
      />
      <FoodRegisterDialog ref="dlg" :number="num" @reGet="getFoodInfo" />
      <FoodEditDialog ref="editDlg" :food-info="editData" />
      <v-tabs v-model="tab" background-color="transparent" color="basil" grow>
        <v-tabs-slider color="light-blue darken-1"></v-tabs-slider>
        <v-tab v-for="item in items" :key="item">
          {{ item }}
        </v-tab>
      </v-tabs>
      <v-tabs-items v-model="tab">
        <v-tab-item v-for="(item, index) in items" :key="item">
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
                      color="indigo"
                      @click="code_confirm_dialog"
                    >
                      <v-icon dark> mdi-plus </v-icon>
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
                          class="blue--text"
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
                          v-text="item.attributes.percent"
                        ></v-list-item-action-text>
                        <v-list-item-icon>
                          <v-btn icon @click="editDlgView(item)">
                            <v-icon color="yellow darken-3">
                              mdi-tooltip-edit
                            </v-icon>
                          </v-btn>
                          <v-btn icon>
                            <v-icon
                              color="red darken-3"
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
                      :key="`second-${index}`"
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
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import FoodRegisterDialog from '@/components/FoodRegisterDialog'
import Dialog from '@/components/Dialog'
import KcalBarChart from '@/components/KcalBarChart'
import GBarChart from '@/components/GBarChart'
import FoodEditDialog from '@/components/FoodEditDialog'
export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    Dialog,
    KcalBarChart,
    GBarChart,
    FoodEditDialog,
  },
  middleware: 'auth',
  data() {
    return {
      type: null,
      num: '',
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
      items: ['登録', 'リスト'],
      selected: [],
      todayItems: [],
      data: null,
      editData: null,
    }
  },
  watch: {
    data(ref) {
      console.log(ref)
    },
  },
  created() {
    this.getFoodInfo()
    this.getGuideline()
  },
  methods: {
    cancel() {},
    code(code) {
      this.num = code
      this.$refs.dlg.reset()
      this.$refs.dlg.calendarDate = this.$moment().format('YYYY-MM-DD')
      this.$refs.dlg.isDisplay = true
    },
    cameraUp() {
      this.$refs.cameraDlg.isDisplay = true
    },
    dlgUp() {},
    code_confirm_dialog() {
      this.type = 'foodRegister'
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
    deleteDlgView(index) {
      this.type = 'eatDelete'
      this.$refs.dialog.id = index
      this.$refs.dialog.isDisplay = true
    },
    eatDelete(id) {
      const eatData = this.data[id]
      console.log(eatData.id)
      const url = '/api/v1/food_eat/' + eatData.id
      this.$axios.delete(url).then((response) => {
        console.log(response)
        this.getFoodInfo()
      })
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
