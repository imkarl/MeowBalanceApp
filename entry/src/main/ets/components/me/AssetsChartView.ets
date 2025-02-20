import Colors from '../../common/utils/Colors'
import Dimensions from '../../common/utils/Dimensions'
import { MonthCountResult, YearCountResult } from '../../model/CashFlowRepo'
import { LengthMetrics } from '@kit.ArkUI'

/**
 * 资产波动图
 */
@ComponentV2
export default struct AssetsChartView {

  @Param monthCounts: Array<MonthCountResult> = new Array()
  @Param maxMoney: number = 100

  build() {
    Column() {
      Text('净资产波动图：')
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.little_text_size)
        .alignSelf(ItemAlign.Start)
        .margin({ left: '12vp'})

      Stack() {
        Column() {
          Divider()
            .border({
              style: BorderStyle.Dashed,
              width: '0.5vp',
              color: Colors.gray200,
              dashGap: LengthMetrics.vp(4),
              dashWidth: LengthMetrics.vp(4),
            })
            .height('0.5vp')
            .margin({ top: '8vp' })

          // 收入
          Row() {
            Text().width('18vp')

            ForEach(
              this.monthCounts,
              (monthCount: MonthCountResult) => {
                Column() {
                  Row()
                    .width('6vp')
                    .height(`${60.0 * monthCount.income / this.maxMoney}vp`)
                    .border({ radius: '6vp' })
                    .backgroundColor('#27C346')
                }
                .width('6vp')
                .flexGrow(1)
                .alignItems(HorizontalAlign.Center)
              }
            )

            Text().width('18vp')
          }
          .width(Dimensions.FULL_PARENT)
          .height('60vp')
          .alignItems(VerticalAlign.Bottom)

          Divider()
            .color(Colors.gray200)
            .strokeWidth('1vp')

          // 支出
          Row() {
            Text().width('18vp')

            ForEach(
              this.monthCounts,
              (monthCount: MonthCountResult) => {
                Column() {
                  Row()
                    .width('6vp')
                    .height(`${60.0 * Math.abs(monthCount.expense) / this.maxMoney}vp`)
                    .border({ radius: '6vp' })
                    .backgroundColor('#F99E93')
                }
                .width('6vp')
                .flexGrow(1)
                .alignItems(HorizontalAlign.Center)
              }
            )

            Text().width('18vp')
          }
          .width(Dimensions.FULL_PARENT)
          .height('60vp')
          .alignItems(VerticalAlign.Top)

          Divider()
            .border({
              style: BorderStyle.Dashed,
              width: '0.5vp',
              color: Colors.gray200,
              dashGap: LengthMetrics.vp(4),
              dashWidth: LengthMetrics.vp(4),
            })
            .height('0.5vp')
        }
        .width(Dimensions.FULL_PARENT)

        Column() {
          Text("收入")
            .fontColor(Colors.gray600)
            .fontSize(Dimensions.little_text_size)
            .margin({ top: '12vp'})

          Text().flexGrow(1)

          Text("支出")
            .fontColor(Colors.gray600)
            .fontSize(Dimensions.little_text_size)
            .margin({ bottom: '4vp'})
        }
        .width(Dimensions.FULL_PARENT)
        .height('120vp')
        .alignItems(HorizontalAlign.End)
      }
      .width(Dimensions.FULL_PARENT)

      // 月份
      Row() {
        Text().width('18vp')

        ForEach(
          this.monthCounts,
          (monthCount: MonthCountResult) => {
            Column() {
              Text(`${monthCount.month}月`)
                .fontColor(Colors.gray800)
                .fontSize('9vp')
                .textAlign(TextAlign.Center)
            }
            .width('6vp')
            .flexGrow(1)
            .alignItems(HorizontalAlign.Center)
          }
        )

        Text().width('18vp')
      }
      .width(Dimensions.FULL_PARENT)
      .margin({ top: '6vp' })
      .alignItems(VerticalAlign.Top)
    }
    .backgroundColor(Colors.white)
    .margin({ top: '12vp', left: '12vp', right: '12vp' })
    .padding({ top: '8vp', bottom: '8vp' })
    .border({ radius: '8vp' })
    .shadow({
      radius: 14,
      offsetY: 14,
      color: '#0D000000'
    })
  }

}