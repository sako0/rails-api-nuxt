<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  props: {
    protein: Number,
    proteinGuideline: Number,
    lipid: Number,
    lipidGuideline: Number,
    carbohydrate: Number,
    carbohydrateGuideline: Number,
  },
  data() {
    return {
      chartdata: {
        labels: ['たんぱく質', '脂質', '炭水化物'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [
              Math.round(this.protein),
              Math.round(this.lipid),
              Math.round(this.carbohydrate),
              0,
            ],
          },
          {
            label: ['目安量'],
            backgroundColor: '#7e7e7e',
            data: [
              this.proteinGuideline,
              this.lipidGuideline,
              this.carbohydrateGuideline,
              0,
            ],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
      },
    }
  },
  watch: {
    protein(val) {
      const int = Math.round(val)
      this.chartdata.datasets[0].data = [int, this.lipid, this.carbohydrate, 0]
      this.renderChart(this.chartdata, this.options)
    },
    proteinGuideline(val) {
      this.chartdata.datasets[1].data = [
        val,
        this.lipidGuideline,
        this.carbohydrateGuideline,
        0,
      ]
      this.renderChart(this.chartdata, this.options)
    },
    lipid(val) {
      const int = Math.round(val)
      console.log(int)
      this.chartdata.datasets[0].data = [
        this.protein,
        int,
        this.carbohydrate,
        0,
      ]
      this.renderChart(this.chartdata, this.options)
    },
    lipidGuideline(val) {
      this.chartdata.datasets[1].data = [
        this.proteinGuideline,
        val,
        this.carbohydrateGuideline,
        0,
      ]
      this.renderChart(this.chartdata, this.options)
    },
    carbohydrate(val) {
      const int = Math.round(val)
      this.chartdata.datasets[0].data = [this.protein, this.lipid, int, 0]
      this.renderChart(this.chartdata, this.options)
    },
    carbohydrateGuideline(val) {
      this.chartdata.datasets[1].data = [
        this.proteinGuideline,
        this.lipidGuideline,
        val,
        0,
      ]
      this.renderChart(this.chartdata, this.options)
    },
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
