import toast from '../ui/Toast'
import Colors from '../utils/Colors'

@CustomDialog
export struct InputMoneyDialogBuilder {

  // 弹窗的标题
  @Link title: string

  // 输入框的初始内容
  @Link inputValue: string

  // 是否显示选择日期
  @Link showDateTime: boolean

  onConfirm: (() => void) = () => {}
  onCancel: (() => void) = () => {}

  dialogController: CustomDialogController


  build() {
    Column() {
      Text(this.title)
        .fontSize(16)
        .margin({ top: 20, bottom: 20 })

      Text(this.inputValue)
        .backgroundColor(Colors.blue100)
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .textAlign(TextAlign.Start)
        .padding({ left: 12, right: 12 })
        .width("100%")
        .height(60)

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        Text("1")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .textAlign(TextAlign.Center)
          .width("25%")
          .height(70)
          .onClick(() => {
            this.inputNumber("1")
          })
        Text("2")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("2")
          })
        Text("3")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("3")
          })
        Text("今天")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .visibility(this.showDateTime ? Visibility.Visible : Visibility.Hidden)

        Text("4")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("4")
          })
        Text("5")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("5")
          })
        Text("6")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("6")
          })
        Text("+")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)

        Text("7")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("7")
          })
        Text("8")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("8")
          })
        Text("9")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("9")
          })
        Text("-")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)

        Text(".")
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber(".")
          })
        Text("0")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.inputNumber("0")
          })
        Image("images/ic_number_delete.svg")
          .backgroundColor("#333")
          .objectFit(ImageFit.Contain)
          .padding({ left: 30, right: 16, top: 16, bottom: 16 })
          .width("25%")
          .height(70)
          .onClick(() => {
            this.deleteNumber()
          })
        Text("确定")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .backgroundColor("#333")
          .fontColor("#fff")
          .width("25%")
          .height(70)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.onConfirm()
          })
      }
      .backgroundColor("#333")
      .width('100%')
      .padding({ bottom: 12 })
    }
    .backgroundColor(Color.White)
    .margin(0)
    .border({
      radius: { topLeft: 16, topRight: 16, bottomLeft: 0, bottomRight: 0 }
    })
  }


  inputNumber(number: String) {
    let dotIndex = this.inputValue.indexOf(".")
    if (number == ".") {
      if (dotIndex >= 0) {
        return
      }
    } else {
      if (dotIndex >= 0 && this.inputValue.length - dotIndex >= 3) {
        return
      }
    }

    if (this.inputValue == "0") {
      if (number != ".") {
        this.inputValue = ""
      }
    }

    if (dotIndex < 0 && this.inputValue.length >= 9) {
      toast("金额不能高于或等于10亿")
      return
    }

    this.inputValue += number
  }
  deleteNumber() {
    if (this.inputValue.length == 0) {
      this.inputValue = "0"
    }
    this.inputValue = this.inputValue.substring(0, this.inputValue.length - 1)
    if (this.inputValue.length == 0) {
      this.inputValue = "0"
    }
  }


}
