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
import SubTypeSelectView, { TypeName } from './views/SubTypeSelectView'
import BorrowerSelectView from './views/BorrowerSelectView'
import BorrowerAccountType from '../../common/enums/BorrowerAccountType'
import BorrowerAccount from '../../common/entitys/BorrowerAccount'

/**
 * 借贷
 */
@ComponentV2
export default struct BorrowOrLendView {

  @Param initSubType: FlowType = FlowType.BORROW
  @Local subType: FlowType = this.initSubType

  @Local money: NumberValue = new NumberValue()
  @Local balanceAccount?: BalanceAccount = undefined
  @Local borrowerAccount?: BorrowerAccount = undefined
  @Local date: Date = new Date(Date.now())
  @Local tags: Array<Tag> = []
  @Local remark: string = ""

  @Param onParamsChanged: (params: object) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${FlowType.BORROW}`, () => {
      childController.call(`${FlowType.BORROW}-${MoneyInputView.name}`)
      childController.call(`${FlowType.BORROW}-${RemarkInputView.name}`)
    })
  }

  build() {
    Column() {
      SubTypeSelectView({
        initType: this.subType == FlowType.LEND ? 1 : 0,
        leftTypeName: new TypeName("借入", "(借钱给我)"),
        rightTypeName: new TypeName("借出", "(借给他人)"),
        onTypeChanged: (type) => {
          this.subType = (type == 1 ? FlowType.LEND : FlowType.BORROW)
        }
      })

      MoneyInputView({
        parent: `${FlowType.BORROW}`,
        textColor: this.subType==FlowType.LEND ? Colors.wraning600 : Colors.success600,
        placeholderColor: this.subType==FlowType.LEND ? Colors.wraning300 : Colors.success300,
        onMoneyChanged: (money) => {
          this.money = money
          this.paramsChanged()
        }
      })
      AccountSelectView({
        label: `${this.subType==FlowType.LEND ? '借出' : '借入'}账户`,
        initAccount: this.balanceAccount,
        onSelectChanged: (account) => {
          this.balanceAccount = account
          this.paramsChanged()
        }
      })
      BorrowerSelectView({
        accountType: this.subType==FlowType.LEND ? BorrowerAccountType.CREDIT : BorrowerAccountType.DEBIT,
        initAccount: this.borrowerAccount,
        typeNames: new Map()
          .set(BorrowerAccountType.DEBIT, new TypeName('出借方', '(向谁借钱)'))
          .set(BorrowerAccountType.CREDIT, new TypeName('借贷人', '(借钱给谁)')),
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
        type: FlowType.BORROW,
        initTags: this.tags,
        onSelectChanged: (tags) => {
          this.tags = tags
          this.paramsChanged()
        }
      })
      RemarkInputView({
        parent: `${FlowType.BORROW}`,
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
