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
import { webview } from '@kit.ArkWeb'

/**
 * Web页
 */
@Entry
@Component
struct WebPage {

  private statusBarHeight: number = 0

  private params: WebPageParams = router.getParams() as WebPageParams
  private title: string = this.params.title
  private url: string = this.params.url

  private webviewController: WebviewController = new webview.WebviewController()

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
          Text(`${this.title.length > 0 ? this.title : this.url}`)
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

      Web({
        src: this.url,
        controller: this.webviewController,
        renderMode: RenderMode.ASYNC_RENDER,
      })
        .width(Dimensions.FULL_PARENT)
        .flexGrow(1)
        .backgroundColor(AppConfig.defaultBgColor)
    }
    .width(Dimensions.FULL_PARENT)
    .height(Dimensions.FULL_PARENT)
    .backgroundColor(AppConfig.defaultBgColor)
  }

}

export class WebPageParams {
  title: string = ""
  url: string = ""
}
