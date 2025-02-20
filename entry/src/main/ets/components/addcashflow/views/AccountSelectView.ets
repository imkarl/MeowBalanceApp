import AppConfig from '../../../common/AppConfig'
import { ActionSheetDialog } from '../../../common/dialog/ActionSheetDialog'
import BalanceAccount from '../../../common/entitys/BalanceAccount'
import InputMethod from '../../../common/ui/InputMethod'
import toast from '../../../common/ui/Toast'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { BalanceRepo } from '../../../model/BalanceAccountReop'

/**
 * 账户选择控件
 */
@ComponentV2
export default struct AccountSelectView {

  @Param label?: string = undefined
  @Param initAccount?: BalanceAccount = undefined
  @Local selectedAccount?: BalanceAccount = undefined

  @Param onSelectChanged: (account: BalanceAccount) => void = () => {}

  aboutToAppear(): void {
    this.selectedAccount = this.initAccount
    if (!this.selectedAccount) {
      BalanceRepo.loadAll()
        .then((list) => {
          if (list.length > 0) {
            let account = list[0]
            this.selectedAccount = account
            this.onSelectChanged(account)
          }
        })
    }
  }

  build() {
    Row() {
      Image($r('app.media.ic_account'))
        .width('16vp')
        .height('16vp')
        .objectFit(ImageFit.Contain)
        .align(Alignment.Center)

      Text(`${(this.label && this.label.length>0) ? this.label : '账户'}：`)
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .margin({ left: '4vp' })

      Row() {
        Row() {
          if (this.selectedAccount && this.selectedAccount.name.length > 0) {
            Text(this.selectedAccount.name)
              .fontColor(Colors.gray1000)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Start)
              .height('33vp')
          } else {
            Text("请选择账户...")
              .fontColor(Colors.gray600)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Start)
              .height('33vp')
          }
        }
        .stateStyles({
          normal: { .backgroundColor(AppConfig.defaultBgColor) },
          pressed: { .backgroundColor(Colors.gray200) },
          focused: { .backgroundColor(Colors.gray200) },
        })
        .alignItems(VerticalAlign.Top)
        .height('33vp')
        .margin({ bottom: '1vp' })
        .flexGrow(1)
      }
      .backgroundColor(Colors.gray600)
      .height('34vp')
      .flexGrow(1)
      .margin({ left: '8vp' })
      .onClick(() => {
        this.onClickSelect()
      })
    }
    .width(Dimensions.FULL_PARENT)
    .height('34vp')
    .padding({ left: '24vp', right: '24vp' })
    .margin({ top: '12vp' })
  }

  private async onClickSelect() {
    let balanceAccounts = await BalanceRepo.loadAll()
    let sheets = new Array<SheetInfo>()
    balanceAccounts.forEach((item) => {
      let sheet = BalanceAccount.toSheet(item, (account) => {
        this.selectedAccount = account
        this.onSelectChanged(account)
        this.dialog?.close()
      })
      sheets.push(sheet)
    })
    this.showBottomDialog(
      "选择账户",
      sheets,
      () => {
        toast("setting")
      }
    )
  }

  private dialog?: CustomDialogController = undefined
  /**
   * 显示底部弹窗
   */
  private showBottomDialog(
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