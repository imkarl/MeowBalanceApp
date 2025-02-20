import CashFlow from '../../../common/entitys/CashFlow'
import FlowType from '../../../common/enums/FlowType'
import Colors from '../../../common/utils/Colors'
import Dates from '../../../common/utils/Dates'
import Dimensions from '../../../common/utils/Dimensions'

@ComponentV2
export struct CashFlowListItemView {

  @Param cashflow?: CashFlow = undefined
  @Local private icon: Resource|string = ""

  aboutToAppear(): void {
    if (!this.cashflow) {
      return
    }

    switch (this.cashflow.type.toString().toLowerCase()) {
      case FlowType.EXPENSE:
        this.icon = $r("app.media.ic_flowtype_expense")
        break
      case FlowType.INCOME:
        this.icon = $r("app.media.ic_flowtype_income")
        break
      case FlowType.BORROW:
        this.icon = $r("app.media.ic_flowtype_borrow")
        break
      case FlowType.LEND:
        this.icon = $r("app.media.ic_flowtype_lend")
        break
      case FlowType.REFUND:
        this.icon = $r("app.media.ic_flowtype_refund")
        break
      case FlowType.RECEIPT:
        this.icon = $r("app.media.ic_flowtype_receipt")
        break
      case FlowType.TRANSFER:
        this.icon = $r("app.media.ic_flowtype_transfer")
        break
      case FlowType.ADJUST:
        this.icon = $r("app.media.ic_flowtype_adjust")
        break
    }
  }

  build() {
    if (this.cashflow) {
      Column() {
        if (this.cashflow.showDate) {
          Text(Dates.format(this.cashflow.eventTime, this.cashflow.showYear ? 'yyyy年MM月dd日' : 'M月d日'))
            .fontColor(Colors.gray800)
            .fontSize('14vp')
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
            .alignSelf(ItemAlign.Start)
            .padding({ left: '12vp', top: '12vp' })
        }

        Row() {
          Image(this.icon)
            .objectFit(ImageFit.Contain)
            .width('40vp')
            .height('40vp')
            .backgroundColor(Colors.gray300)
            .borderRadius('6vp')

          Column() {
            Text((this.cashflow.type.toLowerCase() != FlowType.ADJUST.toLowerCase() && this.cashflow.title && this.cashflow.title.length > 0) ? this.cashflow.title : this.getFlowTypeName(this.cashflow.type))
              .fontColor(Colors.gray1000)
              .fontSize('14vp')
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Start)
              .align(Alignment.Start)
              .alignSelf(ItemAlign.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            if (this.cashflow.description && this.cashflow.description.length > 0) {
              Text(this.cashflow.description)
                .fontColor(Colors.gray800)
                .fontSize('12vp')
                .textAlign(TextAlign.Start)
                .align(Alignment.Start)
                .alignSelf(ItemAlign.Start)
                .lineHeight('15vp')
                .padding({ top: '2vp' })
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
          }
          .width('60%')
          .flexGrow(1)
          .padding({ left: '10vp', top: this.cashflow.description.length > 0 ? '2vp' : '4vp' })

          Column() {
            Text() {
              if (this.cashflow.type.toLowerCase() == FlowType.ADJUST.toLowerCase() && this.cashflow.title.length > 0) {
                Span(`余额 `)
                  .fontColor(Colors.blue600)
                  .fontSize(Dimensions.little_text_size)
                Span(this.cashflow.title)
                  .fontColor(Colors.blue600)
              } else {
                Span(this.formatMoney(this.cashflow.totalAmount))
                  .fontColor((this.cashflow.totalAmount >= 0) ? Colors.success600 : Colors.wraning600)
              }
            }
            .fontSize(Dimensions.small_text_size)
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text(this.cashflow.account.name)
              .fontColor(Colors.gray800)
              .fontSize(Dimensions.little_text_size)
              .padding({ top: '2vp' })
              .textAlign(TextAlign.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .alignItems(HorizontalAlign.End)
          .width('100vp')
          .padding({ left: '2vp', right: '12vp', top: '2vp' })
        }
        .alignItems(VerticalAlign.Top)
        .alignSelf(ItemAlign.Start)
        .align(Alignment.TopStart)
        .width(Dimensions.FULL_PARENT)
        .padding({ left: '20vp', top: '6vp' })
      }
      .width(Dimensions.FULL_PARENT)
      .backgroundColor(Colors.white)
    }
  }

  private formatMoney(number: number): string {
    let value = number.toString()
    if (value.indexOf(".") >= 0) {
      value = number.toFixed(2)
    }
    if (number >= 0) {
      value = `+${value}`
    }
    return value
  }

  private getFlowTypeName(type: FlowType): string {
    let name = ""
    switch (type.toString().toLowerCase()) {
      case FlowType.EXPENSE:
        name = "支出"
        break

      case FlowType.INCOME:
        name = "收入"
        break

      case FlowType.BORROW:
        name = "借入"
        break

      case FlowType.LEND:
        name = "借出"
        break

      case FlowType.REFUND:
        name = "还款（还给他人）"
        break

      case FlowType.RECEIPT:
        name = "收款（还钱给我）"
        break

      case FlowType.TRANSFER:
        name = "转账"
        break

      case FlowType.ADJUST:
        name = "余额调整"
        break
    }

    return name
  }

}