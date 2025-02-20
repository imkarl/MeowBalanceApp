import AppConfig from '../../../common/AppConfig'
import MonthCashFlows from '../../../common/entitys/MonthCashFlows'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'

@ComponentV2
export struct CashFlowListMonthItemView {

  @Param monthCashFlows?: MonthCashFlows = undefined
  private nowDate = new Date(Date.now())

  aboutToAppear(): void {
    if (!this.monthCashFlows) {
      return
    }
  }

  build() {
    if (this.monthCashFlows) {
      Column() {
        Row() {
          Column() {
            Text() {
              Span(`${this.monthCashFlows.month}`)
                .fontSize(Dimensions.topnav_text_size)
                .fontWeight(FontWeight.Medium)
              Span("月")
                .fontSize(Dimensions.little_text_size)
            }
            .align(Alignment.Start)
            .textAlign(TextAlign.Start)
            .fontColor(Colors.gray800)
            .margin({
              top: this.monthCashFlows.year != this.nowDate.getFullYear() ? '8vp' : '14vp'
            })

            if (this.monthCashFlows.year != this.nowDate.getFullYear()) {
              Text(`${this.monthCashFlows.year}年`)
                .align(Alignment.TopStart)
                .textAlign(TextAlign.Start)
                .fontColor(Colors.gray600)
                .fontSize(Dimensions.little_text_size)
            }
          }
          .height(Dimensions.FULL_PARENT)
          .alignItems(HorizontalAlign.Start)
          .align(Alignment.End)
          .padding({ left: '12vp' })

          Column() {
            Text() {
              Span("月结余 ")
                .fontSize(Dimensions.little_text_size)
                .fontColor(Colors.gray600)
              Span(`${(this.monthCashFlows.income - this.monthCashFlows.expense).toFixed(2)}`)
                .fontSize(Dimensions.small_text_size)
                .fontColor(Colors.gray800)
            }
            .width(Dimensions.FULL_PARENT)
            .align(Alignment.End)
            .alignSelf(ItemAlign.End)
            .textAlign(TextAlign.End)
            .margin({ top: '8vp', right: '12vp' })

            Text() {
              Span("收入 ")
                .fontSize(Dimensions.little_text_size)
                .fontColor(Colors.success700)
              Span(`${this.monthCashFlows.income.toFixed(2)}`)
                .fontSize(Dimensions.small_text_size)
                .fontColor(Colors.success700)
                .margin({ left: '2vp' })

              Span("  |  ")
                .fontSize(Dimensions.little_text_size)
                .fontColor(Colors.gray600)

              Span("支出 ")
                .fontSize(Dimensions.little_text_size)
                .fontColor(Colors.wraning600)
              Span(`${this.monthCashFlows.expense.toFixed(2)}`)
                .fontSize(Dimensions.small_text_size)
                .fontColor(Colors.wraning600)
                .margin({ left: '2vp' })
            }
            .width(Dimensions.FULL_PARENT)
            .align(Alignment.End)
            .alignSelf(ItemAlign.End)
            .textAlign(TextAlign.End)
            .margin({ top: '2vp', right: '12vp' })
          }
          .width('50%')
          .flexGrow(1)
          .height(Dimensions.FULL_PARENT)
          .alignSelf(ItemAlign.End)
          .alignItems(HorizontalAlign.End)
          .align(Alignment.End)
        }
        .height('50vp')
        .width(Dimensions.FULL_PARENT)
        .alignItems(VerticalAlign.Center)
        .alignSelf(ItemAlign.Center)
        .border({ radius: { topLeft: '12vp', topRight: '12vp' } })
        .backgroundColor(Colors.white)

        Divider().vertical(false).strokeWidth('1vp')
          .color(Colors.gray300)
      }
      .width(Dimensions.FULL_PARENT)
      .backgroundColor(AppConfig.defaultBgColor)
    }
  }

}