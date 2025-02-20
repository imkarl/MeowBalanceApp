import Colors from '../../../common/utils/Colors'
import NumberValue from '../../../common/utils/NumberValue'
import { childController } from '../../../model/ChildController'

/**
 * 金额输入控件
 */
@ComponentV2
export default struct MoneyInputView {

  @Param parent: string = ""

  @Local money: NumberValue = new NumberValue()
  @Local isFocus: boolean = false

  @Param textColor: Resource = Colors.black
  @Param placeholderColor: Resource = Colors.black

  @Param onMoneyChanged: (money: NumberValue) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${this.parent}-${MoneyInputView.name}`, () => {
      this.money = new NumberValue()
    })
  }

  build() {
    Column() {
      TextInput({ placeholder: "0.00", text: this.money.toString() })
        .placeholderColor(this.placeholderColor)
        .placeholderFont({ size: '24vp' })
        .fontColor(this.textColor)
        .fontSize('24vp')
        .textAlign(TextAlign.Start)
        .padding({ left: 0, right: 0 })
        .height('50vp')
        .borderRadius(0)
        .onFocus(() => {
          this.isFocus = true
        })
        .onBlur(() => {
          this.isFocus = false
        })
        .type(InputType.NUMBER_DECIMAL)
        .onChange((value: string, previewText?: PreviewText) => {
          let text = value
          let newMoney = NumberValue.parse(text)
          if (newMoney.first.length <= 12 && newMoney.second.length <= 12) {
            this.money = newMoney
          } else {
            this.money = NumberValue.parse(this.money.toString())
          }
          this.onMoneyChanged(this.money)
        })

      Divider().vertical(false).strokeWidth('1vp')
        .color(this.textColor)
        // .color((this.isFocus || this.money.toString().length > 0) ? this.textColor : this.placeholderColor)
    }
    .margin({ left: '24vp', right: '24vp', top: '24vp', bottom: '12vp' })
  }

}