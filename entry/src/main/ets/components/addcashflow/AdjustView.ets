import AppConfig from '../../common/AppConfig'
import BalanceAccount from '../../common/entitys/BalanceAccount'
import FlowType from '../../common/enums/FlowType'
import Colors from '../../common/utils/Colors'
import Dates from '../../common/utils/Dates'
import NumberValue from '../../common/utils/NumberValue'
import { childController } from '../../model/ChildController'
import AccountSelectView from './views/AccountSelectView'
import MoneyInputView from './views/MoneyInputView'
import RemarkInputView from './views/RemarkInputView'

/**
 * 余额调整
 */
@ComponentV2
export default struct AdjustView {

  @Local subType: FlowType = FlowType.ADJUST

  @Local money: NumberValue = new NumberValue()
  @Local account?: BalanceAccount = undefined
  @Local remark: string = ""

  @Param onParamsChanged: (params: object) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${this.subType}`, () => {
      childController.call(`${this.subType}-${RemarkInputView.name}`)
    })
  }

  build() {
    Column() {
      MoneyInputView({
        parent: `${this.subType}`,
        textColor: Colors.blue600,
        placeholderColor: Colors.blue300,
        onMoneyChanged: (money) => {
          this.money = money
          this.paramsChanged()
        }
      })
      AccountSelectView({
        initAccount: this.account,
        onSelectChanged: (account) => {
          this.account = account
          this.paramsChanged()
        }
      })
      RemarkInputView({
        parent: `${this.subType}`,
        onInputChanged: (text) => {
          this.remark = text
          this.paramsChanged()
        }
      })
    }
    .width('100%')
    .backgroundColor(AppConfig.defaultBgColor)
  }

  private paramsChanged() {
    let nowData = new Date(Date.now())
    this.onParamsChanged(
      new Map([
        ['type', this.subType],
        ['accountId', this.account?.id || ''],
        ['amount', this.money.toString()],
        ['serviceCharge', '0'],
        ['title', ''],
        ['description', this.remark],
        ['eventTime', Dates.toMilliseconds(new Date(nowData.getFullYear(), nowData.getMonth(), nowData.getDate())).toString()],
      ])
    )
  }

}
