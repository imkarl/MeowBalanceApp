import AppConfig from '../../../common/AppConfig'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { intl } from '@kit.LocalizationKit'

/**
 * 时间选择控件
 */
@ComponentV2
export default struct DateSelectView {

  @Param initDate: Date = new Date(Date.now())
  @Local selectedDate: Date = new Date(Date.now())

  @Param onSelectChanged: (date: Date) => void = () => {}

  aboutToAppear(): void {
    this.selectedDate = this.initDate
  }

  build() {
    Row() {
      Image($r('app.media.ic_date'))
        .width('16vp')
        .height('16vp')
        .objectFit(ImageFit.Contain)
        .align(Alignment.Center)

      Text("时间：")
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .margin({ left: '4vp' })

      Row() {
        Row() {
          Text(this.formatDate(this.selectedDate))
            .fontColor(Colors.gray1000)
            .fontSize(Dimensions.content_text_size)
            .alignSelf(ItemAlign.Start)
            .height('33vp')
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
        CalendarPickerDialog.show({
          selected: this.selectedDate,
          onAccept: (value) => {
            this.selectedDate = value;
            this.onSelectChanged(value);
          }
        })
      })
    }
    .width(Dimensions.FULL_PARENT)
    .height('34vp')
    .padding({ left: '24vp', right: '24vp' })
    .margin({ top: '12vp' })
  }

  private dateFormat = new intl.DateTimeFormat('zh-Hans', { dateStyle: 'long' })
  private nowYear = new Date(Date.now()).getFullYear()
  private nowDay = this.dateFormat.format(new Date(Date.now()))
  private formatDate(date: Date): string {
    let selectedDay = this.dateFormat.format(date)
    if (selectedDay == this.nowDay) {
      return `今天（${selectedDay}）`
    } else if (date.getFullYear() == this.nowYear) {
      return selectedDay.slice(5)
    } else {
      return selectedDay
    }
  }

}