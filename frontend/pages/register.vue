<template>
  <v-row>
    <v-col class="center">
      <v-row>
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

            <cameraDialog ref="cameraDlg" @cancel="cancel" @code="code" />
            <Dialog
              ref="dialog"
              type="foodRegister"
              @code_exist="cameraUp"
              @no_code="dlgUp"
            />
            <FoodRegisterDialog ref="dlg" :number="num" @reGet="getFoodInfo" />
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
    </v-col>
  </v-row>
</template>
<script>
import CameraDialog from '@/components/CameraDialog'
import FoodRegisterDialog from '@/components/FoodRegisterDialog'
import Dialog from '@/components/Dialog'
import KcalBarChart from '@/components/KcalBarChart'
import GBarChart from '@/components/GBarChart'
export default {
  components: {
    CameraDialog,
    FoodRegisterDialog,
    Dialog,
    KcalBarChart,
    GBarChart,
  },
  middleware: 'auth',
  // async asyncData({ $axios, $moment, redirect }) {
  //   try {
  //     const today = $moment().format('YYYY-MM-DD')
  //     const url = '/api/v1/food_eat/' + today
  //     const response = await $axios.get(url)
  //     const calorieArray = response.data.data.map(
  //       (attribute) => attribute.attributes.calorie
  //     )
  //     const todayCalorie = calorieArray.reduce(function (a, b) {
  //       return a + b
  //     })
  //     const proteinArray = response.data.data.map(
  //       (attribute) => attribute.attributes.protein
  //     )
  //     const todayProtein = proteinArray.reduce(function (a, b) {
  //       return a + b
  //     })
  //     const lipidArray = response.data.data.map(
  //       (attribute) => attribute.attributes.lipid
  //     )
  //     const todayLipid = lipidArray.reduce(function (a, b) {
  //       return a + b
  //     })
  //     const carbohydrateArray = response.data.data.map(
  //       (attribute) => attribute.attributes.carbohydrate
  //     )
  //     const todayCarbohydrate = carbohydrateArray.reduce(function (a, b) {
  //       return a + b
  //     })
  //     return {
  //       todayCalorie,
  //       todayProtein,
  //       todayLipid,
  //       todayCarbohydrate,
  //     }
  //   } catch (err) {
  //     return redirect('/')
  //   }
  // },
  data() {
    return {
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
    }
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
      this.$refs.dialog.isDisplay = true
    },
    getFoodInfo() {
      const today = this.$moment().format('YYYY-MM-DD')
      this.today = today
      const url = '/api/v1/food_eat/' + today
      this.$axios.get(url).then((response) => {
        console.log(response)
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
  },
}
</script>
