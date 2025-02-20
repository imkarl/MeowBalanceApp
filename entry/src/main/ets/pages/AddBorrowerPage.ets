import { ConfigurationConstant } from '@kit.AbilityKit'
import { router, window } from '@kit.ArkUI'
import StatusBarUtil from '../common/ui/StatusBarUtil'
import AppUtil from '../common/utils/AppUtil'
import AppConfig from '../common/AppConfig'
import Colors from '../common/utils/Colors'
import Dimensions from '../common/utils/Dimensions'
import InputMethod from '../common/ui/InputMethod'
import BorrowerAccountType from '../common/enums/BorrowerAccountType'
import toast, { toastError } from '../common/ui/Toast'
import Http from '../common/utils/Http'
import BorrowerAccount from '../common/entitys/BorrowerAccount'

@Extend(TextInput)
function inputStyle() {
  .placeholderColor(Colors.placeholder_color)
  .height(Dimensions.inputHeight)
  .fontSize('18vp')
  .fontColor(Colors.black)
  .width('50%')
  .flexGrow(1)
  .padding({ left: Dimensions.input_padding_left })
  .margin({ top: Dimensions.input_margin_top })
  .textAlign(TextAlign.Start)
}

/**
 * 添加借贷人
 */
@Entry
@Component
struct AddBorrowerPage {

  private statusBarHeight: number = 0

  private accountType: BorrowerAccountType = (router.getParams() as AddBorrowerPageParams).accountType

  @State accountName: string = ""
  @State remark: string = ""

  async aboutToAppear() {
    this.statusBarHeight = await AppUtil.getStatusBarHeight()

    let win = await window.getLastWindow(getContext(this))
    StatusBarUtil.setImmersion(win, ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r("app.media.ic_topnav_back"))
            .width('24vp')
            .height('24vp')
          Text(`添加${this.accountType==BorrowerAccountType.CREDIT ? '借贷人' : '出借方'}`)
            .fontColor(Colors.black)
            .fontSize(Dimensions.topnav_text_size)
        }
        .height('50vp')
        .onClick(() => {
          router.back()
        })

        Row().flexGrow(1)

        Text("完成")
          .fontColor(Colors.blue800)
          .fontSize(Dimensions.topnav_text_size)
          .width("56vp")
          .height('50vp')
          .onClick(() => {
            this.doSubmit()
          })
      }
      .width(Dimensions.FULL_PARENT)
      .padding({ top: `${px2vp(this.statusBarHeight)}vp` })
      .backgroundColor(Colors.white)

      Row() {
        Text(`${this.accountType==BorrowerAccountType.CREDIT ? '借贷人' : '出借方'}：`)
          .fontColor(Colors.gray800)
          .fontSize(Dimensions.normal_text_size)
          .textAlign(TextAlign.JUSTIFY)
          .margin({ left: '12vp' })

        TextInput({ placeholder: '请输入2到10个字符', text: this.accountName })
          .maxLength(10)
          .type(InputType.USER_NAME)
          .inputStyle()
          .margin({ right: '12vp' })
          .onChange((value: string) => {
            this.accountName = value;
          })
      }
      .width(Dimensions.FULL_PARENT)
      .margin({ top: '12vp' })
      .backgroundColor(Colors.white)

      Row() {
        Text('备　注：')
          .fontColor(Colors.gray800)
          .fontSize(Dimensions.normal_text_size)
          .textAlign(TextAlign.JUSTIFY)
          .margin({ left: '12vp' })

        TextInput({ placeholder: '请输入备注', text: this.remark })
          .maxLength(20)
          .type(InputType.Normal)
          .inputStyle()
          .margin({ right: '12vp' })
          .onChange((value: string) => {
            this.remark = value
          })
      }
      .width(Dimensions.FULL_PARENT)
      .margin({ top: '12vp' })
      .backgroundColor(Color.White)
    }
    .width(Dimensions.FULL_PARENT)
    .height(Dimensions.FULL_PARENT)
    .backgroundColor(AppConfig.defaultBgColor)
  }

  async doSubmit() {
    InputMethod.hideSoftKeyboard()

    if (this.accountName === '' || this.accountName.trim().length == 0) {
      toast(`${this.accountType==BorrowerAccountType.CREDIT ? '借贷人' : '出借方'}名称不能为空`);
      return;
    }

    Http.post<void>(
      "/v1/borrower/create",
      {
        type: this.accountType,
        name: this.accountName,
        remark: this.remark,
      }
    ).then(() => {
      toast("添加成功")
      BorrowerAccount.clearCache()
      router.back()
    }).catch((error: object) => {
      toastError(error)
    })
  }

}

export class AddBorrowerPageParams {
  accountType: BorrowerAccountType = BorrowerAccountType.DEBIT
}
