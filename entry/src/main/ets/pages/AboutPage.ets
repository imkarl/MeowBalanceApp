import InputMethod from '../common/ui/InputMethod';
import Colors from '../common/utils/Colors';
import { router, window } from '@kit.ArkUI';
import Dimensions from '../common/utils/Dimensions';
import Constants from '../common/utils/Constants';
import AppConfig from '../common/AppConfig';
import UserManager from '../common/utils/UserManager';
import StatusBarUtil from '../common/ui/StatusBarUtil';
import { common, ConfigurationConstant } from '@kit.AbilityKit';
import AppUtil from '../common/utils/AppUtil';

/**
 * 关于页
 */
@Entry
@ComponentV2
struct AboutPage {

  @Local private statusBarHeight: number = 0

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
          Text('关于')
            .fontColor(Colors.black)
            .fontSize(Dimensions.topnav_text_size)
        }
        .height('50vp')
        .onClick(() => {
          router.back()
        })
      }
      .width(Dimensions.FULL_PARENT)
      .alignItems(VerticalAlign.Center)
      .padding({ top: `${px2vp(this.statusBarHeight)}vp` })
      .backgroundColor(Colors.white)

      Image($r('app.media.startIcon'))
        .width('78vp')
        .height('78vp')
        .margin({
          top: '80vp',
          bottom: '8vp'
        })
      Text($r('app.string.EntryAbility_label'))
        .fontSize(Dimensions.title_text_size)
        .fontColor(Colors.gray1000)
      Text($r('app.string.EntryAbility_desc'))
        .fontSize(Dimensions.normal_text_size)
        .fontColor(Colors.gray800)
        .margin({
          top: '24vp',
          bottom: '28vp'
        })

      Button("退出登录", { type: ButtonType.Capsule })
        .width(Constants.BUTTON_WIDTH)
        .height('40vp')
        .fontSize(Dimensions.normal_text_size)
        .fontWeight(FontWeight.Medium)
        .backgroundColor('#0A59F7')
        .margin({
          top: '58vp',
          bottom: '12vp'
        })
        .onClick(() => {
          this.logout();
        })
    }
    .width(Dimensions.FULL_PARENT)
    .height(Dimensions.FULL_PARENT)
    .backgroundColor(AppConfig.defaultBgColor)
  }

  async logout() {
    await UserManager.logout()
    router.clear()
    router.replaceUrl({ url: "pages/LoginPage" })
  }

}
