import Balance from '../common/entitys/Balance'
import Http from '../common/utils/Http'
import UserManager from '../common/utils/UserManager'
import AppConfig from '../common/AppConfig'
import Colors from '../common/utils/Colors'
import Dimensions from '../common/utils/Dimensions'
import UserInfo from '../common/entitys/UserInfo'
import AppUtil from '../common/utils/AppUtil'
import Settings from '../common/ui/Settings'
import Constants from '../common/utils/Constants'
import AssetsChartView from './me/AssetsChartView'
import CashFlowRepo, { MonthCountResult, YearCountResult } from '../model/CashFlowRepo'
import { router } from '@kit.ArkUI'

@Preview
@ComponentV2
export default struct MePage {

  @Local private statusBarHeight: number = 0

  // 余额
  @Local balance: Balance = new Balance()
  @Local userInfo: UserInfo = new UserInfo()

  /**
   * 是否隐藏金额
   */
  @Local hiddenBalance: boolean = true

  @Local monthCounts: Array<MonthCountResult> = new Array()
  @Local maxMoney: number = 100

  @Local private isRefreshing: boolean = false

  async aboutToAppear() {
    this.statusBarHeight = await AppUtil.getStatusBarHeight()
    this.hiddenBalance = await Settings.get(Constants.IS_HIDDEN_BALANCE, this.hiddenBalance)
    this.refresh()
  }

  async refresh() {
    if (this.isRefreshing) {
      return
    }

    this.isRefreshing = true

    this.monthCounts = CashFlowRepo.getLast12MonthCount()
    this.maxMoney = CashFlowRepo.getMaxMoney(this.monthCounts)

    Http.get<Balance>("/v1/balance/detail")
      .then((json) => {
        this.balance = new Balance(json)
      })
      .finally(() => {
        setTimeout(() => {
          this.isRefreshing = false
        }, 300)
      })

    this.userInfo = await UserManager.getUserInfo() || this.userInfo
  }

  build() {
    Column() {
      Refresh({ refreshing: this.isRefreshing }) {
        Stack({ alignContent: Alignment.TopStart }) {
          Row()
            .width("100%")
            .height(`${px2vp(this.statusBarHeight) + 180}vp`)
            .backgroundColor(Colors.blue600)

          Column() {
            Row() {
              Image($r('app.media.ic_avatar_default'))
                .width('50vp')
                .height('50vp')
                .border({ radius: '25vp' })
                .margin({ left: '12vp', top: '6vp' })

              Text(`${this.userInfo.nickname}`)
                .height('50vp')
                .margin({ left: '10vp' })
                .fontColor(Colors.white)
                .fontSize(Dimensions.title_text_size)
            }
            .align(Alignment.Start)
            .width(Dimensions.FULL_PARENT)
            .onClick(() => {
              router.pushUrl({ url: 'pages/AboutPage' })
            })

            Row() {
              Text('我的净资产：')
                .fontColor(Colors.white)
                .fontSize(Dimensions.little_text_size)
                .margin({ left: '30vp' })
              Image(this.hiddenBalance ? $r('app.media.ic_eye_off_white') : $r('app.media.ic_eye_white'))
                .width('16vp')
                .height('16vp')
                .onClick(() => {
                  this.hiddenBalance = !this.hiddenBalance
                  Settings.put(Constants.IS_HIDDEN_BALANCE, this.hiddenBalance)
                })
            }
            .width(Dimensions.FULL_PARENT)
            .align(Alignment.Start)
            .margin({ top: '20vp' })

            Row() {
              Text() {
                Span(this.hiddenBalance ? '*' : this.formatMoney(this.balance.calculateNetAssets())).fontSize(Dimensions.title_text_size)
                Span('元').fontSize(Dimensions.little_text_size)
              }
              .width(this.hiddenBalance ? '100vp' : Dimensions.FULL_PARENT)
              .alignSelf(ItemAlign.Start)
              .margin({ left: '30vp', top: '8vp' })
              .fontColor(this.hiddenBalance ? Colors.transparent : Colors.white)
              .backgroundColor(this.hiddenBalance ? Colors.gray300 : Colors.transparent)
            }
            .width(Dimensions.FULL_PARENT)
            .alignSelf(ItemAlign.Start)

            AssetsChartView({
              monthCounts: this.monthCounts,
              maxMoney: this.maxMoney
            })

            Column() {
              Text(`版本：${AppUtil.getBundleInfo().versionName}`)
                .fontColor(Colors.gray900)
                .fontSize(Dimensions.content_text_size)
                .padding({ left: '20vp', right: '20vp' })
                .width(Dimensions.FULL_PARENT)
                .height('44vp')

              Row()
                .backgroundColor(AppConfig.defaultBgColor)
                .width(Dimensions.FULL_PARENT)
                .height('1vp')

              Row() {
                Text(`意见反馈`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ left: '20vp' })
                  .flexGrow(1)

                Text(`>`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ right: '20vp' })
              }
              .alignItems(VerticalAlign.Center)
              .width(Dimensions.FULL_PARENT)
              .height('44vp')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebPage',
                  params: {
                    url: 'https://www.wjx.cn/vm/wFOct8w.aspx',
                    title: '意见反馈'
                  }
                })
              })

              Row()
                .backgroundColor(AppConfig.defaultBgColor)
                .width(Dimensions.FULL_PARENT)
                .height('1vp')

              Row() {
                Text(`隐私政策`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ left: '20vp' })
                  .flexGrow(1)

                Text(`>`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ right: '20vp' })
              }
              .alignItems(VerticalAlign.Center)
              .width(Dimensions.FULL_PARENT)
              .height('44vp')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/WebPage',
                  params: {
                    url: 'https://agreement-drcn.hispace.dbankcloud.cn/index.html?lang=zh&agreementId=1624659188917478656',
                    title: '隐私政策'
                  }
                })
              })

              Row()
                .backgroundColor(AppConfig.defaultBgColor)
                .width(Dimensions.FULL_PARENT)
                .height('1vp')

              Row() {
                Text(`关于`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ left: '20vp' })
                  .flexGrow(1)

                Text(`>`)
                  .fontColor(Colors.gray900)
                  .fontSize(Dimensions.content_text_size)
                  .margin({ right: '20vp' })
              }
              .alignItems(VerticalAlign.Center)
              .width(Dimensions.FULL_PARENT)
              .height('44vp')
              .onClick(() => {
                router.pushUrl({ url: 'pages/AboutPage' })
              })
            }
            .backgroundColor(Colors.white)
            .margin({ top: '24vp', left: '12vp', right: '12vp' })
            .border({ radius: '8vp' })
          }
          .width(Dimensions.FULL_PARENT)
          .margin({ top: `${px2vp(this.statusBarHeight)}vp` })
        }
        .height("100%")
        .backgroundColor(AppConfig.defaultBgColor)
      }
      .width(Dimensions.FULL_PARENT)
      .height(Dimensions.FULL_PARENT)
      .backgroundColor(Colors.blue600)
      .onRefreshing(() => {
        this.refresh()
      })
    }
    .width(Dimensions.FULL_PARENT)
    .height(Dimensions.FULL_PARENT)
  }

  formatMoney(number: number): string {
    let value = number.toString()
    if (value.indexOf(".") >= 0) {
      value = number.toFixed(2)
    }
    if (number >= 0) {
      value = `+${value}`
    }
    return value
  }

}