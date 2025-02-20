import AppConfig from '../../common/AppConfig'
import { ActionSheetDialog } from '../../common/dialog/ActionSheetDialog'
import BalanceAccount from '../../common/entitys/BalanceAccount'
import Tag from '../../common/entitys/Tag'
import FlowType from '../../common/enums/FlowType'
import InputMethod from '../../common/ui/InputMethod'
import Dates from '../../common/utils/Dates'
import NumberValue from '../../common/utils/NumberValue'
import { childController } from '../../model/ChildController'
import AccountSelectView from './views/AccountSelectView'
import DateSelectView from './views/DateSelectView'
import MoneyInputView from './views/MoneyInputView'
import RemarkInputView from './views/RemarkInputView'
import TagsSelectView from './views/TagsSelectView'
import Colors from '../../common/utils/Colors'

/**
 * 收入
 */
@ComponentV2
export default struct IncomeView {

  @Local subType: FlowType = FlowType.INCOME

  @Local money: NumberValue = new NumberValue()
  @Local account?: BalanceAccount = undefined
  @Local date: Date = new Date(Date.now())
  @Local tags: Array<Tag> = []
  @Local remark: string = ""

  @Param onParamsChanged: (params: object) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${this.subType}`, () => {
      childController.call(`${this.subType}-${MoneyInputView.name}`)
      childController.call(`${this.subType}-${RemarkInputView.name}`)
    })
  }

  build() {
    Column() {
      MoneyInputView({
        parent: `${this.subType}`,
        textColor: Colors.success600,
        placeholderColor: Colors.success300,
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
      DateSelectView({
        initDate: this.date,
        onSelectChanged: (data) => {
          this.date = data
          this.paramsChanged()
        }
      })
      TagsSelectView({
        type: this.subType,
        initTags: this.tags,
        onSelectChanged: (tags) => {
          this.tags = tags
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
    this.onParamsChanged(
      new Map([
        ['type', this.subType],
        ['accountId', this.account?.id || ''],
        ['amount', this.money.toString()],
        ['serviceCharge', '0'],
        ['title', ''],
        ['description', this.remark],
        ['tagIds', this.tags.map((tag) => tag.id).join(',')],
        ['eventTime', Dates.toMilliseconds(new Date(this.date.getFullYear(), this.date.getMonth(), this.date.getDate())).toString()],
      ])
    )
  }

  private dialog?: CustomDialogController = undefined
  /**
   * 显示底部弹窗
   */
  showBottomDialog(
    title: string,
    sheets: Array<SheetInfo>,
    onRightIconClick: () => void
  ) {
    InputMethod.hideSoftKeyboard()

    if (this.dialog != undefined) {
      this.dialog?.close()
    }
    this.dialog = new CustomDialogController({
      builder: ActionSheetDialog({
        title: title,
        rightIcon: $r('app.media.ic_topnav_settings'),
        onRightIconClick: onRightIconClick,
        sheets: sheets
      }),
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: 0 },
      customStyle: true,
      autoCancel: true,
      cancel: () => {
        this.dialog = undefined
      }
    })
    this.dialog.open()
  }

}
