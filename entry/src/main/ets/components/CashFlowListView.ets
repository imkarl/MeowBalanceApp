import AppConfig from '../common/AppConfig'
import CashFlow from '../common/entitys/CashFlow'
import CashFlowDataSource from '../model/CashFlowDataSource'
import AppUtil from '../common/utils/AppUtil'

import Colors from '../common/utils/Colors'
import Dimensions from '../common/utils/Dimensions'
import { CashFlowListItemView } from './cashflow/list/CashFlowListItemView'
import { CashFlowListMonthItemView } from './cashflow/list/CashFlowListMonthItemView'
import MonthCashFlows from '../common/entitys/MonthCashFlows'
import { router } from '@kit.ArkUI'

@Preview
@Component
export default struct CashFlowListView {

  @State private dataSource: CashFlowDataSource = new CashFlowDataSource()
  @State private isRefreshing: boolean = false
  @State private statusBarHeight: number = 0

  IN_LIST_ITEM_AREA = 1
  IN_FOOTER_AREA = 3

  async aboutToAppear() {
    this.statusBarHeight = await AppUtil.getStatusBarHeight()

    this.dataSource.onRefreshingChanged = (isRefreshing) => {
      this.isRefreshing = isRefreshing
    }
    this.dataSource.refresh()
  }

  build() {
    Column() {
      Row() {
        Row() {
          Text("账单")
            .fontColor(Colors.black)
            .fontSize(Dimensions.topnav_text_size)
            .margin({ left: '24vp' })
        }
        .height('50vp')
      }
      .width("100%")
      .height('50vp')
      .margin({ top: `${px2vp(this.statusBarHeight)}vp` })

      Refresh({ refreshing: this.isRefreshing }) {
        if (this.dataSource.totalCount() == 0) {
          Column() {
            Blank().flexGrow(1)

            if (this.isRefreshing || this.dataSource.isRefreshing) {
              Text('数据加载中...')
                .fontSize(Dimensions.normal_text_size)
                .fontColor(Colors.gray600)
                .align(Alignment.Bottom)
            } else {
              Text('还没有账单，快去添加账单吧~')
                .fontSize(Dimensions.normal_text_size)
                .fontColor(Colors.gray800)
                .align(Alignment.Bottom)

              Button("记一笔", { type: ButtonType.Capsule })
                .width('110vp')
                .height('40vp')
                .fontSize(Dimensions.normal_text_size)
                .fontWeight(FontWeight.Medium)
                .backgroundColor(Colors.blue600)
                .margin({ top: '12vp', bottom: '20vp' })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/AddCashFlowPage' })
                })
            }

            Blank().flexGrow(1)
          }
          .width(Dimensions.FULL_PARENT)
          .height(Dimensions.FULL_PARENT)
          .alignItems(HorizontalAlign.Center)

        } else {
          List() {
            LazyForEach(this.dataSource, (item: MonthCashFlows, index) => {
              ListItemGroup({
                style: ListItemGroupStyle.NONE,
                header: this.itemHeader(item),
                footer: this.itemFooter(item)
              }) {
                ForEach(item.cashflows, (item: CashFlow, index) => {
                  CashFlowListItemView({ cashflow: item })
                })
              }
              .width("100%")
              .padding({ left: '12vp', right: '12vp', bottom: '12vp' })
            }, (item: CashFlow) => {
              return item.id
            })
          }
          .width(Dimensions.FULL_PARENT)
          .height(Dimensions.FULL_PARENT)
          .edgeEffect(EdgeEffect.None)
          .sticky(StickyStyle.Header)
          .onScrollVisibleContentChange((start, end) => {
            if (end && end.index == this.dataSource.totalCount() - 1) {
              if (end.itemGroupArea == this.IN_FOOTER_AREA
                || (end.itemGroupArea == this.IN_LIST_ITEM_AREA && (!end.itemIndexInGroup || end.itemIndexInGroup >= this.dataSource.getCashFlowCount()))) {
                this.dataSource.loadmore()
              }
            }
          })
        }
      }
      .height('50%')
      .flexGrow(1)
      .margin({ bottom: '8vp' })
      .onRefreshing(() => {
        if (this.isRefreshing) {
          return
        }
        this.isRefreshing = true
        this.dataSource.refresh()
      })
    }
    .height(Dimensions.FULL_PARENT)
    .backgroundColor(AppConfig.defaultBgColor)
  }

  @Builder
  itemHeader(monthCashFlows: MonthCashFlows) {
    CashFlowListMonthItemView({ monthCashFlows: monthCashFlows })
  }

  @Builder
  itemFooter(monthCashFlows: MonthCashFlows) {
    Row()
      .width(Dimensions.FULL_PARENT)
      .height('6vp')
      .backgroundColor(Colors.white)
      .border({ radius: { bottomLeft: '12vp', bottomRight: '12vp' } })
  }

}
