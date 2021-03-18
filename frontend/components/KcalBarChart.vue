<script>
import { Bar, mixins } from 'vue-chartjs'
export default {
  mixins: [Bar, mixins.reactiveData],
  props: {
    calorie: Number,
    calorieGuideline: Number,
  },
  data() {
    return {
      chartdata: {
        labels: ['カロリー'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [Math.round(this.calorie), 0],
          },
          {
            label: ['目安量'],
            backgroundColor: '#7e7e7e',
            data: [this.calorieGuideline, 0],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        title: {
          // 見出し
          display: true,
        },
        legend: {
          // 凡例
          display: false,
        },
        scales: {
          yAxes: [
            {
              ticks: {
                autoSkip: false,
                callback: (value, index, values) => {
                  return value / 100
                },
              },
              scaleLabel: {
                // 表示されるy軸の名称について
                display: false, // 表示するか否か
              },
            },
          ],
          xAxes: [
            // x軸
            {
              scaleLabel: {
                // 表示されるx軸の名称について
                display: false,
              },
            },
          ],
        },
      },
    }
  },
  watch: {
    calorie(val) {
      const int = Math.round(val)
      this.chartdata.datasets[0].data = [int, 0]
      this.renderChart(this.chartdata, this.options)
    },
    calorieGuideline(val) {
      this.chartdata.datasets[1].data = [val, 0]
      this.renderChart(this.chartdata, this.options)
    },
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
