import AppConfig from '../../../common/AppConfig'
import { ActionSheetDialog } from '../../../common/dialog/ActionSheetDialog'
import BorrowerAccount from '../../../common/entitys/BorrowerAccount'
import BorrowerAccountType from '../../../common/enums/BorrowerAccountType'
import InputMethod from '../../../common/ui/InputMethod'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { router } from '@kit.ArkUI'
import { TypeName } from './SubTypeSelectView'

/**
 * 借贷人选择控件
 */
@ComponentV2
export default struct BorrowerSelectView {

  @Param accountType: BorrowerAccountType = BorrowerAccountType.DEBIT
  @Param initAccount?: BorrowerAccount = undefined
  @Local selectedAccount: Map<BorrowerAccountType, BorrowerAccount> = new Map()
  @Param onSelectChanged: (account: BorrowerAccount|undefined) => void = () => {}

  @Param typeNames: Map<BorrowerAccountType, TypeName> = new Map()

  aboutToAppear(): void {
    if (!this.selectedAccount.has(this.accountType)) {
      BorrowerAccount.load(this.accountType)
        .then((list) => {
          if (list.length > 0) {
            list.forEach((item) => {
              if (!this.selectedAccount.has(item.type)) {
                this.selectedAccount.set(item.type, item)
              }
            })

            let account = this.selectedAccount.get(this.accountType)
            this.onSelectChanged(account)
          }
        })
    }
  }

  build() {
    Row() {
      Image($r('app.media.ic_borrower'))
        .width('16vp')
        .height('16vp')
        .objectFit(ImageFit.Contain)
        .align(Alignment.Center)

      Column() {
        Text(`${this.typeNames.get(this.accountType)?.name}：`)
          .fontColor(Colors.gray800)
          .fontSize(Dimensions.content_text_size)

        Text(`${this.typeNames.get(this.accountType)?.description}`)
          .fontColor(Colors.gray800)
          .fontSize(Dimensions.little_text_size)
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: '4vp' })

      Row() {
        Row() {
          if (this.selectedAccount.has(this.accountType)) {
            Text(this.selectedAccount.get(this.accountType)?.name)
              .fontColor(Colors.gray1000)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Start)
              .height('33vp')
          } else {
            Text(`请选择${this.typeNames.get(this.accountType)?.name}...`)
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
    let accounts = await BorrowerAccount.loadAll()
    let sheets = new Array<SheetInfo>()
    accounts
      .forEach((item) => {
        if (item.type.toLowerCase() == this.accountType.toLowerCase()) {
          let sheet = BorrowerAccount.toSheet(item, (account) => {
            this.selectedAccount.set(this.accountType, account)
            this.onSelectChanged(account)
            this.dialog?.close()
          })
          sheets.push(sheet)
        }
      })
    this.showBottomDialog(
      `选择${this.typeNames.get(this.accountType)?.name}`,
      sheets,
      () => {
        this.hideBottomDialog()
        router.pushUrl({
          url: 'pages/AddBorrowerPage',
          params: {
            accountType: this.accountType
          }
        })
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
        rightIcon: $r('app.media.ic_operation_add'),
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

  private hideBottomDialog() {
    if (this.dialog != undefined) {
      this.dialog?.close()
    }
  }

}