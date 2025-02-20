import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { childController } from '../../../model/ChildController'

/**
 * 备注输入控件
 */
@ComponentV2
export default struct RemarkInputView {

  @Param parent: string = ""

  @Local isFocus: boolean = false
  @Local remark: string = ""
  @Param onInputChanged: (text: string) => void = () => {}

  aboutToAppear(): void {
    childController.register(`${this.parent}-${RemarkInputView.name}`, () => {
      this.remark = ""
    })
  }

  build() {
    Row() {
      Image($r('app.media.ic_remark'))
        .width('16vp')
        .height('34vp')
        .objectFit(ImageFit.Contain)
        .align(Alignment.Center)

      Text("备注：")
        .height('34vp')
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .margin({ left: '4vp' })

      Column() {
        TextArea({ placeholder: "在此填写备注...", text: this.remark })
          .placeholderColor(Colors.gray600)
          .placeholderFont({ size: Dimensions.content_text_size })
          .fontColor(Colors.gray1000)
          .fontSize(Dimensions.content_text_size)
          .lineHeight(Dimensions.content_line_size)
          .maxLines(5)
          .alignSelf(ItemAlign.Start)
          .textAlign(TextAlign.Start)
          .padding({ left: 0, right: 0 })
          .flexGrow(1)
          .borderRadius(0)
          .onFocus(() => {
            this.isFocus = true
          })
          .onBlur(() => {
            this.isFocus = false
          })
          .type(TextAreaType.NORMAL)
          .enterKeyType(EnterKeyType.NEW_LINE)
          .onChange((value: string, previewText?: PreviewText) => {
            this.remark = value
            this.onInputChanged(this.remark)
          })

        Divider()
          .strokeWidth('1vp')
          .vertical(false)
          .color(Colors.gray600)
      }
      .width('50%')
      .flexGrow(1)
      .margin({ left: '8vp' })
    }
    .width(Dimensions.FULL_PARENT)
    .flexGrow(1)
    .padding({ left: '24vp', right: '24vp' })
    .margin({ top: '12vp' })
    .alignItems(VerticalAlign.Top)
  }

}