import AppConfig from '../../common/AppConfig'
import { ActionSheetDialog } from '../../common/dialog/ActionSheetDialog'
import BalanceAccount from '../../common/entitys/BalanceAccount'
import BorrowerAccount from '../../common/entitys/BorrowerAccount'
import Tag from '../../common/entitys/Tag'
import BorrowerAccountType from '../../common/enums/BorrowerAccountType'
import FlowType from '../../common/enums/FlowType'
import InputMethod from '../../common/ui/InputMethod'
import Colors from '../../common/utils/Colors'
import Dates from '../../common/utils/Dates'
import Log from '../../common/utils/Log'
import NumberValue from '../../common/utils/NumberValue'
import { childController } from '../../model/ChildController'
import AccountSelectView from './views/AccountSelectView'
import BorrowerSelectView from './views/BorrowerSelectView'
import DateSelectView from './views/DateSelectView'
import MoneyInputView from './views/MoneyInputView'
import RemarkInputView from './views/RemarkInputView'
import SubTypeSelectView, { TypeName } from './views/SubTypeSelectView'
import TagsSelectView from './views/TagsSelectView'

/**
 * 还债
 */
@ComponentV2
export default struct RefundOrReceiptView {

  @Param initSubType: FlowType = FlowType.REFUND
  @Local subType: FlowType = this.initSubType

  @Local money: NumberValue = new NumberValue()
  @Local balanceAccount?: BalanceAccount = undefined
  @Local borrowerAccount?: BorrowerAccount = undefined
  @Local date: Date = new Date(Date.now())
  @Local tags: Array<Tag> = []
  @Local remark: string = ""

  @Param onParamsChanged: (params: object) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${FlowType.REFUND}`, () => {
      childController.call(`${FlowType.REFUND}-${MoneyInputView.name}`)
      childController.call(`${FlowType.REFUND}-${RemarkInputView.name}`)
    })
  }

  build() {
    Column() {
      SubTypeSelectView({
        initType: this.subType == FlowType.RECEIPT ? 1 : 0,
        leftTypeName: new TypeName("还款", "(还给他人)"),
        rightTypeName: new TypeName("收款", "(还钱给我)"),
        onTypeChanged: (type) => {
          this.subType = (type == 1 ? FlowType.RECEIPT : FlowType.REFUND)
        }
      })
      MoneyInputView({
        parent: `${FlowType.REFUND}`,
        textColor: this.subType==FlowType.RECEIPT ? Colors.success600 : Colors.blue600,
        placeholderColor: this.subType==FlowType.RECEIPT ? Colors.success300 : Colors.blue300,
        onMoneyChanged: (money) => {
          this.money = money
          this.paramsChanged()
        }
      })
      AccountSelectView({
        label: `${this.subType==FlowType.RECEIPT ? '收款' : '还款'}账户`,
        initAccount: this.balanceAccount,
        onSelectChanged: (account) => {
          this.balanceAccount = account
          this.paramsChanged()
        }
      })
      BorrowerSelectView({
        accountType: this.subType==FlowType.RECEIPT ? BorrowerAccountType.CREDIT : BorrowerAccountType.DEBIT,
        initAccount: this.borrowerAccount,
        typeNames: new Map()
          .set(BorrowerAccountType.DEBIT, new TypeName('收款方', '(还钱给谁)'))
          .set(BorrowerAccountType.CREDIT, new TypeName('还款人', '(向谁收款)')),
        onSelectChanged: (account) => {
          this.borrowerAccount = account
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
        type: FlowType.REFUND,
        initTags: this.tags,
        onSelectChanged: (tags) => {
          this.tags = tags
          this.paramsChanged()
        }
      })
      RemarkInputView({
        parent: `${FlowType.REFUND}`,
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
        ['accountId', this.balanceAccount?.id || ''],
        ['borrowerId', this.borrowerAccount?.id || ''],
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
