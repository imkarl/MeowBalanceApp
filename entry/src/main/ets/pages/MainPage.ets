import CashFlowListView from '../components/CashFlowListView'
import MePage from '../components/MePage'
import { common, ConfigurationConstant } from '@kit.AbilityKit'
import Colors from '../common/utils/Colors'
import Dimensions from '../common/utils/Dimensions'
import AppConfig from '../common/AppConfig'
import { router, window } from '@kit.ArkUI'
import StatusBarUtil from '../common/ui/StatusBarUtil'
import UserManager from '../common/utils/UserManager'

@Extend(Text)
function textStyle(selected: boolean) {
  .fontSize(selected ? Dimensions.normal_text_size : Dimensions.small_text_size)
  .fontWeight(selected ? FontWeight.Bold : FontWeight.Normal)
  .fontColor(selected ? Colors.black : Colors.gray)
  .height('60vp')
  .textAlign(TextAlign.Center)
  .flexGrow(2)
}

@Entry
@Component
struct MainPage {

  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext

  @State visibleIndex: number = 0

  async aboutToAppear(): Promise<void> {
    let isLogin = await UserManager.isLogin();
    if (!isLogin) {
      router.replaceUrl({ url: "pages/LoginPage" })
      return
    }

    let win = await window.getLastWindow(getContext(this))
    StatusBarUtil.setImmersion(win, ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      // 根布局
      Stack({ alignContent: Alignment.Bottom }) {
        Stack({ alignContent: Alignment.TopStart }) {
          // 主体内容-账单
          CashFlowListView()
            .visibility(this.visibleIndex==0 ? Visibility.Visible : Visibility.Hidden)

          if (this.visibleIndex == 2) {
            // 主体内容-我的
            MePage()
          }
        }
        .height("100%")
        .padding({ bottom: 55 })

        // 底部菜单背景
        Row() {
          Image($r('app.media.bg_tabbar'))
            .objectFit(ImageFit.Fill)
            .height('60vp')
            .width('100%')
        }
        .backgroundColor(AppConfig.defaultBgColor)
        // 底部导航菜单
        Row() {
          Text("账单")
            .textStyle(this.visibleIndex == 0)
            .onClick(() => {
              this.onTabChanged(0)
            })

          Row().width('80vp')

          Text("我的")
            .textStyle(this.visibleIndex == 2)
            .onClick(() => {
              this.onTabChanged(2)
            })
        }
        .alignItems(VerticalAlign.Bottom)
        .width('100%')
        // 底部中间按钮
        Image($r('app.media.ic_tabbar_add'))
          .objectFit(ImageFit.Fill)
          .align(Alignment.Center)
          .width('80vp')
          .height('70vp')
          .margin({ bottom: '30vp' })
          .onClick(() => {
            router.pushUrl({ url: 'pages/AddCashFlowPage' })
          })
      }
      .flexGrow(1)
      .width('100%')
    }
    .width('100%')
    .backgroundColor(AppConfig.defaultBgColor)
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.Pop, duration: 300 })
    PageTransitionExit({ type: RouteType.Push, duration: 300 })
  }

  onTabChanged(index: number) {
    if (this.visibleIndex == index) {
      return
    }
    this.visibleIndex = index
  }

}
