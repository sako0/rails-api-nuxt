<script>
import { Bar } from 'vue-chartjs'
export default {
  extends: Bar,
  data() {
    return {
      chartdata: {
        labels: ['たんぱく質', '脂質', '炭水化物'],
        datasets: [
          {
            label: ['摂取量'],
            backgroundColor: '#00a0ff',
            data: [70, 60, 40, 0],
          },
          {
            label: ['目安量'],
            backgroundColor: '#7e7e7e',
            data: [60, 50, 40, 0],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
      },
    }
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  },
}
</script>
