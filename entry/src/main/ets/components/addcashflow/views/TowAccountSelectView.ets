import AppConfig from '../../../common/AppConfig'
import { ActionSheetDialog } from '../../../common/dialog/ActionSheetDialog'
import BalanceAccount from '../../../common/entitys/BalanceAccount'
import InputMethod from '../../../common/ui/InputMethod'
import toast from '../../../common/ui/Toast'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { BalanceRepo } from '../../../model/BalanceAccountReop'

/**
 * 同时选择2个账户的控件
 */
@ComponentV2
export default struct TowAccountSelectView {

  @Param fromAccount?: BalanceAccount = undefined
  @Param toAccount?: BalanceAccount = undefined
  @Local selectedFromAccount?: BalanceAccount = this.fromAccount
  @Local selectedToAccount?: BalanceAccount = this.toAccount

  @Param onSelectChanged: (fromAccount: BalanceAccount, toAccount: BalanceAccount) => void = () => {}

  aboutToAppear(): void {
    if (!this.selectedFromAccount) {
      BalanceRepo.loadAll()
        .then((list) => {
          if (list.length > 0) {
            let account = list[0]
            this.selectedFromAccount = account
            if (this.selectedToAccount) {
              this.onSelectChanged(account, this.selectedToAccount)
            }
          }
        })
    }
  }

  build() {
    Row() {
      Text('从账户')
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .padding({ left: '24vp' })

      Column() {
        Row() {
          Image($r('app.media.ic_account'))
            .width('16vp')
            .height('16vp')
            .objectFit(ImageFit.Contain)
            .opacity(!!this.selectedFromAccount ? 1.0 : 0.5)
            .align(Alignment.Center)
            .margin({ right: '8vp' })

          if (!!this.selectedFromAccount) {
            Text(this.selectedFromAccount.name)
              .fontColor(Colors.gray1000)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Center)
              .height('33vp')
          } else {
            Text("选择账户")
              .fontColor(Colors.gray600)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Center)
              .height('33vp')
          }
        }
        .stateStyles({
          normal: { .backgroundColor(AppConfig.defaultBgColor) },
          pressed: { .backgroundColor(Colors.gray200) },
          focused: { .backgroundColor(Colors.gray200) },
        })
        .alignItems(VerticalAlign.Center)
        .width('100vp')

        Divider().vertical(false).strokeWidth('1vp')
          .color(Colors.gray600)
      }
      .width('100vp')
      .height('34vp')
      .flexGrow(1)
      .margin({ left: '8vp' })
      .onClick(() => {
        this.onClickSelect((account) => {
          this.selectedFromAccount = account
        })
      })

      Text('转入到账户')
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .margin({ left: '8vp' })

      Column() {
        Row() {
          Image($r('app.media.ic_account'))
            .width('16vp')
            .height('16vp')
            .objectFit(ImageFit.Contain)
            .opacity(!!this.selectedToAccount ? 1.0 : 0.5)
            .align(Alignment.Center)
            .margin({ right: '8vp' })

          if (!!this.selectedToAccount) {
            Text(this.selectedToAccount.name)
              .fontColor(Colors.gray1000)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Center)
              .height('33vp')
          } else {
            Text("选择账户")
              .fontColor(Colors.gray600)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Center)
              .height('33vp')
          }
        }
        .stateStyles({
          normal: { .backgroundColor(AppConfig.defaultBgColor) },
          pressed: { .backgroundColor(Colors.gray200) },
          focused: { .backgroundColor(Colors.gray200) },
        })
        .alignItems(VerticalAlign.Center)
        .width('100vp')

        Divider().vertical(false).strokeWidth('1vp')
          .color(Colors.gray600)
      }
      .height('34vp')
      .width('100vp')
      .flexGrow(1)
      .margin({ left: '8vp', right: '24vp' })
      .onClick(() => {
        this.onClickSelect((account) => {
          this.selectedToAccount = account
        })
      })
    }
    .width(Dimensions.FULL_PARENT)
    .margin({ top: '12vp' })
  }

  private async onClickSelect(callback: (account: BalanceAccount) => void) {
    let balanceAccounts = await BalanceRepo.loadAll()
    let sheets = new Array<SheetInfo>()
    balanceAccounts.forEach((item) => {
      let sheet = BalanceAccount.toSheet(item, (account) => {
        callback(account)
        if (this.selectedFromAccount && this.selectedToAccount) {
          this.onSelectChanged(this.selectedFromAccount, this.selectedToAccount)
        }
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