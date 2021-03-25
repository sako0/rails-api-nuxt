<template>
  <div>
    <!-- カメラの映像を表示させるDIV -->
    <v-dialog v-model="isDisplay" v-click-outside="closeDisplay" width="400px">
      <v-card>
        <v-card-title>バーコードを読みとる</v-card-title>
        <v-card-text>
          <v-container>
            <v-row justify="center">
              <v-col cols="auto">
                <div id="camera-area" class="camera-area">
                  <!-- 青い四角のDIV -->
                  <div class="detect-area"></div>
                </div>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <!-- 右上の閉じるボタン -->
        <v-card-actions>
          <v-container>
            <v-row>
              <v-col cols="auto">
                <v-btn
                  class="text-left"
                  aria-label="close"
                  @click="onClickCancel"
                  >Close</v-btn
                >
              </v-col>
            </v-row>
          </v-container>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </div>
</template>
<script>
export default {
  data() {
    return {
      isDisplay: false,
      code: false,
      verify: { count: 0, code: null },
    }
  },
  watch: {
    isDisplay(val) {
      this.$nextTick(() => {
        if (val) {
          // モーダル表示時、Quaggaを起動
          this.initQuagga()
        } else {
          // モーダル非表示時、Quaggaを停止
          this.Quagga.stop()
          if (this.code) {
            console.log(this.code)
            this.$emit('code', this.code)
          }
          this.reset()
        }
      })
    },
  },
  destroyed() {
    if (this.Quagga) this.Quagga.stop()
    this.reset()
  },
  methods: {
    initQuagga() {
      // requireで読み込み
      this.Quagga = require('quagga')

      // 解析中に呼び出される処理を設定
      this.Quagga.onProcessed(this.onProcessed)
      // バーコード検出時の処理を設定
      this.Quagga.onDetected(this.onDetected)

      // Quaggaの設定項目
      const config = {
        // カメラの映像の設定
        inputStream: {
          type: 'LiveStream',
          // カメラ映像を表示するHTML要素の設定
          target: document.querySelector('#camera-area'),
          // バックカメラの利用を設定. (フロントカメラは"user")
          constraints: { facingMode: 'environment' },
          // 検出範囲の指定: 上下30%は対象外
          area: { top: '30%', right: '0%', left: '0%', bottom: '30%' },
        },
        // 解析するワーカ数の設定
        numOfWorkers: navigator.hardwareConcurrency || 4,
        // バーコードの種類を設定: ISBNは"ean_reader"
        decoder: { readers: ['ean_reader'] },
      }
      // 初期化の開始。合わせて、初期化後の処理を設定
      this.Quagga.init(config, this.onInitilize)
    },
    /**
     * Quaggaの初期化完了後の処理
     * errorがなければ、起動する
     */
    onInitilize(error) {
      if (error) {
        // エラーがある場合は、キャンセルをEmitする
        console.error(`Error: ${error}`, error)
        this.onClickCancel()
        return
      }

      // エラーがない場合は、読み取りを開始
      console.info('読み取り開始')
      this.Quagga.start()
    },

    /**
     * バーコード検出時の処理
     */
    onDetected(success) {
      // ISBNは'success.codeResult.code'から取得
      const isbn = success.codeResult.code
      // ISBNをEmitで返却する
      const checkStr = isbn.toString()
      if (checkStr.startsWith('4') || checkStr.startsWith('2')) {
        this.onSuccess(isbn)
      }
    },
    onProcessed(data) {
      const ctx = this.Quagga.canvas.ctx.overlay
      const canvas = this.Quagga.canvas.dom.overlay

      if (!data) return

      // 認識したバーコードを緑の枠で囲む
      if (data.boxes) {
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        const hasNotRead = (box) => box !== data.box
        data.boxes.filter(hasNotRead).forEach((box) => {
          this.Quagga.ImageDebug.drawPath(box, { x: 0, y: 1 }, ctx, {
            color: 'green',
            lineWidth: 4,
          })
        })
      }
      // 読み取ったバーコードに線を引く
      if (data.codeResult && data.codeResult.code) {
        this.Quagga.ImageDebug.drawPath(data.line, { x: 'x', y: 'y' }, ctx, {
          color: 'red',
          lineWidth: 9,
        })
      }
    },
    onClickCancel() {
      this.isDisplay = false
    },
    onSuccess(code) {
      if (this.verify.code === code) {
        if (this.verify.count > 50) {
          this.isDisplay = false
          this.code = code
          this.verify.count = 0
        } else {
          this.verify.count += 1
        }
      } else {
        this.verify.count = 0
        this.verify.code = code
      }
    },
    closeDisplay() {
      this.isDisplay = false
    },
    reset() {
      Object.assign(this.$data, this.$options.data())
    },
  },
}
</script>
<style lang="scss">
.camera-area {
  position: center;
  /**
   * 指定したDIV配下にvideoとcanvasが追加される
   * 4:3になるため、margin-topで調整
   */
  video {
    margin-top: -7em;
    max-height: 17.2em;
    //transform: scale(1);
  }
  canvas {
    margin-top: -400px;
    width: 300px;
    height: 300px;
  }
}
/* 検出範囲のサイズに合わせ枠線を引く */
.detect-area {
  position: relative;
  width: 200px;
  top: 60px;
  left: 20%;
  height: 100px;
  border: 3px solid #0000ff;
}
</style>
